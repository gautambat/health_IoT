package com.remotecare.app.bp.ble.utils;

import android.util.Log;

/* renamed from: com.drtrust.bp.utils.BPLog */
public final class BPLog {
    private static boolean sIsLogEnabled = true;

    /* renamed from: d */
    public static void m33d(String str, String str2) {
        if (sIsLogEnabled) {
            StringBuilder sb = new StringBuilder();
            sb.append("-----> ");
            sb.append(str2);
            Log.d(str, sb.toString());
        }
    }

    /* renamed from: e */
    public static void m34e(String str, String str2) {
        if (sIsLogEnabled) {
            StringBuilder sb = new StringBuilder();
            sb.append("-----> ");
            sb.append(str2);
            Log.e(str, sb.toString());
        }
    }
}
