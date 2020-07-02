package com.remotecare.app.bp.ble.data;

import com.remotecare.app.bp.ble.utils.DateUtil;

import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.Date;

public class RecordInfo  implements Serializable {
    private String timeStamp = DateUtil.timeStamp2Date(DateUtil.dateToStamp(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())));
    private long recordedTime = System.currentTimeMillis();
    private int Dia = 0;
    private int Ihb = 0;
    private int Pulse = 0;
    private int Sys = 0;
    private String pId;

    public RecordInfo() {
    }

    public String getTimeStamp() {
        return timeStamp;
    }

    public void setTimeStamp(String timeStamp) {
        this.timeStamp = timeStamp;
    }

    public long getRecordedTime() {
        return recordedTime;
    }

    public void setRecordedTime(long recordedTime) {
        this.recordedTime = recordedTime;
    }

    public int getDia() {
        return Dia;
    }

    public void setDia(int dia) {
        Dia = dia;
    }

    public int getIhb() {
        return Ihb;
    }

    public void setIhb(int ihb) {
        Ihb = ihb;
    }

    public int getPulse() {
        return Pulse;
    }

    public void setPulse(int pulse) {
        Pulse = pulse;
    }

    public int getSys() {
        return Sys;
    }

    public void setSys(int sys) {
        Sys = sys;
    }

    public String getpId() {
        return pId;
    }

    public void setpId(String pId) {
        this.pId = pId;
    }
}
