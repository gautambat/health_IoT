package com.remotecare.app.bp.ble.utils;

import android.content.Context;
import android.content.SharedPreferences.Editor;

import com.remotecare.app.R;
import com.remotecare.app.RemoteCare;
import com.remotecare.app.bp.ble.data.RecordInfo;


/* renamed from: com.drtrust.bp.utils.Common */
public class Common {
    private static String app_config_file = "app_config";

//    public static int getPowerResId(int i) {
//        return i > 95 ? R.drawable.btn_power_100 : i > 90 ? R.drawable.btn_power_90 : i > 80 ? R.drawable.btn_power_80 : i > 70 ? R.drawable.btn_power_70 : i > 60 ? R.drawable.btn_power_60 : i > 50 ? R.drawable.btn_power_50 : i > 40 ? R.drawable.btn_power_40 : i > 30 ? R.drawable.btn_power_30 : i > 20 ? R.drawable.btn_power_20 : i > 10 ? R.drawable.btn_power_10 : R.drawable.btn_power_0;
//    }

    public static boolean isFirstRunApp(Context context) {
        return context.getSharedPreferences(app_config_file, 0).getBoolean("isFirstRun", true);
    }

    public static boolean setIsNotFirstRunApp(Context context) {
        Editor edit = context.getSharedPreferences(app_config_file, 0).edit();
        edit.putBoolean("isFirstRun", false);
        return edit.commit();
    }

    public static String getUnitType(Context context) {
        return context.getSharedPreferences(app_config_file, 0).getString("UnitType", RemoteCare.UNIT_MMHG);
    }

    public static boolean setUnitType(Context context, String str) {
        Editor edit = context.getSharedPreferences(app_config_file, 0).edit();
        edit.putString("UnitType", str);
        return edit.commit();
    }

    public static String getMeasureResultLevel(Context context, RecordInfo recordInfo) {
        int i = recordInfo.getSys();
        int i2 = recordInfo.getDia();
        if (i >= 180 || i2 >= 110) {
            return context.getString(R.string.measure_page_level_severe);
        }
        if (i >= 160 || i2 >= 100) {
            return context.getString(R.string.measure_page_level_moderate);
        }
        if (i >= 140 || i2 >= 90) {
            return context.getString(R.string.measure_page_level_mild);
        }
        if (i >= 130 || i2 >= 85) {
            return context.getString(R.string.measure_page_level_highnormal);
        }
        if (i >= 120 || i2 >= 80) {
            return context.getString(R.string.measure_page_level_normal);
        }
        return context.getString(R.string.measure_page_level_optimal);
    }

    public static int getgetMeasureResultLevelAngle(RecordInfo recordInfo) {
        int i = recordInfo.getSys();
        int i2 = recordInfo.getDia();
        if (i >= 190 || i2 >= 120) {
            return 180;
        }
        if (i >= 189 || i2 >= 119) {
            return 177;
        }
        if (i >= 188 || i2 >= 118) {
            return 174;
        }
        if (i >= 187 || i2 >= 117) {
            return 171;
        }
        if (i >= 186 || i2 >= 116) {
            return 168;
        }
        if (i >= 185 || i2 >= 115) {
            return 165;
        }
        if (i >= 184 || i2 >= 114) {
            return 162;
        }
        if (i >= 183 || i2 >= 113) {
            return 159;
        }
        if (i >= 182 || i2 >= 112) {
            return 156;
        }
        if (i >= 181 || i2 >= 111) {
            return 153;
        }
        if (i >= 180 || i2 >= 110) {
            return 150;
        }
        if (i >= 178 || i2 >= 109) {
            return 147;
        }
        if (i >= 176 || i2 >= 108) {
            return 144;
        }
        if (i >= 174 || i2 >= 107) {
            return 141;
        }
        if (i >= 172 || i2 >= 106) {
            return 138;
        }
        if (i >= 170 || i2 >= 105) {
            return 135;
        }
        if (i >= 168 || i2 >= 104) {
            return 132;
        }
        if (i >= 166 || i2 >= 103) {
            return 129;
        }
        if (i >= 164 || i2 >= 102) {
            return 126;
        }
        if (i >= 162 || i2 >= 101) {
            return 123;
        }
        if (i >= 160 || i2 >= 100) {
            return 120;
        }
        if (i >= 158 || i2 >= 99) {
            return 117;
        }
        if (i >= 156 || i2 >= 98) {
            return 114;
        }
        if (i >= 154 || i2 >= 97) {
            return 111;
        }
        if (i >= 152 || i2 >= 96) {
            return 108;
        }
        if (i >= 150 || i2 >= 95) {
            return 105;
        }
        if (i >= 148 || i2 >= 94) {
            return 102;
        }
        if (i >= 146 || i2 >= 93) {
            return 99;
        }
        if (i >= 144 || i2 >= 92) {
            return 96;
        }
        if (i >= 142 || i2 >= 91) {
            return 93;
        }
        if (i >= 140 || i2 >= 90) {
            return 90;
        }
        if (i >= 139 || i2 >= 90) {
            return 87;
        }
        if (i >= 138 || i2 >= 89) {
            return 84;
        }
        if (i >= 137 || i2 >= 89) {
            return 81;
        }
        if (i >= 136 || i2 >= 88) {
            return 78;
        }
        if (i >= 135 || i2 >= 88) {
            return 75;
        }
        if (i >= 134 || i2 >= 87) {
            return 72;
        }
        if (i >= 133 || i2 >= 87) {
            return 69;
        }
        if (i >= 132 || i2 >= 86) {
            return 66;
        }
        if (i >= 131 || i2 >= 86) {
            return 63;
        }
        if (i >= 130 || i2 >= 85) {
            return 60;
        }
        if (i >= 129 || i2 >= 85) {
            return 57;
        }
        if (i >= 128 || i2 >= 84) {
            return 54;
        }
        if (i >= 127 || i2 >= 84) {
            return 51;
        }
        if (i >= 126 || i2 >= 83) {
            return 48;
        }
        if (i >= 125 || i2 >= 83) {
            return 45;
        }
        if (i >= 124 || i2 >= 82) {
            return 42;
        }
        if (i >= 123 || i2 >= 82) {
            return 39;
        }
        if (i >= 122 || i2 >= 81) {
            return 36;
        }
        if (i >= 121 || i2 >= 81) {
            return 33;
        }
        if (i >= 120 || i2 >= 80) {
            return 30;
        }
        if (i >= 119 || i2 >= 80) {
            return 27;
        }
        if (i >= 118 || i2 >= 79) {
            return 24;
        }
        if (i >= 117 || i2 >= 79) {
            return 21;
        }
        if (i >= 116 || i2 >= 78) {
            return 18;
        }
        if (i >= 115 || i2 >= 78) {
            return 15;
        }
        if (i >= 114 || i2 >= 77) {
            return 12;
        }
        if (i >= 113 || i2 >= 77) {
            return 9;
        }
        if (i >= 112 || i2 >= 76) {
            return 6;
        }
        return (i >= 111 || i2 >= 75) ? 3 : 0;
    }

    public static float mmHgTokPa(int i) {
        return ((float) Math.round((((float) i) / 7.5f) * 10.0f)) / 10.0f;
    }
}
