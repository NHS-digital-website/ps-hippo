package uk.nhs.digital.ps.components;

import uk.nhs.digital.ps.beans.PublicationBase;

import java.util.Comparator;

public class DateComparator implements Comparator<PublicationBase> {

    public static final DateComparator COMPARATOR = new DateComparator();

    @Override
    public int compare(PublicationBase publicationBase, PublicationBase t1) {
        if (publicationBase.getNominalPublicationDateCalendar() == null || t1.getNominalPublicationDateCalendar() == null ) {
            return 0;
        }
        return publicationBase.getNominalPublicationDateCalendar().compareTo(t1.getNominalPublicationDateCalendar());
    }

}
