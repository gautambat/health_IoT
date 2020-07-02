package com.remotecare.app.bp.ble.exception;

/* renamed from: com.drtrust.bp.ble.exception.GattException */
public class GattException extends BleException {
    private int gattStatus;

    public GattException(int i) {
        super(101, "Gatt Exception Occurred! ");
        this.gattStatus = i;
    }

    public int getGattStatus() {
        return this.gattStatus;
    }

    public GattException setGattStatus(int i) {
        this.gattStatus = i;
        return this;
    }

    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("GattException{gattStatus=");
        sb.append(this.gattStatus);
        sb.append("} ");
        sb.append(super.toString());
        return sb.toString();
    }
}
