package uk.nhs.digital.apispecs;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;
import static org.hippoecm.repository.util.WorkflowUtils.Variant.PUBLISHED;
import static org.hippoecm.repository.util.WorkflowUtils.Variant.UNPUBLISHED;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.BDDMockito.given;
import static org.mockito.BDDMockito.then;
import static org.mockito.Mockito.times;
import static org.mockito.MockitoAnnotations.initMocks;
import static org.powermock.api.mockito.PowerMockito.*;

import org.hippoecm.repository.api.Document;
import org.hippoecm.repository.util.WorkflowUtils;
import org.junit.Before;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.ExpectedException;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.onehippo.forge.content.exim.core.DocumentManager;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;
import uk.nhs.digital.JcrDocumentUtils;
import uk.nhs.digital.JcrNodeUtils;
import uk.nhs.digital.apispecs.jcr.JcrDocumentLifecycleSupport;
import uk.nhs.digital.test.util.ReflectionTestUtils;

import java.time.Instant;
import java.util.Optional;
import javax.jcr.Node;
import javax.jcr.RepositoryException;
import javax.jcr.Session;

@RunWith(PowerMockRunner.class)
@PrepareForTest({JcrDocumentUtils.class, JcrNodeUtils.class, WorkflowUtils.class})
public class JcrDocumentLifecycleSupportTest {

    @Rule public ExpectedException expectedException = ExpectedException.none();

    @Mock private Node documentHandleNode;
    @Mock private Node draftNodeCheckedOut;
    @Mock private Session session;
    @Mock private DocumentManager documentManager;
    @Mock private Document draftDocumentVariant;

    private JcrDocumentLifecycleSupport jcrDocumentLifecycleSupport;

    @Before
    public void setUp() throws Exception {
        initMocks(this);

        given(documentHandleNode.isNodeType("hippo:handle")).willReturn(true);
        given(documentHandleNode.getSession()).willReturn(session);
        given(documentManager.obtainEditableDocument(documentHandleNode)).willReturn(draftDocumentVariant);
        given(draftDocumentVariant.getCheckedOutNode(session)).willReturn(draftNodeCheckedOut);

        mockStatic(JcrDocumentUtils.class);
        given(JcrDocumentUtils.documentManagerFor(session)).willReturn(documentManager);

        jcrDocumentLifecycleSupport = JcrDocumentLifecycleSupport.from(documentHandleNode);
    }

    @Test
    public void setProperty_updatesPropertyWithGivenValueOnDraftVariant() throws Exception {

        // given
        final String expectedPropertyName = "aPropertyName";
        final String expectedPropertyValue = "aPropertyValue";

        // when
        jcrDocumentLifecycleSupport.setStringProperty(expectedPropertyName, expectedPropertyValue);

        // then
        then(draftNodeCheckedOut).should().setProperty(expectedPropertyName, expectedPropertyValue);
    }

    @Test
    public void setProperty_throwsException_onFailure() {

        // given
        final String expectedPropertyName = "aPropertyName";
        final String expectedPropertyValue = "aPropertyValue";

        final RuntimeException originalException = new RuntimeException();

        mockStatic(JcrDocumentUtils.class);
        given(JcrDocumentUtils.documentManagerFor(any())).willThrow(originalException);

        expectedException.expect(RuntimeException.class);
        expectedException.expectMessage(startsWith("Failed to update property " + expectedPropertyName + " on "));
        expectedException.expectCause(sameInstance(originalException));

        // when
        jcrDocumentLifecycleSupport.setStringProperty(expectedPropertyName, expectedPropertyValue);

        // then
        // expectations set in 'given' are satisfied
    }

    @Test
    public void getStringProperty_returnsPropertyValueFromNodeOfRequestedDocumentVariant() throws RepositoryException {

        // given
        final String propertyName = "aPropertyName";
        final Optional<String> expectedPropertyValue = Optional.of("expectedPropertyValue");

        final Node documentVariantNode = mock(Node.class);
        final Optional<Node> documentVariantNodeOptional = Optional.of(documentVariantNode);

        final WorkflowUtils.Variant expectedDocumentVariantType = UNPUBLISHED;

        mockStatic(WorkflowUtils.class);
        given(WorkflowUtils.getDocumentVariantNode(any(Node.class), any(WorkflowUtils.Variant.class)))
            .willReturn(documentVariantNodeOptional);

        mockStatic(JcrNodeUtils.class);
        given(JcrNodeUtils.getStringPropertyQuietly(any(Node.class), any(String.class)))
            .willReturn(expectedPropertyValue);

        // when
        final Optional<String> actualPropertyValue =
            jcrDocumentLifecycleSupport.getStringProperty(propertyName, expectedDocumentVariantType);

        // then
        assertThat(
            "Value returned was read from requested document variant node",
            actualPropertyValue,
            is(expectedPropertyValue)
        );

        verifyStatic(WorkflowUtils.class);
        WorkflowUtils.getDocumentVariantNode(documentHandleNode, expectedDocumentVariantType);

        verifyStatic(JcrNodeUtils.class);
        JcrNodeUtils.getStringPropertyQuietly(documentVariantNode, propertyName);
    }

    @Test
    public void getStringProperty_throwsException_onFailure() {

        // given
        final RuntimeException collaboratorException = new RuntimeException();

        mockStatic(WorkflowUtils.class);
        given(WorkflowUtils.getDocumentVariantNode(any(Node.class), any(WorkflowUtils.Variant.class)))
            .willThrow(collaboratorException);

        expectedException.expect(sameInstance(collaboratorException));

        // when
        jcrDocumentLifecycleSupport.getStringProperty("aPropertyName", UNPUBLISHED);

        // then
        // expectations set in 'given' are satisfied
    }

