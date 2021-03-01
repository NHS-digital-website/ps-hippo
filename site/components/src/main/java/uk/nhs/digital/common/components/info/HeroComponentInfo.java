package uk.nhs.digital.common.components.info;

import org.hippoecm.hst.core.parameters.*;

@FieldGroupList({
    @FieldGroup(
        titleKey = "Content selection",
        value = {
            "document",
        }
    ),
    @FieldGroup(
        value = {
            "size", "alignment", "colourBar"
        }
    )
    })
public interface HeroComponentInfo {

    @Parameter(
        name = "document",
        required = true,
        displayName = "Video, Banner or CTA Document"
        )
    @JcrPath(
        isRelative = true,
        pickerSelectableNodeTypes = {"website:calltoaction", "website:bannerdocument", "website:video"}
        )
    String getDocument();

    @Parameter(
        name = "size",
        required = false,
        defaultValue = "tall",
        displayName = "Size of hero"
        )
    @DropDownList({"tall", "small"})
    String getSize();

    @Parameter(
        name = "alignment",
        required = false,
        defaultValue = "left",
        displayName = "Alignment of text"
        )
    @DropDownList({"left", "right"})
    String getTextAlignment();

    @Parameter(
        name = "colourBar",
        required = false,
        defaultValue = "true",
        displayName = "Display colour bar"
        )
    @DropDownList({"true", "false"})
    Boolean getColourBar();
}
