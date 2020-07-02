package com.remotecare.app.bp.ble.exception.hanlder;

import com.remotecare.app.bp.ble.exception.BlueToothNotEnableException;
import com.remotecare.app.bp.ble.exception.ConnectException;
import com.remotecare.app.bp.ble.exception.GattException;
import com.remotecare.app.bp.ble.exception.NotFoundDeviceException;
import com.remotecare.app.bp.ble.exception.OtherException;
import com.remotecare.app.bp.ble.exception.ScanFailedException;
import com.remotecare.app.bp.ble.exception.TimeoutException;
import com.remotecare.app.bp.ble.utils.BleLog;

/* renamed from: com.drtrust.bp.ble.exception.hanlder.DefaultBleExceptionHandler */
public class DefaultBleExceptionHandler extends BleExceptionHandler {
    private static final String TAG = "BleExceptionHandler";

    /* access modifiers changed from: protected */
    public void onConnectException(ConnectException connectException) {
        BleLog.m16e(TAG, connectException.getDescription());
    }

    /* access modifiers changed from: protected */
    public void onGattException(GattException gattException) {
        BleLog.m16e(TAG, gattException.getDescription());
    }

    /* access modifiers changed from: protected */
    public void onTimeoutException(TimeoutException timeoutException) {
        BleLog.m16e(TAG, timeoutException.getDescription());
    }

    /* access modifiers changed from: protected */
    public void onNotFoundDeviceException(NotFoundDeviceException notFoundDeviceException) {
        BleLog.m16e(TAG, notFoundDeviceException.getDescription());
    }

    /* access modifiers changed from: protected */
    public void onBlueToothNotEnableException(BlueToothNotEnableException blueToothNotEnableException) {
        BleLog.m16e(TAG, blueToothNotEnableException.getDescription());
    }

    /* access modifiers changed from: protected */
    public void onScanFailedException(ScanFailedException scanFailedException) {
        BleLog.m16e(TAG, scanFailedException.getDescription());
    }

    /* access modifiers changed from: protected */
    public void onOtherException(OtherException otherException) {
        BleLog.m16e(TAG, otherException.getDescription());
    }
}