    @Test
    public void getLastPublicationInstant_returnsValueFromNodeOfPublishedDocumentVariant() {

        // given
        final String expectedPropertyName = "hippostdpubwf:publicationDate";

        final Optional<Instant> expectedPropertyValue = Optional.of(Instant.parse("2020-05-04T10:30:00.000Z"));

        final Node documentVariantNode = mock(Node.class);
        final Optional<Node> documentVariantNodeOptional = Optional.of(documentVariantNode);

        mockStatic(WorkflowUtils.class);
        given(WorkflowUtils.getDocumentVariantNode(any(Node.class), any(WorkflowUtils.Variant.class)))
            .willReturn(documentVariantNodeOptional);

        mockStatic(JcrNodeUtils.class);
        given(JcrNodeUtils.getInstantPropertyQuietly(any(Node.class), any(String.class)))
            .willReturn(expectedPropertyValue);

        // when
        final Optional<Instant> actualPropertyValue = jcrDocumentLifecycleSupport.getLastPublicationInstant();

        // then
        assertThat(
            "Value returned was read from unpublished document variant node",
            actualPropertyValue,
            is(expectedPropertyValue)
        );

        verifyStatic(WorkflowUtils.class);
        WorkflowUtils.getDocumentVariantNode(documentHandleNode, PUBLISHED);

        verifyStatic(JcrNodeUtils.class);
        JcrNodeUtils.getInstantPropertyQuietly(documentVariantNode, expectedPropertyName);
    }

    @Test
    public void getLastPublicationInstant_throwsException_onFailure() {

        // given
        final RuntimeException collaboratorException = new RuntimeException();

        mockStatic(WorkflowUtils.class);
        given(WorkflowUtils.getDocumentVariantNode(any(Node.class), any(WorkflowUtils.Variant.class)))
            .willThrow(collaboratorException);

        expectedException.expect(sameInstance(collaboratorException));

        // when
        jcrDocumentLifecycleSupport.getLastPublicationInstant();

        // then
        // expectations set in 'given' are satisfied
    }

    @Test
    public void saveAndPublish_savesChangeAndPublishesDocument_whenChangesMade() {

        // given
        jcrDocumentLifecycleSupport.setStringProperty("aPropertyName", "aPropertyValue");

        // when
        jcrDocumentLifecycleSupport.saveAndPublish();

        // then
        verifyStatic(JcrDocumentUtils.class);
        JcrDocumentUtils.saveQuietly(session);

        verifyStatic(JcrDocumentUtils.class);
        JcrDocumentUtils.publish(documentHandleNode);
    }

    @Test
    public void saveAndPublish_doesNotSaveChangesButPublishesDocument_whenNoChangesMadeButUnpublishedVersionAvailable() {

        // given
        // no changes applied to the document

        // when
        jcrDocumentLifecycleSupport.saveAndPublish();

        // then
        verifyStatic(JcrDocumentUtils.class, times(0));
        JcrDocumentUtils.saveQuietly(session);

        verifyStatic(JcrDocumentUtils.class);
        JcrDocumentUtils.publish(documentHandleNode);
    }

    @Test
    public void saveAndPublish_throwsException_onSaveFailure() {

        // given
        jcrDocumentLifecycleSupport // sets 'dirty' flag which enables 'save' and 'publish'
            .setStringProperty("aPropertyName", "aPropertyValue");

        final RuntimeException collaboratorException = new RuntimeException();

        mockStatic(JcrNodeUtils.class);
        given(JcrNodeUtils.getSessionQuietly(any(Node.class)))
            .willThrow(collaboratorException);

        expectedException.expect(RuntimeException.class);
        expectedException.expectMessage(startsWith("Failed to save"));
        expectedException.expectCause(sameInstance(collaboratorException));

        // when
        jcrDocumentLifecycleSupport.saveAndPublish();

        // then
        // expectations set in 'given' are satisfied
    }

    @Test
    public void saveAndPublish_throwsException_onPublishFailure() throws Exception {

        // given
        jcrDocumentLifecycleSupport // sets 'dirty' flag which enables 'save' and 'publish'
            .setStringProperty("aPropertyName", "aPropertyValue");

        final RuntimeException collaboratorException = new RuntimeException();

        mockStatic(JcrDocumentUtils.class);
        doThrow(collaboratorException).when(JcrDocumentUtils.class, "publish", documentHandleNode);

        expectedException.expect(RuntimeException.class);
        expectedException.expectMessage(startsWith("Failed to publish"));
        expectedException.expectCause(sameInstance(collaboratorException));

        // when
        jcrDocumentLifecycleSupport.saveAndPublish();

        // then
        // expectations set in 'given' are satisfied
    }

    @Test
    public void from_returnsNewInstance_initialisedWithGivenHandleNode() {

        // given
        // documentHandleNode

        // when
        final JcrDocumentLifecycleSupport jcrDocumentLifecycleSupport = JcrDocumentLifecycleSupport.from(documentHandleNode);

        // then
        final Node actualDocumentHandleNode =
            ReflectionTestUtils.readField(jcrDocumentLifecycleSupport, "documentHandleNode");

        assertThat(
            "Instance initialised with given document handle node.",
            actualDocumentHandleNode,
            sameInstance(documentHandleNode)
        );
    }

    @Test
    public void from_throwsException_whenNodeNotOfTypeHandle() throws RepositoryException {

        // given
        given(documentHandleNode.isNodeType("hippo:handle")).willReturn(false);
        given(documentHandleNode.toString()).willReturn("testDocumentHandleNode");

        expectedException.expect(RuntimeException.class);
        expectedException.expectMessage("Failed to create document object for testDocumentHandleNode");

        // when
        JcrDocumentLifecycleSupport.from(documentHandleNode);

        // then
        // expectations set up in 'given' are satisfied
    }
}