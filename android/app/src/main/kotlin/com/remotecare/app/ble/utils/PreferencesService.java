package com.remotecare.app.bp.ble.utils;

import android.content.Context;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;

import java.util.HashMap;
import java.util.Map;

/* renamed from: com.drtrust.bp.utils.PreferencesService */
public class PreferencesService {
    private Context context;

    public PreferencesService(Context context2) {
        this.context = context2;
    }

    public String getADDName() {
        return this.context.getSharedPreferences("ADDUSERNAME", 0).getString("UPDATEINFO", "");
    }

    public boolean getGroupSendTrue() {
        return this.context.getSharedPreferences("UserName", 0).getBoolean("GroupSend", false);
    }

    public int getId() {
        return this.context.getSharedPreferences("UserifnoIdall", 0).getInt("UserifnoId", 0);
    }

    public String getLastDevAddr() {
        return this.context.getSharedPreferences("UserName", 0).getString("lastDev", null);
    }

    public String getName() {
        return this.context.getSharedPreferences("UserName", 0).getString("UserifnoName", "");
    }

    public Map<String, String> getPersonPreferences() {
        HashMap hashMap = new HashMap();
        SharedPreferences sharedPreferences = this.context.getSharedPreferences("personpreferences", 0);
        String str = "height";
        hashMap.put(str, sharedPreferences.getString(str, "185"));
        String str2 = "stride";
        hashMap.put(str2, String.valueOf(sharedPreferences.getString(str2, "71.5")));
        String str3 = "weight";
        hashMap.put(str3, sharedPreferences.getString(str3, "75.0"));
        return hashMap;
    }

    public Map<String, String> getPersonPreferencesAlarm() {
        HashMap hashMap = new HashMap();
        SharedPreferences sharedPreferences = this.context.getSharedPreferences("personpreferencesAlarm", 0);
        String str = "0";
        String str2 = "nSelectPer";
        hashMap.put(str2, sharedPreferences.getString(str2, str));
        String str3 = "dAlarmCycle";
        hashMap.put(str3, sharedPreferences.getString(str3, str));
        return hashMap;
    }

    public boolean getPhTrue() {
        return this.context.getSharedPreferences("UserName", 0).getBoolean("phone", false);
    }

//    public Map<String, String> getPreferencesTargets() {
//        HashMap hashMap = new HashMap();
//        SharedPreferences sharedPreferences = this.context.getSharedPreferences("personpreferencesTargets", 0);
//        String str = "paceCount";
//        String str2 = "0";
//        hashMap.put(str, sharedPreferences.getString(str, str2));
//        String str3 = "distance";
//        hashMap.put(str3, sharedPreferences.getString(str3, str2));
//        String str4 = "calories";
//        hashMap.put(str4, sharedPreferences.getString(str4, str2));
//        String str5 = Columns.MINUTES;
//        hashMap.put(str5, sharedPreferences.getString(str5, str2));
//        return hashMap;
//    }

    public boolean getTrue() {
        return this.context.getSharedPreferences("UserName", 0).getBoolean("adduser", false);
    }

    public String getUnitType() {
        return this.context.getSharedPreferences("UserName", 0).getString("UnitType", "mmhg");
    }

    public void savaADDName(String str) {
        Editor edit = this.context.getSharedPreferences("ADDUSERNAME", 0).edit();
        edit.putString("UPDATEINFO", str);
        edit.commit();
    }

    public void saveGroupSendTrue(boolean z) {
        Editor edit = this.context.getSharedPreferences("UserName", 0).edit();
        edit.putBoolean("GroupSend", z);
        edit.commit();
    }

    public void saveId(int i) {
        Editor edit = this.context.getSharedPreferences("UserifnoIdall", 0).edit();
        edit.putInt("UserifnoId", i);
        edit.commit();
    }

    public void saveLastDevAddr(String str) {
        Editor edit = this.context.getSharedPreferences("UserName", 0).edit();
        edit.putString("lastDev", str);
        edit.commit();
    }

    public void saveName(String str) {
        Editor edit = this.context.getSharedPreferences("UserName", 0).edit();
        edit.putString("UserifnoName", str);
        edit.commit();
    }

    public void savePhTrue(boolean z) {
        Editor edit = this.context.getSharedPreferences("UserName", 0).edit();
        edit.putBoolean("phone", z);
        edit.commit();
    }

    public void savePreferences(String str, String str2, String str3) {
        Editor edit = this.context.getSharedPreferences("personpreferences", 0).edit();
        edit.putString("height", str);
        edit.putString("stride", str2);
        edit.putString("weight", str3);
        edit.commit();
    }

    public void savePreferencesAlarm(String str, String str2) {
        Editor edit = this.context.getSharedPreferences("personpreferencesAlarm", 0).edit();
        edit.putString("nSelectPer", str);
        edit.putString("dAlarmCycle", str2);
        edit.commit();
    }

//    public void saveTargets(String str, String str2, String str3, String str4) {
//        Editor edit = this.context.getSharedPreferences("personpreferencesTargets", 0).edit();
//        edit.putString("paceCount", str);
//        edit.putString("distance", str2);
//        edit.putString("calories", str3);
//        edit.putString(Columns.MINUTES, str4);
//        edit.commit();
//    }

    public void saveTrue(boolean z) {
        Editor edit = this.context.getSharedPreferences("UserName", 0).edit();
        edit.putBoolean("adduser", z);
        edit.commit();
    }

    public void saveUnitType(String str) {
        Editor edit = this.context.getSharedPreferences("UserName", 0).edit();
        edit.putString("UnitType", str);
        edit.commit();
    }
}
