package uk.nhs.digital.common.components.info;

import org.hippoecm.hst.core.parameters.*;

@FieldGroupList({
    @FieldGroup(
        titleKey = "CTA document(s)",
        value = {
            "document1",
            "document2",
            "document3",
            "document4",
            "document5",
            "document6"
        }
    ),
    @FieldGroup(
        value = {
            "heading",
            "theme",
            "size",
            "position"
        }
    )
    })
public interface NavigationBlockComponentInfo {

    @Parameter(
        name = "document1",
        required = false,
        displayName = "Document item 1"
        )
    @JcrPath(
        isRelative = true,
        pickerSelectableNodeTypes = {"website:calltoaction"}
        )
    String getDocument1();

    @Parameter(
        name = "document2",
        required = false,
        displayName = "Document item 2"
        )
    @JcrPath(
        isRelative = true,
        pickerSelectableNodeTypes = {"website:calltoaction"}
        )
    String getDocument2();

    @Parameter(
        name = "document3",
        required = false,
        displayName = "Document item 3"
        )
    @JcrPath(
        isRelative = true,
        pickerSelectableNodeTypes = {"website:calltoaction"}
        )
    String getDocument3();

    @Parameter(
        name = "document4",
        required = false,
        displayName = "Document item 4"
        )
    @JcrPath(
        isRelative = true,
        pickerSelectableNodeTypes = {"website:calltoaction"}
        )
    String getDocument4();

    @Parameter(
        name = "document5",
        required = false,
        displayName = "Document item 5"
        )
    @JcrPath(
        isRelative = true,
        pickerSelectableNodeTypes = {"website:calltoaction"}
        )
    String getDocument5();

    @Parameter(
        name = "document6",
        required = false,
        displayName = "Document item 6"
        )
    @JcrPath(
        isRelative = true,
        pickerSelectableNodeTypes = {"website:calltoaction"}
        )
    String getDocument6();

    @Parameter(
        name = "theme",
        required = false,
        defaultValue = "grey",
        displayName = "Navigation block theme"
        )
    @DropDownList({"grey", "colourful", "colourless"})
    String getTheme();

    @Parameter(
        name = "size",
        required = false,
        defaultValue = "large",
        displayName = "Navigation block size"
        )
    @DropDownList({"large", "small"})
    String getSize();

    @Parameter(
        name = "position",
        required = false,
        defaultValue = "bottom-left",
        displayName = "Digi-block position"
        )
    @DropDownList({"bottom-left", "top-left", "top-right", "bottom-right"})
    String getPosition();

    @Parameter(
        name = "heading",
        required = false,
        defaultValue = "",
        displayName = "Section heading"
    )
    String getHeading();
}
