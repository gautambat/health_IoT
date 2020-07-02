package com.remotecare.app.bp.ble.exception;

import android.bluetooth.BluetoothGatt;

/* renamed from: com.drtrust.bp.ble.exception.ConnectException */
public class ConnectException extends BleException {
    private BluetoothGatt bluetoothGatt;
    private int gattStatus;

    public ConnectException(BluetoothGatt bluetoothGatt2, int i) {
        super(101, "Gatt Exception Occurred! ");
        this.bluetoothGatt = bluetoothGatt2;
        this.gattStatus = i;
    }

    public int getGattStatus() {
        return this.gattStatus;
    }

    public ConnectException setGattStatus(int i) {
        this.gattStatus = i;
        return this;
    }

    public BluetoothGatt getBluetoothGatt() {
        return this.bluetoothGatt;
    }

    public ConnectException setBluetoothGatt(BluetoothGatt bluetoothGatt2) {
        this.bluetoothGatt = bluetoothGatt2;
        return this;
    }

    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("ConnectException{gattStatus=");
        sb.append(this.gattStatus);
        sb.append(", bluetoothGatt=");
        sb.append(this.bluetoothGatt);
        sb.append("} ");
        sb.append(super.toString());
        return sb.toString();
    }
}
