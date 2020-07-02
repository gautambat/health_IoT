package com.remotecare.app.bp.ble.bluetooth;

import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothAdapter.LeScanCallback;
import android.bluetooth.BluetoothGatt;
import android.bluetooth.BluetoothGattCallback;
import android.bluetooth.BluetoothGattCharacteristic;
import android.bluetooth.BluetoothGattDescriptor;
import android.bluetooth.BluetoothManager;
import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import android.text.TextUtils;

import com.remotecare.app.bp.ble.conn.BleConnector;
import com.remotecare.app.bp.ble.conn.BleGattCallback;
import com.remotecare.app.bp.ble.data.ScanResult;
import com.remotecare.app.bp.ble.exception.BleException;
import com.remotecare.app.bp.ble.exception.ConnectException;
import com.remotecare.app.bp.ble.exception.NotFoundDeviceException;
import com.remotecare.app.bp.ble.exception.ScanFailedException;
import com.remotecare.app.bp.ble.scan.MacScanCallback;
import com.remotecare.app.bp.ble.scan.NameScanCallback;
import com.remotecare.app.bp.ble.scan.PeriodScanCallback;
import com.remotecare.app.bp.ble.utils.BleLog;

import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.Map.Entry;

/* renamed from: com.drtrust.bp.ble.bluetooth.BleBluetooth */
public class BleBluetooth {
    private static final String CONNECT_CALLBACK_KEY = "connect_key";
    public static final String READ_RSSI_KEY = "rssi_key";
    private static final int STATE_CONNECTED = 3;
    private static final int STATE_CONNECTING = 2;
    private static final int STATE_DISCONNECTED = 0;
    private static final int STATE_SCANNING = 1;
    private static final int STATE_SERVICES_DISCOVERED = 4;
    private BluetoothAdapter bluetoothAdapter;
    /* access modifiers changed from: private */
    public BluetoothGatt bluetoothGatt;
    /* access modifiers changed from: private */
    public HashMap<String, BluetoothGattCallback> callbackHashMap = new HashMap<>();
    /* access modifiers changed from: private */
    public int connectionState = 0;
    private Context context;
    private BleGattCallback coreGattCallback = new BleGattCallback() {
        public void onFoundDevice(ScanResult scanResult) {
            BleLog.m21i("BleGattCallback：onFoundDevice ");
        }

        public void onConnecting(BluetoothGatt bluetoothGatt, int i) {
            BleLog.m21i("BleGattCallback：onConnectSuccess ");
            BleBluetooth.this.bluetoothGatt = bluetoothGatt;
            for (Entry value : BleBluetooth.this.callbackHashMap.entrySet()) {
                Object value2 = value.getValue();
                if (value2 instanceof BleGattCallback) {
                    ((BleGattCallback) value2).onConnecting(bluetoothGatt, i);
                }
            }
        }

        public void onConnectSuccess(BluetoothGatt bluetoothGatt, int i) {
            BleLog.m21i("BleGattCallback：onConnectSuccess ");
            BleBluetooth.this.bluetoothGatt = bluetoothGatt;
            for (Entry value : BleBluetooth.this.callbackHashMap.entrySet()) {
                Object value2 = value.getValue();
                if (value2 instanceof BleGattCallback) {
                    ((BleGattCallback) value2).onConnectSuccess(bluetoothGatt, i);
                    bluetoothGatt.discoverServices();
                }
            }
        }

        public void onDisConnected(BluetoothGatt bluetoothGatt, int i, BleException bleException) {
            BleLog.m21i("BleGattCallback：onConnectFailure ");
            BleBluetooth.this.closeBluetoothGatt();
            BleBluetooth.this.bluetoothGatt = null;
            for (Entry value : BleBluetooth.this.callbackHashMap.entrySet()) {
                Object value2 = value.getValue();
                if (value2 instanceof BleGattCallback) {
                    ((BleGattCallback) value2).onDisConnected(bluetoothGatt, i, bleException);
                }
            }
        }

        public void onConnectError(BleException bleException) {
            BleLog.m21i("BleGattCallback：onConnectError ");
        }

        public void onConnectionStateChange(BluetoothGatt bluetoothGatt, int i, int i2) {
            StringBuilder sb = new StringBuilder();
            sb.append("BleGattCallback：onConnectionStateChange \nstatus: ");
            sb.append(i);
            sb.append(10);
            sb.append("newState: ");
            sb.append(i2);
            sb.append(10);
            sb.append("currentThread: ");
            sb.append(Thread.currentThread().getId());
            BleLog.m21i(sb.toString());
            if (i2 == 2) {
                BleBluetooth.this.connectionState = 3;
                onConnectSuccess(bluetoothGatt, i);
            } else if (i2 == 0) {
                BleBluetooth.this.connectionState = 0;
                onDisConnected(bluetoothGatt, i, new ConnectException(bluetoothGatt, i));
            } else if (i2 == 1) {
                BleBluetooth.this.connectionState = 2;
                onConnecting(bluetoothGatt, i);
            }
            for (Entry value : BleBluetooth.this.callbackHashMap.entrySet()) {
                Object value2 = value.getValue();
                if (value2 instanceof BluetoothGattCallback) {
                    ((BluetoothGattCallback) value2).onConnectionStateChange(bluetoothGatt, i, i2);
                }
            }
        }

        public void onServicesDiscovered(BluetoothGatt bluetoothGatt, int i) {
            BleLog.m21i("BleGattCallback：onServicesDiscovered ");
            BleBluetooth.this.connectionState = 4;
            for (Entry value : BleBluetooth.this.callbackHashMap.entrySet()) {
                Object value2 = value.getValue();
                if (value2 instanceof BluetoothGattCallback) {
                    ((BluetoothGattCallback) value2).onServicesDiscovered(bluetoothGatt, i);
                }
            }
        }

        public void onCharacteristicRead(BluetoothGatt bluetoothGatt, BluetoothGattCharacteristic bluetoothGattCharacteristic, int i) {
            BleLog.m21i("BleGattCallback：onCharacteristicRead ");
            for (Entry value : BleBluetooth.this.callbackHashMap.entrySet()) {
                Object value2 = value.getValue();
                if (value2 instanceof BluetoothGattCallback) {
                    ((BluetoothGattCallback) value2).onCharacteristicRead(bluetoothGatt, bluetoothGattCharacteristic, i);
                }
            }
        }

        public void onCharacteristicWrite(BluetoothGatt bluetoothGatt, BluetoothGattCharacteristic bluetoothGattCharacteristic, int i) {
            BleLog.m21i("BleGattCallback：onCharacteristicWrite ");
            for (Entry value : BleBluetooth.this.callbackHashMap.entrySet()) {
                Object value2 = value.getValue();
                if (value2 instanceof BluetoothGattCallback) {
                    ((BluetoothGattCallback) value2).onCharacteristicWrite(bluetoothGatt, bluetoothGattCharacteristic, i);
                }
            }
        }

        public void onCharacteristicChanged(BluetoothGatt bluetoothGatt, BluetoothGattCharacteristic bluetoothGattCharacteristic) {
            BleLog.m21i("BleGattCallback：onCharacteristicChanged ");
            for (Entry value : BleBluetooth.this.callbackHashMap.entrySet()) {
                Object value2 = value.getValue();
                if (value2 instanceof BluetoothGattCallback) {
                    ((BluetoothGattCallback) value2).onCharacteristicChanged(bluetoothGatt, bluetoothGattCharacteristic);
                }
            }
        }

        public void onDescriptorRead(BluetoothGatt bluetoothGatt, BluetoothGattDescriptor bluetoothGattDescriptor, int i) {
            BleLog.m21i("BleGattCallback：onDescriptorRead ");
            for (Entry value : BleBluetooth.this.callbackHashMap.entrySet()) {
                Object value2 = value.getValue();
                if (value2 instanceof BluetoothGattCallback) {
                    ((BluetoothGattCallback) value2).onDescriptorRead(bluetoothGatt, bluetoothGattDescriptor, i);
                }
            }
        }

        public void onDescriptorWrite(BluetoothGatt bluetoothGatt, BluetoothGattDescriptor bluetoothGattDescriptor, int i) {
            BleLog.m21i("BleGattCallback：onDescriptorWrite ");
            for (Entry value : BleBluetooth.this.callbackHashMap.entrySet()) {
                Object value2 = value.getValue();
                if (value2 instanceof BluetoothGattCallback) {
                    ((BluetoothGattCallback) value2).onDescriptorWrite(bluetoothGatt, bluetoothGattDescriptor, i);
                }
            }
        }

        public void onReliableWriteCompleted(BluetoothGatt bluetoothGatt, int i) {
            BleLog.m21i("BleGattCallback：onReliableWriteCompleted ");
            for (Entry value : BleBluetooth.this.callbackHashMap.entrySet()) {
                Object value2 = value.getValue();
                if (value2 instanceof BluetoothGattCallback) {
                    ((BluetoothGattCallback) value2).onReliableWriteCompleted(bluetoothGatt, i);
                }
            }
        }

        public void onReadRemoteRssi(BluetoothGatt bluetoothGatt, int i, int i2) {
            BleLog.m21i("BleGattCallback：onReadRemoteRssi ");
            for (Entry value : BleBluetooth.this.callbackHashMap.entrySet()) {
                Object value2 = value.getValue();
                if (value2 instanceof BluetoothGattCallback) {
                    ((BluetoothGattCallback) value2).onReadRemoteRssi(bluetoothGatt, i, i2);
                }
            }
        }
    };
    private Handler handler = new Handler(Looper.getMainLooper());
    private PeriodScanCallback periodScanCallback;

