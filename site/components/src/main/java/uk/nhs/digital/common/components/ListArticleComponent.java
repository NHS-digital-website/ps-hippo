package uk.nhs.digital.common.components;

import org.hippoecm.hst.core.component.*;
import uk.nhs.digital.common.contentrewriters.*;

public class ListArticleComponent extends BaseGaContentComponent {

    public static final StripTagsContentRewriter stripTagsContentRewriter = new StripTagsContentRewriter();

    @Override
    public void doBeforeRender(final HstRequest request, final HstResponse response) {
        super.doBeforeRender(request, response);

        request.setAttribute("stripTagsContentRewriter", stripTagsContentRewriter);
    }
}
