package com.remotecare.app.bp.ble.conn;

import android.bluetooth.BluetoothGattCharacteristic;

/* renamed from: com.drtrust.bp.ble.conn.BleCharacterCallback */
public abstract class BleCharacterCallback extends BleCallback {
    public abstract void onSuccess(BluetoothGattCharacteristic bluetoothGattCharacteristic);
}
