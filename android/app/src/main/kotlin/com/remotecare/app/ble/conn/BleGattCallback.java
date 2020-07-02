package com.remotecare.app.bp.ble.conn;

import android.bluetooth.BluetoothGatt;
import android.bluetooth.BluetoothGattCallback;

import com.remotecare.app.bp.ble.data.ScanResult;
import com.remotecare.app.bp.ble.exception.BleException;

/* renamed from: com.drtrust.bp.ble.conn.BleGattCallback */
public abstract class BleGattCallback extends BluetoothGattCallback {
    public abstract void onConnectError(BleException bleException);

    public abstract void onConnectSuccess(BluetoothGatt bluetoothGatt, int i);

    public void onConnecting(BluetoothGatt bluetoothGatt, int i) {
    }

    public abstract void onDisConnected(BluetoothGatt bluetoothGatt, int i, BleException bleException);

    public void onFoundDevice(ScanResult scanResult) {
    }
}
