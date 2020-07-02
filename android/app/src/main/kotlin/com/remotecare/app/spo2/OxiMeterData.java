package com.remotecare.app.spo2;

import java.io.Serializable;

public class OxiMeterData implements Serializable {

    private int spo2;
    private int pulse;
    private String deviceId ;
    private boolean isManual;

    public int getSpo2() {
        return spo2;
    }

    public void setSpo2(int spo2) {
        this.spo2 = spo2;
    }

    public int getPulse() {
        return pulse;
    }

    public void setPulse(int pulse) {
        this.pulse = pulse;
    }

    public String getDeviceId() {
        return deviceId;
    }

    public void setDeviceId(String deviceId) {
        this.deviceId = deviceId;
    }

    public boolean isManual() {
        return isManual;
    }

    public void setManual(boolean manual) {
        isManual = manual;
    }

    public OxiMeterData() {
    }

    public OxiMeterData(int spo2, int pulse, String deviceId, boolean isManual) {
        this.spo2 = spo2;
        this.pulse = pulse;
        this.deviceId = deviceId;
        this.isManual = isManual;
    }
}
