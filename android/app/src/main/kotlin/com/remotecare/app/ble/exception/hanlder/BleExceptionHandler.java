package com.remotecare.app.bp.ble.exception.hanlder;

import com.remotecare.app.bp.ble.exception.BleException;
import com.remotecare.app.bp.ble.exception.BlueToothNotEnableException;
import com.remotecare.app.bp.ble.exception.ConnectException;
import com.remotecare.app.bp.ble.exception.GattException;
import com.remotecare.app.bp.ble.exception.NotFoundDeviceException;
import com.remotecare.app.bp.ble.exception.OtherException;
import com.remotecare.app.bp.ble.exception.ScanFailedException;
import com.remotecare.app.bp.ble.exception.TimeoutException;

/* renamed from: com.drtrust.bp.ble.exception.hanlder.BleExceptionHandler */
public abstract class BleExceptionHandler {
    /* access modifiers changed from: protected */
    public abstract void onBlueToothNotEnableException(BlueToothNotEnableException blueToothNotEnableException);

    /* access modifiers changed from: protected */
    public abstract void onConnectException(ConnectException connectException);

    /* access modifiers changed from: protected */
    public abstract void onGattException(GattException gattException);

    /* access modifiers changed from: protected */
    public abstract void onNotFoundDeviceException(NotFoundDeviceException notFoundDeviceException);

    /* access modifiers changed from: protected */
    public abstract void onOtherException(OtherException otherException);

    /* access modifiers changed from: protected */
    public abstract void onScanFailedException(ScanFailedException scanFailedException);

    /* access modifiers changed from: protected */
    public abstract void onTimeoutException(TimeoutException timeoutException);

    public BleExceptionHandler handleException(BleException bleException) {
        if (bleException != null) {
            if (bleException instanceof ConnectException) {
                onConnectException((ConnectException) bleException);
            } else if (bleException instanceof GattException) {
                onGattException((GattException) bleException);
            } else if (bleException instanceof TimeoutException) {
                onTimeoutException((TimeoutException) bleException);
            } else if (bleException instanceof NotFoundDeviceException) {
                onNotFoundDeviceException((NotFoundDeviceException) bleException);
            } else if (bleException instanceof BlueToothNotEnableException) {
                onBlueToothNotEnableException((BlueToothNotEnableException) bleException);
            } else if (bleException instanceof ScanFailedException) {
                onScanFailedException((ScanFailedException) bleException);
            } else {
                onOtherException((OtherException) bleException);
            }
        }
        return this;
    }
}
