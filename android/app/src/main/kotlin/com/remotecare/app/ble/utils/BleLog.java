package com.remotecare.app.bp.ble.utils;

import android.util.Log;

/* renamed from: com.drtrust.bp.ble.utils.BleLog */
public final class BleLog {
    private static String defaultTag = "Ble";
    public static boolean isPrint = true;

    private BleLog() {
    }

    public static void setTag(String str) {
        defaultTag = str;
    }

    /* renamed from: i */
    public static int m19i(Object obj) {
        if (!isPrint || obj == null) {
            return -1;
        }
        return Log.i(defaultTag, obj.toString());
    }

    /* renamed from: i */
    public static int m21i(String str) {
        if (!isPrint || str == null) {
            return -1;
        }
        return Log.i(defaultTag, str);
    }

    /* renamed from: v */
    public static int m26v(String str, String str2) {
        if (!isPrint || str2 == null) {
            return -1;
        }
        return Log.v(str, str2);
    }

    /* renamed from: d */
    public static int m12d(String str, String str2) {
        if (!isPrint || str2 == null) {
            return -1;
        }
        return Log.d(str, str2);
    }

    /* renamed from: i */
    public static int m22i(String str, String str2) {
        if (!isPrint || str2 == null) {
            return -1;
        }
        return Log.i(str, str2);
    }

    /* renamed from: w */
    public static int m30w(String str, String str2) {
        if (!isPrint || str2 == null) {
            return -1;
        }
        return Log.w(str, str2);
    }

    /* renamed from: e */
    public static int m16e(String str, String str2) {
        if (!isPrint || str2 == null) {
            return -1;
        }
        return Log.e(str, str2);
    }

    /* renamed from: v */
    public static int m28v(String str, Object... objArr) {
        if (isPrint) {
            return Log.v(str, getLogMessage(objArr));
        }
        return -1;
    }

    /* renamed from: d */
    public static int m14d(String str, Object... objArr) {
        if (isPrint) {
            return Log.d(str, getLogMessage(objArr));
        }
        return -1;
    }

    /* renamed from: i */
    public static int m24i(String str, Object... objArr) {
        if (isPrint) {
            return Log.i(str, getLogMessage(objArr));
        }
        return -1;
    }

    /* renamed from: w */
    public static int m32w(String str, Object... objArr) {
        if (isPrint) {
            return Log.w(str, getLogMessage(objArr));
        }
        return -1;
    }

    /* renamed from: e */
    public static int m18e(String str, Object... objArr) {
        if (isPrint) {
            return Log.e(str, getLogMessage(objArr));
        }
        return -1;
    }

    private static String getLogMessage(Object... objArr) {
        if (objArr == null || objArr.length <= 0) {
            return "";
        }
        StringBuilder sb = new StringBuilder();
        for (Object obj : objArr) {
            sb.append(obj.toString());
        }
        return sb.toString();
    }

    /* renamed from: v */
    public static int m27v(String str, String str2, Throwable th) {
        if (!isPrint || str2 == null) {
            return -1;
        }
        return Log.v(str, str2, th);
    }

    /* renamed from: d */
    public static int m13d(String str, String str2, Throwable th) {
        if (!isPrint || str2 == null) {
            return -1;
        }
        return Log.d(str, str2, th);
    }

    /* renamed from: i */
    public static int m23i(String str, String str2, Throwable th) {
        if (!isPrint || str2 == null) {
            return -1;
        }
        return Log.i(str, str2, th);
    }

    /* renamed from: w */
    public static int m31w(String str, String str2, Throwable th) {
        if (!isPrint || str2 == null) {
            return -1;
        }
        return Log.w(str, str2, th);
    }

    /* renamed from: e */
    public static int m17e(String str, String str2, Throwable th) {
        if (!isPrint || str2 == null) {
            return -1;
        }
        return Log.e(str, str2, th);
    }

    /* renamed from: v */
    public static int m25v(Object obj, String str) {
        if (isPrint) {
            return Log.v(obj.getClass().getSimpleName(), str);
        }
        return -1;
    }

    /* renamed from: d */
    public static int m11d(Object obj, String str) {
        if (isPrint) {
            return Log.d(obj.getClass().getSimpleName(), str);
        }
        return -1;
    }

    /* renamed from: i */
    public static int m20i(Object obj, String str) {
        if (isPrint) {
            return Log.i(obj.getClass().getSimpleName(), str);
        }
        return -1;
    }

    /* renamed from: w */
    public static int m29w(Object obj, String str) {
        if (isPrint) {
            return Log.w(obj.getClass().getSimpleName(), str);
        }
        return -1;
    }

    /* renamed from: e */
    public static int m15e(Object obj, String str) {
        if (isPrint) {
            return Log.e(obj.getClass().getSimpleName(), str);
        }
        return -1;
    }
}
