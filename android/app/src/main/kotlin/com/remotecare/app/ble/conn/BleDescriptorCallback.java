package com.remotecare.app.bp.ble.conn;

import android.bluetooth.BluetoothGattDescriptor;

/* renamed from: com.drtrust.bp.ble.conn.BleDescriptorCallback */
public abstract class BleDescriptorCallback extends BleCallback {
    public abstract void onSuccess(BluetoothGattDescriptor bluetoothGattDescriptor);
}