    public BleBluetooth(Context context2) {
        Context applicationContext = context2.getApplicationContext();
        this.context = applicationContext;
        this.bluetoothAdapter = ((BluetoothManager) applicationContext.getSystemService(Context.BLUETOOTH_SERVICE)).getAdapter();
    }

    public BleConnector newBleConnector() {
        return new BleConnector(this);
    }

    public boolean isInScanning() {
        return this.connectionState == 1;
    }

    public boolean isConnectingOrConnected() {
        return this.connectionState >= 2;
    }

    public boolean isConnected() {
        return this.connectionState >= 3;
    }

    public boolean isServiceDiscovered() {
        return this.connectionState == 4;
    }

    private void addConnectGattCallback(BleGattCallback bleGattCallback) {
        this.callbackHashMap.put(CONNECT_CALLBACK_KEY, bleGattCallback);
    }

    public void addGattCallback(String str, BluetoothGattCallback bluetoothGattCallback) {
        this.callbackHashMap.put(str, bluetoothGattCallback);
    }

    public void removeConnectGattCallback() {
        this.callbackHashMap.remove(CONNECT_CALLBACK_KEY);
    }

    public void removeGattCallback(String str) {
        this.callbackHashMap.remove(str);
    }

    public void clearCallback() {
        this.callbackHashMap.clear();
    }

