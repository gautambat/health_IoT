package com.remotecare.app.bp.ble;

import android.app.Service;
import android.bluetooth.BluetoothGatt;
import android.content.Intent;
import android.os.Binder;
import android.os.Handler;
import android.os.IBinder;
import android.os.Looper;
import android.util.Log;

import com.remotecare.app.bp.ble.conn.BleCharacterCallback;
import com.remotecare.app.bp.ble.conn.BleGattCallback;
import com.remotecare.app.bp.ble.conn.BleRssiCallback;
import com.remotecare.app.bp.ble.data.ScanResult;
import com.remotecare.app.bp.ble.exception.BleException;
import com.remotecare.app.bp.ble.scan.ListScanCallback;

import androidx.annotation.Nullable;

public class BluetoothService extends Service {
    private static final String TAG = BluetoothService.class.getSimpleName();
    public BluetoothBinder mBinder = new BluetoothBinder();
    private BleManager mBleManager;
    public Callback mCallback = null;
    public BluetoothGatt mGatt;
    private Handler mHandler = new Handler(Looper.getMainLooper());
    public class BluetoothBinder extends Binder {
        public BluetoothBinder() {
        }

        public BluetoothService getService() {
            return BluetoothService.this;
        }
    }

    public interface Callback {
        void onConnectSuccess();

        void onConnecting();

        void onDisConnected();

        void onException(BleException bleException);

        void onScanComplete();

        void onScanning(ScanResult scanResult);

        void onServicesDiscovered();

        void onStartScan();
    }

    public BluetoothGatt getGatt() {
        return this.mGatt;
    }

    public void runOnMainThread(Runnable runnable) {
        if (Looper.myLooper() == Looper.getMainLooper()) {
            runnable.run();
        } else {
            this.mHandler.post(runnable);
        }
    }

