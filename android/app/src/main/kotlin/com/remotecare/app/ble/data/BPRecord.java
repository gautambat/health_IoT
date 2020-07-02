package com.remotecare.app.bp.ble.data;

import java.io.Serializable;

public class BPRecord implements Serializable {
   private int dia;
   private int sys;
   private String deviceId;
   private boolean isManual;

    public boolean isManual() {
        return isManual;
    }

    public void setManual(boolean manual) {
        isManual = manual;
    }



    public String getDeviceId() {
        return deviceId;
    }

    public void setDeviceId(String deviceId) {
        this.deviceId = deviceId;
    }

    public BPRecord() {
    }

    public int getDia() {
        return dia;
    }

    public void setDia(int dia) {
        this.dia = dia;
    }

    public int getSys() {
        return sys;
    }

    public void setSys(int sys) {
        this.sys = sys;
    }

    public BPRecord(int dia, int sys, String deviceId) {
        this.dia = dia;
        this.sys = sys;
        this.deviceId = deviceId;
    }
}
