package uk.nhs.digital;


import static uk.nhs.digital.ExceptionUtils.wrapCheckedException;

import org.apache.commons.lang3.Validate;
import org.hippoecm.repository.util.JcrUtils;

import java.sql.Date;
import java.time.Instant;
import java.util.Calendar;
import java.util.Optional;
import java.util.Spliterator;
import java.util.Spliterators;
import java.util.stream.Stream;
import java.util.stream.StreamSupport;
import javax.jcr.Node;
import javax.jcr.NodeIterator;
import javax.jcr.Session;

public abstract class JcrNodeUtils {

    @SuppressWarnings("unchecked") // it's guaranteed that NodeIterator operates on instances of Node class
    public static Stream<Node> streamOf(final NodeIterator nodeIterator) {

        return StreamSupport.stream(
            Spliterators.<Node>spliteratorUnknownSize(nodeIterator, Spliterator.ORDERED),
            false
        );
    }

    public static Session getSessionQuietly(final Node node) {
        return wrapCheckedException(node::getSession);
    }

    public static Optional<Boolean> getBooleanPropertyQuietly(final Node node, final String propertyName) {
        return Optional.ofNullable(
            wrapCheckedException(() -> JcrUtils.getBooleanProperty(node, propertyName, null))
        );
    }

    public static Optional<String> getStringPropertyQuietly(final Node node, final String propertyName) {
        return Optional.ofNullable(
            wrapCheckedException(() -> JcrUtils.getStringProperty(node, propertyName, null))
        );
    }

    public static void setStringPropertyQuietly(final Node node, final String propertyName, final String value) {
        wrapCheckedException(() -> node.setProperty(propertyName, value));
    }

    public static void setInstantPropertyQuietly(final Node node, final String propertyName, final Instant instant) {
        wrapCheckedException(() -> node.setProperty(propertyName, calendarFrom(instant)));
    }

    public static Optional<Instant> getInstantPropertyQuietly(final Node node, final String propertyName) {
        return wrapCheckedException(() ->
                Optional.ofNullable(JcrUtils.getDateProperty(node, propertyName, null)).map(Calendar::toInstant)
        );
    }

    public static void validateIsOfTypeHandle(final Node documentHandleCandidateNode) {
        Validate.isTrue(
            wrapCheckedException(() -> documentHandleCandidateNode.isNodeType("hippo:handle")),
            "Node's 'jcr:primaryType' property has to be of type 'hippo:handle'"
        );
    }

    private static Calendar calendarFrom(final Instant instant) {
        return new Calendar.Builder().setInstant(Date.from(instant)).build();
    }
}
