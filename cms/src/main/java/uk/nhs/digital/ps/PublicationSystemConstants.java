package uk.nhs.digital.ps;

import java.time.ZoneId;

public interface PublicationSystemConstants {

    String NODE_TYPE_PUBLICATION = "publicationsystem:publication";
    String NODE_TYPE_LEGACY_PUBLICATION = "publicationsystem:legacypublication";
    String NODE_TYPE_DATASET = "publicationsystem:dataset";
    String NODE_TYPE_DATA_FILE = "publicationsystem:dataFile";
    String NODE_TYPE_CHART = "publicationsystem:chartSection";
    String NODE_TYPE_MAP = "publicationsystem:mapSection";

    String PROPERTY_PUBLICATION_DATE = "publicationsystem:NominalDate";
    String PROPERTY_EARLY_ACCESS_KEY = "publicationsystem:earlyaccesskey";
    String PROPERTY_CHART_CONFIG = "publicationsystem:chartConfig";
    String PROPERTY_CHART_TYPE = "publicationsystem:type";
    String PROPERTY_CHART_TITLE = "publicationsystem:title";
    String PROPERTY_CHART_YTITLE = "publicationsystem:yTitle";

    String PROPERTY_MAP_SOURCE = "publicationsystem:mapSource";

    String INDEX_FILE_NAME = "content";

    ZoneId LONDON_ZONE_ID = ZoneId.of("Europe/London");
    int HOUR_OF_PUBLICATION_RELEASE = 9;
    int MINUTE_OF_PUBLICATION_RELEASE = 30;
}
