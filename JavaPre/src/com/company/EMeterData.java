package com.company;

import java.text.Format;
import java.text.SimpleDateFormat;
import java.util.Comparator;
import java.util.Date;

/**
 * Created by Emin Guliyev on 12/05/2015.
 */
public class EMeterData implements Comparable<EMeterData> {
    public int eMeterId;
    public Date date;
    public double supplyAmount;
    public static Format formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm");
    public EMeterData(int eMeterId, Date date, double supplyAmount) {
        this.eMeterId = eMeterId;
        this.date = date;
        this.supplyAmount = supplyAmount;
    }

    @Override
    public int compareTo(EMeterData eMeter2) {
        EMeterData eMeter1 = this;
        int c;
        c = ((Integer)eMeter1.eMeterId).compareTo(eMeter2.eMeterId);
        if (c == 0)
            c = eMeter1.date.compareTo(eMeter2.date);
        return c;
    }

    @Override
    public String toString(){
        return eMeterId + "," + formatter.format(date) + "," + supplyAmount + ",";
    }
}
