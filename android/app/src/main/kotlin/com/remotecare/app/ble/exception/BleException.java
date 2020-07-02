package com.remotecare.app.bp.ble.exception;

import java.io.Serializable;

/* renamed from: com.drtrust.bp.ble.exception.BleException */
public abstract class BleException implements Serializable {
    public static final int ERROR_CODE_BLUETOOTH_NOT_ENABLE = 104;
    public static final int ERROR_CODE_GATT = 101;
    public static final int ERROR_CODE_NOT_FOUND_DEVICE = 103;
    public static final int ERROR_CODE_OTHER = 102;
    public static final int ERROR_CODE_SCAN_FAILED = 105;
    public static final int ERROR_CODE_TIMEOUT = 100;
    private static final long serialVersionUID = 8004414918500865564L;
    private int code;
    private String description;

    public BleException(int i, String str) {
        this.code = i;
        this.description = str;
    }

    public int getCode() {
        return this.code;
    }

    public BleException setCode(int i) {
        this.code = i;
        return this;
    }

    public String getDescription() {
        return this.description;
    }

    public BleException setDescription(String str) {
        this.description = str;
        return this;
    }

    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("BleException { code=");
        sb.append(this.code);
        sb.append(", description='");
        sb.append(this.description);
        sb.append('\'');
        sb.append('}');
        return sb.toString();
    }
}
