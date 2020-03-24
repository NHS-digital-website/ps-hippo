package uk.nhs.digital.externalstorage.s3;

import org.apache.commons.lang3.time.StopWatch;

import java.io.InputStream;
import java.util.Map;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutorService;
import java.util.function.Consumer;
import java.util.function.Supplier;

/**
 * <p>
 * Processes Amazon S3 file upload and download requests, making sure that only a pre-configured
 * number of them can be actively processed at the same time. Uses separate pools of threads for
 * upload and download, blocking requests (and the calling threads) until pooled threads become available
 * to serve them.
 * </p><p>
 * This class is a proxy for {@linkplain S3SdkConnector}. Note that only upload and download requests are
 * handled as scheduled tasks as they are relatively  long running and consume more resources. All other
 * requests are considered 'cheap' and short running and typically requiring an immediate response, therefore calls to
 * methods serving these are passed on to the {@linkplain S3SdkConnector} immediately and without scheduling.
 * </p><p>
 * Since a non-blocking IO is <em>not</em> being used here (at least our code doesn't have easy
 * access to it), the traditional model of one-HTTP-serving-thread-per-user-request applies.
 * This means that this mechanism <em>does not</em> help reducing the
 * number of HTTP request serving threads being created (managed by application container, such as Tomcat) and waiting
 * dormant until S3-serving-thread (managed by the application) becomes available. What it <em>does</em> help with is
 * reducing the CPU load and memory usage coming from active processing of upload and download streams, which is the
 * most resource hungry phase of serving the upload and download requests. For example, upload process reads the
 * incoming file into memory in 5MB chunks, sending each chunk to S3 before reading another. It's easy to see that, if
 * there was no limit of on the number of actively served requests the risk of using up all available memory is high in
 * cases where many large file upload requests are initiated in a short space of time.
 * </p>
 */
public class BlockingPooledS3Connector implements PooledS3Connector {

    private final S3Connector s3Connector;
    private final ExecutorService downloadExecutorService;
    private final ExecutorService uploadExecutorService;

    private final S3TransfersReportingTracker logger;

    public BlockingPooledS3Connector(final S3Connector s3Connector,
                                     final ExecutorService downloadExecutorService,
                                     final ExecutorService uploadExecutorService,
                                     final S3TransfersReportingTracker logger
    ) {
        this.s3Connector = s3Connector;
        this.downloadExecutorService = downloadExecutorService;
        this.uploadExecutorService = uploadExecutorService;
        this.logger = logger;
    }

    /**
     * See {@linkplain PooledS3Connector#publishResource(String)}.
     */
    @Override
    public void publishResource(final String s3FileReference) {
        logger.reportAction("Making S3 file public: {}", s3FileReference);

        try {
            s3Connector.publishResource(s3FileReference);
        } catch (final Exception ex) {
            logger.reportError("Failed to make S3 file public: " + s3FileReference, ex);
            throw ex;
        }

        logger.reportAction("S3 file is now public: {}", s3FileReference);
    }

    /**
     * See {@linkplain PooledS3Connector#tagResource(String, Map)}.
     */
    @Override
    public void tagResource(String s3FileReference, Map<String, String> tags) {
        logger.reportAction("Tagging S3 resource: {}", s3FileReference);
        try {
            s3Connector.tagResource(s3FileReference, tags);
        } catch (final Exception ex) {
            logger.reportError("Failed to tag S3 resource: " + s3FileReference, ex);
            throw ex;
        }
        logger.reportAction("S3 resource is now tagged: {}", s3FileReference);
    }

    /**
     * See {@linkplain PooledS3Connector#unpublishResource(String)}.
     */
    @Override
    public void unpublishResource(final String s3FileReference) {
        logger.reportAction("Making S3 file private: {}", s3FileReference);

        try {
            s3Connector.unpublishResource(s3FileReference);
        } catch (final Exception ex) {
            logger.reportError("Failed to make S3 file private: " + s3FileReference, ex);
            throw ex;
        }

        logger.reportAction("S3 file is now private: {}", s3FileReference);
    }

    @Override
    public S3ObjectMetadata copyFile(final String sourceS3FileReference, final String fileName) {
        logger.reportAction("Copying S3 file: {}", sourceS3FileReference);

        S3ObjectMetadata targetS3FileReference;
        try {
            targetS3FileReference = s3Connector.copyFile(sourceS3FileReference, fileName);
        } catch (final Exception ex) {
            logger.reportError("Failed to copy S3 file: " + sourceS3FileReference, ex);
            throw ex;
        }

        logger.reportAction(
            "S3 file {} has now been copied to {}", sourceS3FileReference, targetS3FileReference
        );

        return targetS3FileReference;
    }

    /**
     * See {@linkplain PooledS3Connector#upload}.
     */
    @Override
    public S3ObjectMetadata upload(final Supplier<InputStream> inputStreamSupplier,
                                   final String fileName,
                                   final String mimeType
    ) {
        final StopWatch stopWatch = logger.reportUploadScheduling(fileName);

        final S3ObjectMetadata uploadedS3FileMetadata;
        try {
            uploadedS3FileMetadata = waitFor(uploadExecutorService, () -> {
                logger.reportUploadStarting(fileName);

                final S3ObjectMetadata uploadedFileMetadata = s3Connector.uploadFile(
                    inputStreamSupplier.get(), fileName, mimeType
                );

                return uploadedFileMetadata;
            });

            logger.reportUploadStopped(stopWatch,
                uploadedS3FileMetadata.getReference(),
                uploadedS3FileMetadata.getSize()
            );
            return uploadedS3FileMetadata;

        } catch (final RuntimeException re) {
            logger.reportUploadFailed(fileName, re);
            throw re;
        }
    }

    /**
     * See {@linkplain PooledS3Connector#download}.
     */
    @Override
    public void download(final String s3FileReference,
                         final Consumer<S3File> downloadConsumer
    ) {
        final StopWatch stopWatch = logger.reportDownloadScheduling(s3FileReference);

        final S3File downloadedFileMetadata;
        try {
            downloadedFileMetadata = waitFor(downloadExecutorService, () -> {
                logger.reportDownloadStarting(s3FileReference);

                final S3File s3File = s3Connector.downloadFile(s3FileReference);

                downloadConsumer.accept(s3File);

                return s3File;
            });

            logger.reportDownloadStopped(stopWatch, s3FileReference,
                downloadedFileMetadata.getLength()
            );

        } catch (final RuntimeException re) {
            logger.reportDownloadFailed(s3FileReference, re);
            throw re;
        }
    }

    /**
     * Schedules a task that returns a value to the executor and blocks until the task
     * completes, returning the value received from the task.
     */
    private <V> V waitFor(final ExecutorService executorService,
                          final Callable<V> scheduledTask
    ) {
        try {
            return executorService.submit(scheduledTask).get();
        } catch (final Exception ex) {
            throw new RuntimeException(ex);
        }
    }
}
