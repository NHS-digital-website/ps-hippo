package uk.nhs.digital.ps.beans;

import java.util.Date;

public class Pair<K,V> {

    private K type;
    private V object;
    private Date date;

    public Pair(K type, V object, Date date) {
        this.type = type;
        this.object = object;
        this.date = date;
    }

    public Pair() {

    }

    public K getType() {
        return type;
    }

    public V getObject() {
        return object;
    }

    public Date getDate() {
        return date;
    }
}
