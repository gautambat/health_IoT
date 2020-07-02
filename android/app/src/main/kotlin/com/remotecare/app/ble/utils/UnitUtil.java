package com.remotecare.app.bp.ble.utils;

import android.content.Context;

import java.math.BigDecimal;
import java.text.DecimalFormat;

/* renamed from: com.drtrust.bp.utils.UnitUtil */
public class UnitUtil {

    /* renamed from: df */
    private static DecimalFormat f74df;
    private static float unitTypeScale;

    public UnitUtil(Context context) {
        setUnitType();
    }

    public static boolean isMMHG() {
//        return !preferencesService.getUnitType().equals("kpa");
        return true;
    }


    public static String round(double d) {
        return f74df.format(d);
    }

    public static String round(Double d) {
        return new DecimalFormat("###.#").format(d);
    }

    private void setUnitType() {
        if (!isMMHG()) { //TODO
            unitTypeScale = 75.0f;
            f74df = new DecimalFormat("##0.0");
            return;
        }
        unitTypeScale = 10.0f;
        f74df = new DecimalFormat("###");
    }

    public int dividTen(int i) {
        return Math.round(((float) i) / 10.0f);
    }

    public double dividTenDou(int i) {
        double d = (double) i;
        Double.isNaN(d);
        BigDecimal bigDecimal = new BigDecimal(d / 10.0d);
        isMMHG();
        return bigDecimal.setScale(0, 4).doubleValue();
    }

    public int dividUnitType(int i) {
        if (i == 0) {
            return 0;
        }
        return Math.round(((float) i) / unitTypeScale);
    }

    public double getDividDou(int i) {
        BigDecimal bigDecimal = new BigDecimal((double) (((float) i) / unitTypeScale));
        isMMHG();
        return bigDecimal.setScale(0, 4).doubleValue();
    }

    public String getDividStr(int i) {
        return f74df.format((double) (((float) i) / unitTypeScale));
    }

    public String getMutiStr(int i) {
        double dividUnitType = (double) dividUnitType(i);
        if (isMMHG()) {
            return String.valueOf(Math.round(dividUnitType));
        }
        return round(dividUnitType);
    }

//    public String getUnitName() {
//        return preferencesService.getUnitType().equals("kpa") ? AppContext.UNIT_KPA : AppContext.UNIT_MMHG;
//    }

    public String mmhgToString(int i) {
        isMMHG();
        return f74df.format((double) (i / 1));
    }

    public int multiTen(int i) {
        return Math.round(((float) i) * 10.0f);
    }

    public int multiUnitType(double d) {
        double d2 = (double) unitTypeScale;
        Double.isNaN(d2);
        return (int) Math.round(d * d2);
    }
}
