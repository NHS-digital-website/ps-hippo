package uk.nhs.digital.externalstorage.s3;

import java.io.InputStream;
import java.util.Map;
import java.util.function.Consumer;
import java.util.function.Supplier;

/**
 * See the implementing {@linkplain uk.nhs.digital.externalstorage.s3.BlockingPooledS3Connector} class for details.
 */
public interface PooledS3Connector {

    /**
     * Instantly triggers permissions on the given S3 file to be set to 'public' by delegating the call directly to
     * {@linkplain uk.nhs.digital.externalstorage.s3.S3SdkConnector#publishResource} method.
     */
    void publishResource(String objectPath);

    /**
     * Instantly sets tags on the given S3 file by delegating the call directly to
     * {@linkplain uk.nhs.digital.externalstorage.s3.S3SdkConnector#tagResource} method.
     */
    void tagResource(String objectPath, Map<String, String> tags);

    /**
     * Instantly triggers permissions on the given S3 file to be set to 'restricted' by delegating the call directly to
     * {@linkplain uk.nhs.digital.externalstorage.s3.S3SdkConnector#unpublishResource} method.
     */
    void unpublishResource(String objectPath);

    /**
     * Instantly triggers copying of given S3 file by delegating the call directly to
     * {@linkplain uk.nhs.digital.externalstorage.s3.S3SdkConnector#copyFile} method.
     *
     * @return Reference of the newly created copy.
     */
    S3ObjectMetadata copyFile(String sourceS3FileReference, String fileName);

    /**
     * <p>
     * Schedules a download from S3 as a task to be executed as soon as one of the pooled threads becomes available,
     * leaving the processing of the download input stream to the callback given as an argument. Blocks the calling
     * thread until the callback finishes processing the download.
     * <p/><p>
     * The callback receives a reference to {@linkplain S3File} which exposes download input stream via
     * {@linkplain S3File#getContent()}.
     * <p/><p>
     * <strong>Important</strong>:
     * <ul>
     * <li>Make sure that the processing of that stream takes place within the callback, to ensure that it's being
     * processed by the pooled thread; failing to do it this way (say, by returning the stream to outside of the
     * callback and processing it there) defeats the limitation of only a pre-defined number of requests being
     * actively processed concurrently, thus risking starving the whole application of resources.</li>
     * <li>Close the input stream as soon as you're done with it, preferably within the callback.</li>
     * </ul>
     * </p>
     *
     * @param s3FileReference  S3 file key.
     * @param downloadConsumer Callback to execute once the download actually gets initiated
     *                         and the download input stream becomes available.
     */
    void download(String s3FileReference, Consumer<S3File> downloadConsumer);

    /**
     * <p>
     * Schedules an upload to S3 as a task to be executed as soon as one of the pooled threads becomes available.
     * Blocks the calling thread until the upload is complete.
     * </p><p>
     * </p>
     *
     * @param inputStreamSupplier Provider of the input stream of the file being uploaded. Wrapping the stream in
     *                            a supplier allows to access the stream as late as possible, that is when the task
     *                            is actually being executed rather than at the point of it being scheduled.
     *                            If the method of obtaining the stream declares a checked exception, a conveninence
     *                            method {@linkplain PooledS3Connector#wrapCheckedException} can be used to avoid
     *                            having to deal with try-catch boilerplate code.
     * @param fileName            Name of the uploaded file.
     * @param mimeType            Type of the uploaded file.
     */
    S3ObjectMetadata upload(Supplier<InputStream> inputStreamSupplier,
                            String fileName,
                            String mimeType);

    /**
     * 'Syntactic sugar' method that takes a supplier throwing checked exception and wraps it in a
     * try-catch clause, rethrowing the original exception wrapped in {@linkplain RuntimeException},
     * thus preventing obscuring the calling code with a boilerplate try-catch-rethrow code at the
     * point of calling.
     *
     * @param checkedExceptionThrowingSupplier The supplier to wrap.
     * @param <T>                              Type of the value returned by the supplier.
     * @return Original supplier wrapped in a rethrowing code.
     */
    static <T> Supplier<T> wrapCheckedException(CheckedExceptionThrowingSupplier<T> checkedExceptionThrowingSupplier) {
        return () -> {
            try {
                return checkedExceptionThrowingSupplier.get();
            } catch (final Exception ex) {
                throw new RuntimeException(ex);
            }
        };
    }

    interface CheckedExceptionThrowingSupplier<T> {
        T get() throws Exception;
    }
}
