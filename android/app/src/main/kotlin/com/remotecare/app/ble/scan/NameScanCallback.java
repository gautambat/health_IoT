package com.remotecare.app.bp.ble.scan;

import android.bluetooth.BluetoothDevice;
import android.text.TextUtils;

import com.remotecare.app.bp.ble.data.ScanResult;

import java.util.concurrent.atomic.AtomicBoolean;

/* renamed from: com.drtrust.bp.ble.scan.NameScanCallback */
public abstract class NameScanCallback extends PeriodScanCallback {
    private AtomicBoolean hasFound = new AtomicBoolean(false);
    private boolean mFuzzy = false;
    private String mName = null;
    private String[] mNames = null;

    public abstract void onDeviceFound(ScanResult scanResult);

    public abstract void onDeviceNotFound();

    public void onScanCancel() {
    }

    public NameScanCallback(String str, long j, boolean z) {
        super(j);
        this.mName = str;
        this.mFuzzy = z;
        if (TextUtils.isEmpty(str)) {
            onDeviceNotFound();
        }
    }

    public NameScanCallback(String[] strArr, long j, boolean z) {
        super(j);
        this.mNames = strArr;
        this.mFuzzy = z;
        if (strArr == null || strArr.length < 1) {
            onDeviceNotFound();
        }
    }

    public void onLeScan(BluetoothDevice bluetoothDevice, int i, byte[] bArr) {
        if (bluetoothDevice != null && !TextUtils.isEmpty(bluetoothDevice.getName()) && !this.hasFound.get()) {
            ScanResult scanResult = new ScanResult(bluetoothDevice, i, bArr, System.currentTimeMillis());
            String str = this.mName;
            if (str != null) {
                boolean z = this.mFuzzy;
                String name = bluetoothDevice.getName();
                if (!z ? str.equalsIgnoreCase(name) : name.contains(this.mName)) {
                    this.hasFound.set(true);
                    this.bleBluetooth.stopScan(this);
                    onDeviceFound(scanResult);
                }
            } else {
                String[] strArr = this.mNames;
                if (strArr != null) {
                    int length = strArr.length;
                    int i2 = 0;
                    while (i2 < length) {
                        String str2 = strArr[i2];
                        if (this.mFuzzy) {
                            if (!bluetoothDevice.getName().contains(str2)) {
                                i2++;
                            }
                        } else if (!str2.equalsIgnoreCase(bluetoothDevice.getName())) {
                            i2++;
                        }
                        this.hasFound.set(true);
                        this.bleBluetooth.stopScan(this);
                        onDeviceFound(scanResult);
                        return;
                    }
                }
            }
        }
    }

    public void onScanTimeout() {
        onDeviceNotFound();
    }
}
