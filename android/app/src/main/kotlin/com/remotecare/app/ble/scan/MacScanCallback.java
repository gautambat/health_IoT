package com.remotecare.app.bp.ble.scan;

import android.bluetooth.BluetoothDevice;
import android.text.TextUtils;

import com.remotecare.app.bp.ble.data.ScanResult;

import java.util.concurrent.atomic.AtomicBoolean;

/* renamed from: com.drtrust.bp.ble.scan.MacScanCallback */
public abstract class MacScanCallback extends PeriodScanCallback {
    private AtomicBoolean hasFound = new AtomicBoolean(false);
    private String mMac;

    public abstract void onDeviceFound(ScanResult scanResult);

    public abstract void onDeviceNotFound();

    public void onScanCancel() {
    }

    public MacScanCallback(String str, long j) {
        super(j);
        this.mMac = str;
        if (TextUtils.isEmpty(str)) {
            onDeviceNotFound();
        }
    }

    public void onLeScan(BluetoothDevice bluetoothDevice, int i, byte[] bArr) {
        if (bluetoothDevice != null && !TextUtils.isEmpty(bluetoothDevice.getAddress()) && !this.hasFound.get()) {
            ScanResult scanResult = new ScanResult(bluetoothDevice, i, bArr, System.currentTimeMillis());
            if (this.mMac.equalsIgnoreCase(bluetoothDevice.getAddress())) {
                this.hasFound.set(true);
                this.bleBluetooth.stopScan(this);
                onDeviceFound(scanResult);
            }
        }
    }

    public void onScanTimeout() {
        onDeviceNotFound();
    }
}