    @Override
    public void onCreate() {
        super.onCreate();
        this.mBleManager = new BleManager(this);
        this.mBleManager.enableBluetooth();
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        this.mBleManager = null;
        this.mCallback = null;
    }

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return this.mBinder;
    }

    @Override
    public boolean onUnbind(Intent intent) {
        this.mBleManager.closeBluetoothGatt();
        return super.onUnbind(intent);
    }


    public void setScanAndConnectCallback(Callback callback) {
        this.mCallback = callback;
    }

    public boolean isSupportBle() {
        return this.mBleManager.isSupportBle();
    }

    public boolean isBlueEnable() {
        return this.mBleManager.isBlueEnable();
    }

    public boolean isInScanning() {
        return this.mBleManager.isInScanning();
    }

    public boolean isConnected() {
        return this.mBleManager.isConnected();
    }

    public boolean isServiceDiscovered() {
        return this.mBleManager.isServiceDiscovered();
    }

    public void closeConnect() {
        this.mBleManager.closeBluetoothGatt();
    }

    public void enableBluetooth() {
        BleManager bleManager = this.mBleManager;
        if (bleManager != null) {
            bleManager.enableBluetooth();
        }
    }

    public void cancelScan() {
        this.mBleManager.cancelScan();
    }

    public void scanDevice(long j) {
        Callback callback = this.mCallback;
        if (callback != null) {
            callback.onStartScan();
        }
        if (!this.mBleManager.scanDevice(new ListScanCallback(j) {
            public void onScanning(final ScanResult scanResult) {
                BluetoothService.this.runOnMainThread(new Runnable() {
                    public void run() {
                        if (BluetoothService.this.mCallback != null) {
                            BluetoothService.this.mCallback.onScanning(scanResult);
                        }
                    }
                });
            }

            public void onScanComplete(ScanResult[] scanResultArr) {
                BluetoothService.this.runOnMainThread(new Runnable() {
                    public void run() {
                        if (BluetoothService.this.mCallback != null) {
                            BluetoothService.this.mCallback.onScanComplete();
                        }
                    }
                });
            }
        })) {
            Callback callback2 = this.mCallback;
            if (callback2 != null) {
                callback2.onScanComplete();
            }
        }
    }

    public void connectDevice(ScanResult scanResult) {
        Callback callback = this.mCallback;
        if (callback != null) {
            callback.onConnecting();
        }
        this.mBleManager.connectDevice(scanResult, true, new BleGattCallback() {
            public void onConnecting(BluetoothGatt bluetoothGatt, int i) {
                Log.d(TAG,"Connecting");
            }

            public void onFoundDevice(ScanResult scanResult) {
                BluetoothService.this.runOnMainThread(new Runnable() {
                    public void run() {
                        if (BluetoothService.this.mCallback != null) {
                            BluetoothService.this.mCallback.onScanComplete();
                        }
                    }
                });
                BluetoothService.this.runOnMainThread(new Runnable() {
                    public void run() {
                        if (BluetoothService.this.mCallback != null) {
                            BluetoothService.this.mCallback.onConnecting();
                        }
                    }
                });
            }

            public void onConnectError(final BleException bleException) {
                BluetoothService.this.runOnMainThread(new Runnable() {
                    public void run() {
                        if (BluetoothService.this.mCallback != null) {
                            BluetoothService.this.mCallback.onException(bleException);
                        }
                    }
                });
            }

            public void onConnectSuccess(BluetoothGatt bluetoothGatt, int i) {
                BluetoothService.this.runOnMainThread(new Runnable() {
                    public void run() {
                        if (BluetoothService.this.mCallback != null) {
                            BluetoothService.this.mCallback.onConnectSuccess();
                        }
                    }
                });
            }

            public void onDisConnected(BluetoothGatt bluetoothGatt, int i, final BleException bleException) {
                BluetoothService.this.runOnMainThread(new Runnable() {
                    public void run() {
                        if (BluetoothService.this.mCallback != null) {
                           Log.d("MainAct", bleException.getDescription());
                            BluetoothService.this.mCallback.onDisConnected();
                        }
                    }
                });
            }

            public void onServicesDiscovered(BluetoothGatt bluetoothGatt, int i) {
                BluetoothService.this.mGatt = bluetoothGatt;
                BluetoothService.this.runOnMainThread(new Runnable() {
                    public void run() {
                        if (BluetoothService.this.mCallback != null) {
                            BluetoothService.this.mCallback.onServicesDiscovered();
                        }
                    }
                });
            }
        });
    }

    public void scanAndConnectForName(String str, long j) {
        Callback callback = this.mCallback;
        if (callback != null) {
            callback.onStartScan();
        }
        this.mBleManager.scanNameAndConnect(str, j, false, new BleGattCallback() {
            public void onConnecting(BluetoothGatt bluetoothGatt, int i) {
            }

            public void onFoundDevice(final ScanResult scanResult) {
                BluetoothService.this.runOnMainThread(new Runnable() {
                    public void run() {
                        if (BluetoothService.this.mCallback != null) {
                            BluetoothService.this.mCallback.onScanning(scanResult);
                        }
                    }
                });
                BluetoothService.this.runOnMainThread(new Runnable() {
                    public void run() {
                        if (BluetoothService.this.mCallback != null) {
                            BluetoothService.this.mCallback.onScanComplete();
                        }
                    }
                });
                BluetoothService.this.runOnMainThread(new Runnable() {
                    public void run() {
                        if (BluetoothService.this.mCallback != null) {
                            BluetoothService.this.mCallback.onConnecting();
                        }
                    }
                });
            }

            public void onConnectError(final BleException bleException) {
                BluetoothService.this.runOnMainThread(new Runnable() {
                    public void run() {
                        if (BluetoothService.this.mCallback != null) {
                            BluetoothService.this.mCallback.onException(bleException);
                        }
                    }
                });
            }

            public void onConnectSuccess(BluetoothGatt bluetoothGatt, int i) {
                BluetoothService.this.runOnMainThread(new Runnable() {
                    public void run() {
                        if (BluetoothService.this.mCallback != null) {
                            BluetoothService.this.mCallback.onConnectSuccess();
                        }
                    }
                });
            }

            public void onDisConnected(BluetoothGatt bluetoothGatt, int i, final BleException bleException) {
                BluetoothService.this.runOnMainThread(new Runnable() {
                    public void run() {
                        if (BluetoothService.this.mCallback != null) {
                           Log.d("MainAct", bleException.getDescription());
                            BluetoothService.this.mCallback.onDisConnected();
                        }
                    }
                });
            }

            public void onServicesDiscovered(BluetoothGatt bluetoothGatt, int i) {
                BluetoothService.this.mGatt = bluetoothGatt;
                BluetoothService.this.runOnMainThread(new Runnable() {
                    public void run() {
                        if (BluetoothService.this.mCallback != null) {
                            BluetoothService.this.mCallback.onServicesDiscovered();
                        }
                    }
                });
            }
        });
    }

    public void scanAndConnectForMAC(String str, long j) {
        Callback callback = this.mCallback;
        if (callback != null) {
            callback.onStartScan();
        }
        this.mBleManager.scanMacAndConnect(str, j, false, new BleGattCallback() {
            public void onConnecting(BluetoothGatt bluetoothGatt, int i) {
            }

            public void onFoundDevice(final ScanResult scanResult) {
                BluetoothService.this.runOnMainThread(new Runnable() {
                    public void run() {
                        if (BluetoothService.this.mCallback != null) {
                            BluetoothService.this.mCallback.onScanning(scanResult);
                        }
                    }
                });
                BluetoothService.this.runOnMainThread(new Runnable() {
                    public void run() {
                        if (BluetoothService.this.mCallback != null) {
                            BluetoothService.this.mCallback.onScanComplete();
                        }
                    }
                });
                BluetoothService.this.runOnMainThread(new Runnable() {
                    public void run() {
                        if (BluetoothService.this.mCallback != null) {
                            BluetoothService.this.mCallback.onConnecting();
                        }
                    }
                });
            }

            public void onConnectError(final BleException bleException) {
                BluetoothService.this.runOnMainThread(new Runnable() {
                    public void run() {
                        if (BluetoothService.this.mCallback != null) {
                            BluetoothService.this.mCallback.onException(bleException);
                        }
                    }
                });
            }

            public void onConnectSuccess(BluetoothGatt bluetoothGatt, int i) {
                BluetoothService.this.runOnMainThread(new Runnable() {
                    public void run() {
                        if (BluetoothService.this.mCallback != null) {
                            BluetoothService.this.mCallback.onConnectSuccess();
                        }
                    }
                });
            }

            public void onDisConnected(BluetoothGatt bluetoothGatt, int i, final BleException bleException) {
                BluetoothService.this.runOnMainThread(new Runnable() {
                    public void run() {
                        if (BluetoothService.this.mCallback != null) {
                           Log.d("MainAct", bleException.getDescription());
                            BluetoothService.this.mCallback.onDisConnected();
                        }
                    }
                });
            }

            public void onServicesDiscovered(BluetoothGatt bluetoothGatt, int i) {
                BluetoothService.this.mGatt = bluetoothGatt;
                BluetoothService.this.runOnMainThread(new Runnable() {
                    public void run() {
                        if (BluetoothService.this.mCallback != null) {
                            BluetoothService.this.mCallback.onServicesDiscovered();
                        }
                    }
                });
            }
        });
    }

    public boolean read(String str, String str2, BleCharacterCallback bleCharacterCallback) {
        return this.mBleManager.readDevice(str, str2, bleCharacterCallback);
    }

    public boolean write(String str, String str2, byte[] bArr, BleCharacterCallback bleCharacterCallback) {
        return this.mBleManager.writeDevice(str, str2, bArr, bleCharacterCallback);
    }

    public boolean notify(String str, String str2, BleCharacterCallback bleCharacterCallback) {
        return this.mBleManager.notify(str, str2, bleCharacterCallback);
    }

    public boolean indicate(String str, String str2, BleCharacterCallback bleCharacterCallback) {
        return this.mBleManager.indicate(str, str2, bleCharacterCallback);
    }

    public boolean stopNotify(String str, String str2) {
        return this.mBleManager.stopNotify(str, str2);
    }

    public boolean stopIndicate(String str, String str2) {
        return this.mBleManager.stopIndicate(str, str2);
    }

    public boolean readRssi(BleRssiCallback bleRssiCallback) {
        return this.mBleManager.readRssi(bleRssiCallback);
    }
}