    public BluetoothGattCallback getGattCallback(String str) {
        if (TextUtils.isEmpty(str)) {
            return null;
        }
        return (BluetoothGattCallback) this.callbackHashMap.get(str);
    }

    public boolean startLeScan(PeriodScanCallback periodScanCallback2) {
        this.periodScanCallback = periodScanCallback2;
        periodScanCallback2.setBleBluetooth(BleBluetooth.this).notifyScanStarted();
        boolean startLeScan = this.bluetoothAdapter.startLeScan(periodScanCallback2);
        if (startLeScan) {
            this.connectionState = 1;
        } else {
            periodScanCallback2.removeHandlerMsg();
        }
        return startLeScan;
    }

    public void cancelScan() {
        PeriodScanCallback periodScanCallback2 = this.periodScanCallback;
        if (periodScanCallback2 != null && this.connectionState == 1) {
            periodScanCallback2.notifyScanCancel();
        }
    }

    public void stopScan(LeScanCallback leScanCallback) {
        if (leScanCallback instanceof PeriodScanCallback) {
            ((PeriodScanCallback) leScanCallback).removeHandlerMsg();
        }
        this.bluetoothAdapter.stopLeScan(leScanCallback);
        if (this.connectionState == 1) {
            this.connectionState = 0;
        }
    }

