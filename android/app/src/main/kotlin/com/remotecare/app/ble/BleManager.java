package com.remotecare.app.bp.ble;

import android.content.Context;

import com.remotecare.app.bp.ble.bluetooth.BleBluetooth;
import com.remotecare.app.bp.ble.conn.BleCharacterCallback;
import com.remotecare.app.bp.ble.conn.BleGattCallback;
import com.remotecare.app.bp.ble.conn.BleRssiCallback;
import com.remotecare.app.bp.ble.data.ScanResult;
import com.remotecare.app.bp.ble.exception.BleException;
import com.remotecare.app.bp.ble.exception.BlueToothNotEnableException;
import com.remotecare.app.bp.ble.exception.NotFoundDeviceException;
import com.remotecare.app.bp.ble.exception.hanlder.DefaultBleExceptionHandler;
import com.remotecare.app.bp.ble.scan.ListScanCallback;

/* renamed from: com.drtrust.bp.ble.BleManager */
public class BleManager {
    private BleBluetooth bleBluetooth;
    private DefaultBleExceptionHandler bleExceptionHandler;
    private Context mContext;

    public BleManager(Context context) {
        this.mContext = context;
        if (isSupportBle() && this.bleBluetooth == null) {
            this.bleBluetooth = new BleBluetooth(context);
        }
        this.bleExceptionHandler = new DefaultBleExceptionHandler();
    }

    public void handleException(BleException bleException) {
        this.bleExceptionHandler.handleException(bleException);
    }

    public boolean scanDevice(ListScanCallback listScanCallback) {
        if (isBlueEnable()) {
            return this.bleBluetooth.startLeScan(listScanCallback);
        }
        handleException(new BlueToothNotEnableException());
        return false;
    }

    public void connectDevice(ScanResult scanResult, boolean z, BleGattCallback bleGattCallback) {
        if (scanResult != null && scanResult.getDevice() != null) {
            if (bleGattCallback != null) {
                bleGattCallback.onFoundDevice(scanResult);
            }
            this.bleBluetooth.connect(scanResult, z, bleGattCallback);
        } else if (bleGattCallback != null) {
            bleGattCallback.onConnectError(new NotFoundDeviceException());
        }
    }

    public void scanNameAndConnect(String str, long j, boolean z, BleGattCallback bleGattCallback) {
        if (isBlueEnable() || bleGattCallback == null) {
            this.bleBluetooth.scanNameAndConnect(str, j, z, bleGattCallback);
        } else {
            bleGattCallback.onConnectError(new BlueToothNotEnableException());
        }
    }

    public void scanNamesAndConnect(String[] strArr, long j, boolean z, BleGattCallback bleGattCallback) {
        if (isBlueEnable() || bleGattCallback == null) {
            this.bleBluetooth.scanNameAndConnect(strArr, j, z, bleGattCallback);
        } else {
            bleGattCallback.onConnectError(new BlueToothNotEnableException());
        }
    }

    public void scanfuzzyNameAndConnect(String str, long j, boolean z, BleGattCallback bleGattCallback) {
        if (isBlueEnable() || bleGattCallback == null) {
            this.bleBluetooth.scanNameAndConnect(str, j, z, true, bleGattCallback);
        } else {
            bleGattCallback.onConnectError(new BlueToothNotEnableException());
        }
    }

    public void scanfuzzyNamesAndConnect(String[] strArr, long j, boolean z, BleGattCallback bleGattCallback) {
        if (isBlueEnable() || bleGattCallback == null) {
            this.bleBluetooth.scanNameAndConnect(strArr, j, z, true, bleGattCallback);
        } else {
            bleGattCallback.onConnectError(new BlueToothNotEnableException());
        }
    }

    public void scanMacAndConnect(String str, long j, boolean z, BleGattCallback bleGattCallback) {
        if (isBlueEnable() || bleGattCallback == null) {
            this.bleBluetooth.scanMacAndConnect(str, j, z, bleGattCallback);
        } else {
            bleGattCallback.onConnectError(new BlueToothNotEnableException());
        }
    }

