package uk.nhs.digital.common.earlyaccess;

import org.apache.wicket.ajax.AjaxRequestTarget;
import org.apache.wicket.ajax.markup.html.form.AjaxButton;
import org.apache.wicket.markup.html.form.Form;
import org.apache.wicket.markup.repeater.Item;
import org.hippoecm.frontend.editor.plugins.field.EditablePropertyFieldContainer;
import org.hippoecm.frontend.editor.plugins.field.FieldContainer;
import org.hippoecm.frontend.editor.plugins.field.PropertyFieldPlugin;
import org.hippoecm.frontend.model.properties.JcrPropertyValueModel;
import org.hippoecm.frontend.plugin.IPluginContext;
import org.hippoecm.frontend.plugin.config.IPluginConfig;
import org.hippoecm.frontend.service.IRenderService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.security.SecureRandom;
import javax.jcr.RepositoryException;

public class EarlyAccessKeyPlugin extends PropertyFieldPlugin {

    private static final String ALLOWED_CHARACTERS = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
    private static final SecureRandom RND = new SecureRandom();
    private static final Logger LOG = LoggerFactory
        .getLogger(EarlyAccessKeyPlugin.class);

    private final Form form;

    public EarlyAccessKeyPlugin(IPluginContext context, IPluginConfig config) {
        super(context, config);
        form = getDisabledForm();
        add(form);
    }

    @Override
    protected void populateViewItem(Item<IRenderService> item,
        final JcrPropertyValueModel model) {
        item.add(new FieldContainer("fieldContainer", item));
        form.setEnabled(false);
        form.setVisible(false);
    }

    @Override
    protected void populateEditItem(Item item, final JcrPropertyValueModel model) {
        EditablePropertyFieldContainer fieldContainer = new EditablePropertyFieldContainer(
            "fieldContainer", item, model, this);
        fieldContainer.setEnabled(false);
        item.add(fieldContainer);
        item.setOutputMarkupPlaceholderTag(true);

        form.addOrReplace(getGenerateButton(model, item));
        form.addOrReplace(getDeleteButton(model, item));
        form.setVisible(true);
        form.setEnabled(true);
    }

    private String generateKey() {
        StringBuilder sb = new StringBuilder(64);
        for (int i = 0; i < 64; i++) {
            sb.append(ALLOWED_CHARACTERS
                .charAt(RND.nextInt(ALLOWED_CHARACTERS.length())));
        }
        return sb.toString();
    }

    private AjaxButton getGenerateButton(JcrPropertyValueModel model, Item item) {
        AjaxButton generate = new AjaxButton("generate") {
            @Override
            protected void onSubmit(AjaxRequestTarget target, Form<?> form) {
                try {
                    model.getJcrPropertymodel().getProperty()
                        .setValue(generateKey());
                    target.add(item);
                } catch (RepositoryException e) {
                    LOG.error(e.getMessage());
                }
            }
        };
        generate.setDefaultFormProcessing(false);
        return generate;
    }

    private AjaxButton getDeleteButton(JcrPropertyValueModel model, Item item) {
        AjaxButton delete = new AjaxButton("delete") {
            @Override
            public void onSubmit(AjaxRequestTarget target, Form<?> form) {
                try {
                    model.getJcrPropertymodel().getProperty().setValue("");
                    target.add(item);
                } catch (RepositoryException e) {
                    LOG.error(e.getMessage());
                }
            }
        };
        delete.setDefaultFormProcessing(false);
        return delete;
    }

    private Form getDisabledForm() {
        Form htmlForm = new Form("form");
        htmlForm.setEnabled(false);
        htmlForm.setVisible(false);
        htmlForm.add(new AjaxButton("generate"){});
        htmlForm.add(new AjaxButton("delete"){});
        return htmlForm;
    }
}