    public synchronized BluetoothGatt connect(ScanResult scanResult, boolean z, BleGattCallback bleGattCallback) {
        StringBuilder sb = new StringBuilder();
        sb.append("connect name: ");
        sb.append(scanResult.getDevice().getName());
        sb.append("\nmac: ");
        sb.append(scanResult.getDevice().getAddress());
        sb.append("\nautoConnect: ");
        sb.append(z);
        BleLog.m21i(sb.toString());
        addConnectGattCallback(bleGattCallback);
        return scanResult.getDevice().connectGatt(this.context, z, this.coreGattCallback);
    }

    public void scanNameAndConnect(String str, long j, boolean z, BleGattCallback bleGattCallback) {
        scanNameAndConnect(str, j, z, false, bleGattCallback);
    }

    public void scanNameAndConnect(String str, long j, boolean z, boolean z2, BleGattCallback bleGattCallback) {
        if (TextUtils.isEmpty(str)) {
            if (bleGattCallback != null) {
                bleGattCallback.onConnectError(new NotFoundDeviceException());
            }
            return;
        }
        final BleGattCallback bleGattCallback2 = bleGattCallback;
        final boolean z3 = z;
        NameScanCallback r0 = new NameScanCallback(str, j, z2) {
            public void onDeviceFound(final ScanResult scanResult) {
                BleBluetooth.this.runOnMainThread(new Runnable() {
                    public void run() {
                        if (bleGattCallback2 != null) {
                            bleGattCallback2.onFoundDevice(scanResult);
                        }
                        BleBluetooth.this.connect(scanResult, z3, bleGattCallback2);
                    }
                });
            }

            public void onDeviceNotFound() {
                BleBluetooth.this.runOnMainThread(new Runnable() {
                    public void run() {
                        if (bleGattCallback2 != null) {
                            bleGattCallback2.onConnectError(new NotFoundDeviceException());
                        }
                    }
                });
            }
        };
        if (!startLeScan(r0) && bleGattCallback != null) {
            bleGattCallback.onConnectError(new ScanFailedException());
        }
    }

    public void scanNameAndConnect(String[] strArr, long j, boolean z, BleGattCallback bleGattCallback) {
        scanNameAndConnect(strArr, j, z, false, bleGattCallback);
    }

    public void scanNameAndConnect(String[] strArr, long j, boolean z, boolean z2, BleGattCallback bleGattCallback) {
        String[] strArr2 = strArr;
        BleGattCallback bleGattCallback2 = bleGattCallback;
        if (strArr2 == null || strArr2.length < 1) {
            if (bleGattCallback2 != null) {
                bleGattCallback2.onConnectError(new NotFoundDeviceException());
            }
            return;
        }
        final BleGattCallback bleGattCallback3 = bleGattCallback;
        final boolean z3 = z;
        NameScanCallback r0 = new NameScanCallback(strArr, j, z2) {
            public void onDeviceFound(final ScanResult scanResult) {
                BleBluetooth.this.runOnMainThread(new Runnable() {
                    public void run() {
                        if (bleGattCallback3 != null) {
                            bleGattCallback3.onFoundDevice(scanResult);
                        }
                        BleBluetooth.this.connect(scanResult, z3, bleGattCallback3);
                    }
                });
            }

            public void onDeviceNotFound() {
                BleBluetooth.this.runOnMainThread(new Runnable() {
                    public void run() {
                        if (bleGattCallback3 != null) {
                            bleGattCallback3.onConnectError(new NotFoundDeviceException());
                        }
                    }
                });
            }
        };
        if (!startLeScan(r0) && bleGattCallback2 != null) {
            bleGattCallback2.onConnectError(new ScanFailedException());
        }
    }

