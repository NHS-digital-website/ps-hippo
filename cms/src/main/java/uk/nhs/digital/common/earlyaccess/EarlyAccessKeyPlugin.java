package uk.nhs.digital.common.earlyaccess;

import org.apache.wicket.ajax.AjaxRequestTarget;
import org.apache.wicket.ajax.markup.html.form.AjaxButton;
//import org.apache.wicket.markup.html.basic.Label;
import org.apache.wicket.markup.html.form.Form;
//import org.apache.wicket.markup.html.panel.Fragment;
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
        LOG.error("--------EarlyAccessKeyPlugin. constructor 1");

        form = getDisabledForm();
        LOG.error("--------EarlyAccessKeyPlugin. constructor 2");
        add(form);
        LOG.error("--------EarlyAccessKeyPlugin. constructor 3");
    }

    @Override
    protected void populateViewItem(Item<IRenderService> item,
        final JcrPropertyValueModel model) {
        LOG.error("--------EarlyAccessKeyPlugin. populateViewItem 1");
        item.add(new FieldContainer("fieldContainer", item));
        LOG.error("--------EarlyAccessKeyPlugin. populateViewItem 2");
        form.setEnabled(false);
        LOG.error("--------EarlyAccessKeyPlugin. populateViewItem 3");
        form.setVisible(false);
        LOG.error("--------EarlyAccessKeyPlugin. populateViewItem 4");
    }

    @Override
    protected void populateEditItem(Item item, final JcrPropertyValueModel model) {
        LOG.error("--------EarlyAccessKeyPlugin. populateEditItem 1");
        LOG.error("-----item primary key=" + item.getPrimaryKey());
        LOG.error("-----item id=" + item.getId());
        LOG.error("-----item markup id=" + item.getMarkupId());
        LOG.error("-----item page relative path=" + item.getPageRelativePath());
        LOG.error("-----item path=" + item.getPath());
        //        LOG.error("-----item primary key=" + item.);
        LOG.error("-----model value=" + model.getValue());
        LOG.error("-----model.toString() =" + model.toString());

        // TODO: THis is working but I do not know how to read the value with jcr
        //Fragment fragment = new Fragment("name", "name", this);
        //fragment.add(new Label("name", "MIGUEL"));
        //add(fragment);

        EditablePropertyFieldContainer fieldContainer = new EditablePropertyFieldContainer(
            "fieldContainer", item, model, this);
        LOG.error("--------EarlyAccessKeyPlugin. populateEditItem 2");
        fieldContainer.setEnabled(false);
        LOG.error("--------EarlyAccessKeyPlugin. populateEditItem 3");
        item.add(fieldContainer);
        LOG.error("--------EarlyAccessKeyPlugin. populateEditItem 4");
        item.setOutputMarkupPlaceholderTag(true);

        LOG.error("--------EarlyAccessKeyPlugin. populateEditItem 5");
        form.addOrReplace(getGenerateButton(model, item));
        LOG.error("--------EarlyAccessKeyPlugin. populateEditItem 6");
        form.addOrReplace(getDeleteButton(model, item));
        LOG.error("--------EarlyAccessKeyPlugin. populateEditItem 7");
        form.setVisible(true);
        LOG.error("--------EarlyAccessKeyPlugin. populateEditItem 8");
        form.setEnabled(true);
        LOG.error("--------EarlyAccessKeyPlugin. populateEditItem 9");
    }


    private String generateKey() {
        LOG.error("--------EarlyAccessKeyPlugin. generateKey 1");

        StringBuilder sb = new StringBuilder(64);
        LOG.error("--------EarlyAccessKeyPlugin. generateKey 2");
        for (int i = 0; i < 64; i++) {
            LOG.error("--------EarlyAccessKeyPlugin. generateKey 3");
            sb.append(ALLOWED_CHARACTERS
                .charAt(RND.nextInt(ALLOWED_CHARACTERS.length())));
            LOG.error("--------EarlyAccessKeyPlugin. generateKey 4");

        }
        LOG.error("--------EarlyAccessKeyPlugin. generateKey 5");

        return sb.toString();
    }

    private AjaxButton getGenerateButton(JcrPropertyValueModel model, Item item) {
        LOG.error("--------EarlyAccessKeyPlugin. getGenerateButton");
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
        LOG.error("--------EarlyAccessKeyPlugin. getDeleteButton");

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
        LOG.error("--------EarlyAccessKeyPlugin. getDisabledForm 1");

        Form htmlForm = new Form("form");
        LOG.error("--------EarlyAccessKeyPlugin. getDisabledForm 2");
        htmlForm.setEnabled(false);
        LOG.error("--------EarlyAccessKeyPlugin. getDisabledForm 3");
        htmlForm.setVisible(false);
        LOG.error("--------EarlyAccessKeyPlugin. getDisabledForm 4");
        htmlForm.add(new AjaxButton("generate"){});
        LOG.error("--------EarlyAccessKeyPlugin. getDisabledForm 5");
        htmlForm.add(new AjaxButton("delete"){});
        LOG.error("--------EarlyAccessKeyPlugin. getDisabledForm 6");
        return htmlForm;
    }
}
