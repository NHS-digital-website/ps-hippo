package uk.nhs.digital.common.components.info;


import org.hippoecm.hst.core.parameters.*;

@FieldGroupList({@FieldGroup(
    value = {"banner"}
    ),
    @FieldGroup(
    titleKey = "Layout",
    value = {"alignment", "colour", "digiblockposition"}
    ),
    @FieldGroup(
    titleKey = "Button 1",
    value = {"button1text", "button1url"}
    ),
    @FieldGroup(
    titleKey = "Button 2",
    value = {"button2text", "button2url"}
)})
public interface HeaderComponentInfo {
    @Parameter(
        name = "banner",
        displayName = "Banner",
        required = true
        )
    @JcrPath(
        pickerSelectableNodeTypes = {"website:bannerdocument"},
        pickerInitialPath = "/content/documents",
        isRelative = true
    )
    String getBannerDoc();

    @Parameter(
        name = "alignment",
        required = true,
        defaultValue = "Centre",
        displayName = "Text Alignment"
        )
    @DropDownList({"Centre", "Left"})
    String getAlignment();

    @Parameter(
        name = "colour",
        required = true,
        defaultValue = "Light Grey",
        displayName = "Style"
        )
    @DropDownList({"Light Grey", "Dark Grey", "Blue", "Yellow"})
    String getColour();

    @Parameter(
        name = "digiblockposition",
        required = true,
        defaultValue = "Left & Right",
        displayName = "Digiblock Position"
        )
    @DropDownList({"Left & Right", "Right"})
    String getDigiblockPosition();

    @Parameter(
        name = "button1text",
        displayName = "Text"
    )
    String getButton1Text();

    @Parameter(
        name = "button1url",
        displayName = "URL"
    )
    String getButton1Url();

    @Parameter(
        name = "button2text",
        displayName = "Text"
    )
    String getButton2Text();

    @Parameter(
        name = "button2url",
        displayName = "URL"
    )
    String getButton2Url();
}
