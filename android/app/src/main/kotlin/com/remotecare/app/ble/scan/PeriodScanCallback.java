package com.remotecare.app.bp.ble.scan;

import android.bluetooth.BluetoothAdapter.LeScanCallback;
import android.os.Handler;
import android.os.Looper;

import com.remotecare.app.bp.ble.bluetooth.BleBluetooth;

import androidx.work.WorkRequest;

/* renamed from: com.drtrust.bp.ble.scan.PeriodScanCallback */
public abstract class PeriodScanCallback implements LeScanCallback {
    BleBluetooth bleBluetooth;
    private Handler handler = new Handler(Looper.getMainLooper());
    private long timeoutMillis = WorkRequest.MIN_BACKOFF_MILLIS;

    public abstract void onScanCancel();

    public abstract void onScanTimeout();

    PeriodScanCallback(long j) {
        this.timeoutMillis = j;
    }

    public void notifyScanStarted() {
        if (this.timeoutMillis > 0) {
            removeHandlerMsg();
            this.handler.postDelayed(new Runnable() {
                public void run() {
                    PeriodScanCallback.this.bleBluetooth.stopScan(PeriodScanCallback.this);
                    PeriodScanCallback.this.onScanTimeout();
                }
            }, this.timeoutMillis);
        }
    }

    public void notifyScanCancel() {
        this.bleBluetooth.stopScan(this);
        onScanCancel();
    }

    public void removeHandlerMsg() {
        this.handler.removeCallbacksAndMessages(null);
    }

    public long getTimeoutMillis() {
        return this.timeoutMillis;
    }

    public PeriodScanCallback setTimeoutMillis(long j) {
        this.timeoutMillis = j;
        return this;
    }

    public BleBluetooth getBleBluetooth() {
        return this.bleBluetooth;
    }

    public PeriodScanCallback setBleBluetooth(BleBluetooth bleBluetooth2) {
        this.bleBluetooth = bleBluetooth2;
        return this;
    }
}
