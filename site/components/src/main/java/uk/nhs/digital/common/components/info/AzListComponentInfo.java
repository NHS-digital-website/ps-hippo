package uk.nhs.digital.common.components.info;

import org.hippoecm.hst.core.parameters.*;

public interface AzListComponentInfo {
    @Parameter(
        name = "headerText",
        displayName = "Header Text"
    )
    String getHeaderText();

    @Parameter(
        name = "buttonText",
        displayName = "Button Text"
    )
    String getButtonText();

    @Parameter(
        name = "navigationDocument",
        displayName = "Navigation Document",
        required = true
        )
    @JcrPath(
        pickerSelectableNodeTypes = {"website:componentlist", "website:glossarylist"},
        pickerInitialPath = "/content/documents",
        isRelative = true
    )
    String getNavigationDocument();
}
