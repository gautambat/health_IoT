package com.remotecare.app.bp.ble.conn;

import android.bluetooth.BluetoothGattCallback;

import com.remotecare.app.bp.ble.exception.BleException;

/* renamed from: com.drtrust.bp.ble.conn.BleCallback */
public abstract class BleCallback {
    private BluetoothGattCallback bluetoothGattCallback;

    public abstract void onFailure(BleException bleException);

    public abstract void onInitiatedResult(boolean z);

    public BleCallback setBluetoothGattCallback(BluetoothGattCallback bluetoothGattCallback2) {
        this.bluetoothGattCallback = bluetoothGattCallback2;
        return this;
    }

    public BluetoothGattCallback getBluetoothGattCallback() {
        return this.bluetoothGattCallback;
    }
}
