package com.remotecare.app.bp.ble.utils;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

/* renamed from: com.drtrust.bp.utils.DateUtil */
public class DateUtil {
    public static String timeStamp2Date(String str, String str2) {
        if (str == null || str.isEmpty() || str.equals("null")) {
            return "";
        }
        if (str2 == null || str2.isEmpty()) {
            str2 = "yyyy-MM-dd HH:mm:ss";
        }
        return new SimpleDateFormat(str2).format(new Date(Long.valueOf(str).longValue()));
    }

    public static String timeStamp2Date(long j) {
        return new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date(Long.valueOf(j).longValue()));
    }

    public static String date2TimeStamp(String str, String str2) {
        try {
            return String.valueOf(new SimpleDateFormat(str2).parse(str).getTime());
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }

    public static long dateToStamp(String str) {
        try {
            return new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(str).getTime();
        } catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
    }

    public static String stampToDate(long j, String str) {
        return new SimpleDateFormat(str).format(new Date(j));
    }

    public static int dayForWeek(String str) {
        try {
            SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
            Calendar instance = Calendar.getInstance();
            instance.setTime(simpleDateFormat.parse(str));
            if (instance.get(7) == 1) {
                return 7;
            }
            return instance.get(7) - 1;
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public static String timeStamp() {
        return String.valueOf(System.currentTimeMillis());
    }

    public static String getBirthday(int i, int i2, int i3) {
        StringBuilder sb;
        String str;
        String str2 = "0";
        String str3 = "";
        if (i2 < 10) {
            sb = new StringBuilder();
            sb.append(str2);
        } else {
            sb = new StringBuilder();
            sb.append(str3);
        }
        sb.append(i2);
        String sb2 = sb.toString();
        if (i3 < 10) {
            StringBuilder sb3 = new StringBuilder();
            sb3.append(str2);
            sb3.append(i3);
            str = sb3.toString();
        } else {
            StringBuilder sb4 = new StringBuilder();
            sb4.append(str3);
            sb4.append(i3);
            str = sb4.toString();
        }
        StringBuilder sb5 = new StringBuilder();
        sb5.append(i);
        String str4 = "-";
        sb5.append(str4);
        sb5.append(sb2);
        sb5.append(str4);
        sb5.append(str);
        return sb5.toString();
    }
}
