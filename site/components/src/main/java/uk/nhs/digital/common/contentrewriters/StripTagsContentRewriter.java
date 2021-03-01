package uk.nhs.digital.common.contentrewriters;

import org.hippoecm.hst.configuration.hosting.Mount;
import org.hippoecm.hst.content.rewriter.impl.SimpleContentRewriter;
import org.hippoecm.hst.core.request.HstRequestContext;
import org.jsoup.Jsoup;

import javax.jcr.Node;

public class StripTagsContentRewriter extends SimpleContentRewriter {
    public String rewrite(String html, Node hippoHtmlNode, HstRequestContext requestContext, Mount targetMount) {
        html = super.rewrite(html, hippoHtmlNode, requestContext, targetMount);
        return Jsoup.parse(html).text();
    }
}
