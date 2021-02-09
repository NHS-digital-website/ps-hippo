package uk.nhs.digital.ps;

import static java.text.MessageFormat.format;
import static java.time.temporal.ChronoUnit.DAYS;

import org.hippoecm.frontend.validation.ValidationException;
import org.onehippo.cms.services.validation.api.ValidationContext;
import org.onehippo.cms.services.validation.api.ValidationContextException;
import org.onehippo.cms.services.validation.api.Validator;
import org.onehippo.cms.services.validation.api.Violation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import uk.nhs.digital.common.util.TimeProvider;


import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.*;
import javax.jcr.Node;
import javax.jcr.RepositoryException;


@SuppressWarnings("Duplicates")
public class PublicationDateValidator implements Validator<Date> {


    private static final Logger LOGGER = LoggerFactory.getLogger(PublicationDateValidator.class);

    private static final String VALID_PERIOD_YEARS_KEY = "validPeriodLengthInYears";

    private static final String PUBLICLY_ACCESSIBLE_PROPERTY_NAME =
        "publicationsystem:PubliclyAccessible";
    private static final String DATE_PROPERTY_NAME = "publicationsystem:NominalDate";

    private final Long validPeriod;

    @SuppressWarnings("WeakerAccess")
    public PublicationDateValidator(final Node config) {

        try {
            validPeriod = config.getProperty(VALID_PERIOD_YEARS_KEY).getValue().getLong();
        } catch (RepositoryException e) {
            throw new ValidationContextException("Cannot read required property '" + VALID_PERIOD_YEARS_KEY + "'", e);
        }

    }

    @Override
    public Optional<Violation> validate(ValidationContext context, Date value) {

        try {
            if (isPublicationFinalised(context)) {
                return Optional.empty();
            }

            final Calendar publicationDateRaw = getDatePropertyValue(context);
            final Instant serverNow = TimeProvider.getNowInstant();
            final ZoneId zoneId = ZoneId.of("UTC");
            final LocalDate publicationDateInUtc = publicationDateRaw.toInstant().atZone(zoneId).toLocalDate();
            final LocalDate validPeriodDayFirst = serverNow.atZone(zoneId).toLocalDate();
            final LocalDate validPeriodDayLast = validPeriodDayFirst.plusYears(validPeriod).minus(1, DAYS);

            if (publicationDateInUtc.isBefore(validPeriodDayFirst) || publicationDateInUtc.isAfter(validPeriodDayLast)) {
                Map<String, String> variableSub = new HashMap<>();
                variableSub.put("validPeriod", validPeriod.toString());
                return Optional.of(context.createViolation(variableSub));
            }

        } catch (ValidationException e) {
            LOGGER.error("Error occurred during validation ", e);
        }

        return Optional.empty();
    }

    private boolean isPublicationFinalised(final ValidationContext validationContext)
        throws ValidationException {
        return getBooleanPropertyValue(validationContext);
    }

    private Calendar getDatePropertyValue(final ValidationContext validationContext) throws ValidationException {
        try {
            return validationContext.getDocumentNode().getProperty(PublicationDateValidator.DATE_PROPERTY_NAME).getDate();
        } catch (final RepositoryException repositoryException) {
            throw new ValidationException(format(
                "Failed to read property ''{0}'' value", PublicationDateValidator.DATE_PROPERTY_NAME
            ));
        }
    }

    private boolean getBooleanPropertyValue(final ValidationContext validationContext) throws ValidationException {
        try {
            return validationContext.getDocumentNode().getProperty(PublicationDateValidator.PUBLICLY_ACCESSIBLE_PROPERTY_NAME).getBoolean();
        } catch (final RepositoryException repositoryException) {
            throw new ValidationException(format(
                "Failed to read property ''{0}'' value", PublicationDateValidator.PUBLICLY_ACCESSIBLE_PROPERTY_NAME
            ));
        }
    }
}
