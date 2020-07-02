package com.remotecare.app.bp.ble.scan;

import android.bluetooth.BluetoothDevice;

import com.remotecare.app.bp.ble.data.ScanResult;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.atomic.AtomicBoolean;

/* renamed from: com.drtrust.bp.ble.scan.ListScanCallback */
public abstract class ListScanCallback extends PeriodScanCallback {
    private AtomicBoolean hasFound = new AtomicBoolean(false);
    private List<ScanResult> resultList = new ArrayList();

    public abstract void onScanComplete(ScanResult[] scanResultArr);

    public abstract void onScanning(ScanResult scanResult);

    public ListScanCallback(long j) {
        super(j);
    }

    public void onLeScan(BluetoothDevice bluetoothDevice, int i, byte[] bArr) {
        if (bluetoothDevice != null) {
            ScanResult scanResult = new ScanResult(bluetoothDevice, i, bArr, System.currentTimeMillis());
            synchronized (this) {
                this.hasFound.set(false);
                for (ScanResult device : this.resultList) {
                    if (device.getDevice().equals(bluetoothDevice)) {
                        this.hasFound.set(true);
                    }
                }
                if (!this.hasFound.get()) {
                    this.resultList.add(scanResult);
                    onScanning(scanResult);
                }
            }
        }
    }

    public void onScanTimeout() {
        ScanResult[] scanResultArr = new ScanResult[this.resultList.size()];
        for (int i = 0; i < scanResultArr.length; i++) {
            scanResultArr[i] = (ScanResult) this.resultList.get(i);
        }
        onScanComplete(scanResultArr);
    }

    public void onScanCancel() {
        List<ScanResult> list = this.resultList;
        onScanComplete((ScanResult[]) list.toArray(new ScanResult[list.size()]));
    }
}