    public void cancelScan() {
        this.bleBluetooth.cancelScan();
    }

    public boolean notify(String str, String str2, BleCharacterCallback bleCharacterCallback) {
        return this.bleBluetooth.newBleConnector().withUUIDString(str, str2, null).enableCharacteristicNotify(bleCharacterCallback, str2);
    }

    public boolean indicate(String str, String str2, BleCharacterCallback bleCharacterCallback) {
        return this.bleBluetooth.newBleConnector().withUUIDString(str, str2, null).enableCharacteristicIndicate(bleCharacterCallback, str2);
    }

    public boolean stopNotify(String str, String str2) {
        boolean disableCharacteristicNotify = this.bleBluetooth.newBleConnector().withUUIDString(str, str2, null).disableCharacteristicNotify();
        if (disableCharacteristicNotify) {
            this.bleBluetooth.removeGattCallback(str2);
        }
        return disableCharacteristicNotify;
    }

    public boolean stopIndicate(String str, String str2) {
        boolean disableCharacteristicIndicate = this.bleBluetooth.newBleConnector().withUUIDString(str, str2, null).disableCharacteristicIndicate();
        if (disableCharacteristicIndicate) {
            this.bleBluetooth.removeGattCallback(str2);
        }
        return disableCharacteristicIndicate;
    }

    public boolean writeDevice(String str, String str2, byte[] bArr, BleCharacterCallback bleCharacterCallback) {
        return this.bleBluetooth.newBleConnector().withUUIDString(str, str2, null).writeCharacteristic(bArr, bleCharacterCallback, str2);
    }

    public boolean readDevice(String str, String str2, BleCharacterCallback bleCharacterCallback) {
        return this.bleBluetooth.newBleConnector().withUUIDString(str, str2, null).readCharacteristic(bleCharacterCallback, str2);
    }

    public boolean readRssi(BleRssiCallback bleRssiCallback) {
        return this.bleBluetooth.newBleConnector().readRemoteRssi(bleRssiCallback);
    }

    public void refreshDeviceCache() {
        this.bleBluetooth.refreshDeviceCache();
    }

    public void closeBluetoothGatt() {
        BleBluetooth bleBluetooth2 = this.bleBluetooth;
        if (bleBluetooth2 != null) {
            try {
                bleBluetooth2.closeBluetoothGatt();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    public boolean isSupportBle() {
        return this.mContext.getApplicationContext().getPackageManager().hasSystemFeature("android.hardware.bluetooth_le");
    }

    public void enableBluetooth() {
        BleBluetooth bleBluetooth2 = this.bleBluetooth;
        if (bleBluetooth2 != null) {
            bleBluetooth2.enableBluetoothIfDisabled();
        }
    }

    public void disableBluetooth() {
        BleBluetooth bleBluetooth2 = this.bleBluetooth;
        if (bleBluetooth2 != null) {
            bleBluetooth2.disableBluetooth();
        }
    }

    public boolean isBlueEnable() {
        BleBluetooth bleBluetooth2 = this.bleBluetooth;
        return bleBluetooth2 != null && bleBluetooth2.isBlueEnable();
    }

    public boolean isInScanning() {
        return this.bleBluetooth.isInScanning();
    }

    public boolean isConnectingOrConnected() {
        return this.bleBluetooth.isConnectingOrConnected();
    }

    public boolean isConnected() {
        return this.bleBluetooth.isConnected();
    }

    public boolean isServiceDiscovered() {
        return this.bleBluetooth.isServiceDiscovered();
    }

    public void stopListenCharacterCallback(String str) {
        this.bleBluetooth.removeGattCallback(str);
    }

    public void stopListenConnectCallback() {
        this.bleBluetooth.removeConnectGattCallback();
    }
}