    public void scanMacAndConnect(String str, long j, boolean z, BleGattCallback bleGattCallback) {
        if (TextUtils.isEmpty(str)) {
            if (bleGattCallback != null) {
                bleGattCallback.onConnectError(new NotFoundDeviceException());
            }
            return;
        }
        final BleGattCallback bleGattCallback2 = bleGattCallback;
        final boolean z2 = z;
        MacScanCallback r0 = new MacScanCallback(str, j) {
            public void onDeviceFound(final ScanResult scanResult) {
                BleBluetooth.this.runOnMainThread(new Runnable() {
                    public void run() {
                        if (bleGattCallback2 != null) {
                            bleGattCallback2.onFoundDevice(scanResult);
                        }
                        BleBluetooth.this.connect(scanResult, z2, bleGattCallback2);
                    }
                });
            }

            public void onDeviceNotFound() {
                BleBluetooth.this.runOnMainThread(new Runnable() {
                    public void run() {
                        if (bleGattCallback2 != null) {
                            bleGattCallback2.onConnectError(new NotFoundDeviceException());
                        }
                    }
                });
            }
        };
        if (!startLeScan(r0) && bleGattCallback != null) {
            bleGattCallback.onConnectError(new ScanFailedException());
        }
    }

    public boolean refreshDeviceCache() {
        try {
            Method method = BluetoothGatt.class.getMethod("refresh", new Class[0]);
            if (method != null) {
                boolean booleanValue = ((Boolean) method.invoke(getBluetoothGatt(), new Object[0])).booleanValue();
                StringBuilder sb = new StringBuilder();
                sb.append("refreshDeviceCache, is success:  ");
                sb.append(booleanValue);
                BleLog.m21i(sb.toString());
                return booleanValue;
            }
        } catch (Exception e) {
            StringBuilder sb2 = new StringBuilder();
            sb2.append("exception occur while refreshing device: ");
            sb2.append(e.getMessage());
            BleLog.m21i(sb2.toString());
            e.printStackTrace();
        }
        return false;
    }

    public void closeBluetoothGatt() {
        BluetoothGatt bluetoothGatt2 = this.bluetoothGatt;
        if (bluetoothGatt2 != null) {
            bluetoothGatt2.disconnect();
        }
        if (this.bluetoothGatt != null) {
            refreshDeviceCache();
        }
        BluetoothGatt bluetoothGatt3 = this.bluetoothGatt;
        if (bluetoothGatt3 != null) {
            bluetoothGatt3.close();
        }
    }

    public void enableBluetoothIfDisabled() {
        if (!isBlueEnable()) {
            enableBluetooth();
        }
    }

    public boolean isBlueEnable() {
        return this.bluetoothAdapter.isEnabled();
    }

    public void enableBluetooth() {
        this.bluetoothAdapter.enable();
    }

    public void disableBluetooth() {
        this.bluetoothAdapter.disable();
    }

    /* access modifiers changed from: private */
    public void runOnMainThread(Runnable runnable) {
        if (Looper.myLooper() == Looper.getMainLooper()) {
            runnable.run();
        } else {
            this.handler.post(runnable);
        }
    }

    public Context getContext() {
        return this.context;
    }

    public BluetoothAdapter getBluetoothAdapter() {
        return this.bluetoothAdapter;
    }

    public BluetoothGatt getBluetoothGatt() {
        return this.bluetoothGatt;
    }

    public int getConnectionState() {
        return this.connectionState;
    }
}
