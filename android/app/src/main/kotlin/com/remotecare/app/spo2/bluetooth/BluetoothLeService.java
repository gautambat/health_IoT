package com.remotecare.app.spo2.bluetooth;

import android.app.Service;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothGatt;
import android.bluetooth.BluetoothGattCallback;
import android.bluetooth.BluetoothGattCharacteristic;
import android.bluetooth.BluetoothGattDescriptor;
import android.bluetooth.BluetoothGattService;
import android.bluetooth.BluetoothManager;
import android.content.Intent;
import android.os.Binder;
import android.os.IBinder;
import android.util.Log;

import java.util.List;

public class BluetoothLeService extends Service {
    public static final String ACTION_DATA_AVAILABLE = "com.example.bluetooth.le.ACTION_DATA_AVAILABLE";
    public static final String ACTION_GATT_CONNECTED = "com.example.bluetooth.le.ACTION_GATT_CONNECTED";
    public static final String ACTION_GATT_DISCONNECTED = "com.example.bluetooth.le.ACTION_GATT_DISCONNECTED";
    public static final String ACTION_GATT_SERVICES_DISCOVERED = "com.example.bluetooth.le.ACTION_GATT_SERVICES_DISCOVERED";
    public static final String ACTION_SPO2_DATA_AVAILABLE = "com.example.bluetooth.le.ACTION_SPO2_DATA_AVAILABLE";
    public static final String EXTRA_DATA = "com.example.bluetooth.le.EXTRA_DATA";
    private static final int STATE_CONNECTED = 2;
    private static final int STATE_CONNECTING = 1;
    private static final int STATE_DISCONNECTED = 0;
    /* access modifiers changed from: private */
    public static final String TAG = BluetoothLeService.class.getSimpleName();
    private static final int TRANSFER_PACKAGE_SIZE = 10;
    private byte[] buf = new byte[10];
    private int bufIndex = 0;
    private final IBinder mBinder = new LocalBinder();
    private BluetoothAdapter mBluetoothAdapter;
    private String mBluetoothDeviceAddress;
    /* access modifiers changed from: private */
    public BluetoothGatt mBluetoothGatt;
    private BluetoothManager mBluetoothManager;
    /* access modifiers changed from: private */
    public int mConnectionState = 0;
    private final BluetoothGattCallback mGattCallback = new BluetoothGattCallback() {
        public void onConnectionStateChange(BluetoothGatt bluetoothGatt, int i, int i2) {
            if (i2 == 2) {
                BluetoothLeService.this.mConnectionState = 2;
                BluetoothLeService.this.broadcastUpdate(BluetoothLeService.ACTION_GATT_CONNECTED);
                Log.i(BluetoothLeService.TAG, "Connected to GATT server.");
                String access$200 = BluetoothLeService.TAG;
                StringBuilder sb = new StringBuilder();
                sb.append("Attempting to start service discovery:");
                sb.append(BluetoothLeService.this.mBluetoothGatt.discoverServices());
                Log.i(access$200, sb.toString());
            } else if (i2 == 0) {
                BluetoothLeService.this.mConnectionState = 0;
                Log.i(BluetoothLeService.TAG, "Disconnected from GATT server.");
                BluetoothLeService.this.broadcastUpdate(BluetoothLeService.ACTION_GATT_DISCONNECTED);
            }
        }

        public void onServicesDiscovered(BluetoothGatt bluetoothGatt, int i) {
            if (i == 0) {
                BluetoothLeService.this.broadcastUpdate(BluetoothLeService.ACTION_GATT_SERVICES_DISCOVERED);
                return;
            }
            String access$200 = BluetoothLeService.TAG;
            StringBuilder sb = new StringBuilder();
            sb.append("onServicesDiscovered received: ");
            sb.append(i);
            Log.w(access$200, sb.toString());
        }

        public void onCharacteristicRead(BluetoothGatt bluetoothGatt, BluetoothGattCharacteristic bluetoothGattCharacteristic, int i) {
            if (i == 0) {
                BluetoothLeService.this.broadcastUpdate(BluetoothLeService.ACTION_DATA_AVAILABLE, bluetoothGattCharacteristic);
            }
        }

        public void onCharacteristicChanged(BluetoothGatt bluetoothGatt, BluetoothGattCharacteristic bluetoothGattCharacteristic) {
            BluetoothLeService.this.broadcastUpdate(BluetoothLeService.ACTION_SPO2_DATA_AVAILABLE, bluetoothGattCharacteristic);
        }
    };

    public class LocalBinder extends Binder {
        public LocalBinder() {
        }

        /* access modifiers changed from: 0000 */
        public BluetoothLeService getService() {
            return BluetoothLeService.this;
        }
    }

    /* access modifiers changed from: private */
    public void broadcastUpdate(String str) {
        sendBroadcast(new Intent(str));
    }

    /* access modifiers changed from: private */
    public void broadcastUpdate(String str, BluetoothGattCharacteristic bluetoothGattCharacteristic) {
        byte[] value;
        Intent intent = new Intent(str);
        boolean equals = Const.UUID_CHARACTER_RECEIVE.equals(bluetoothGattCharacteristic.getUuid());
        String str2 = EXTRA_DATA;
        if (equals) {
            for (byte b : bluetoothGattCharacteristic.getValue()) {
                byte[] bArr = this.buf;
                int i = this.bufIndex;
                bArr[i] = b;
                this.bufIndex = i + 1;
                if (this.bufIndex == bArr.length) {
                    intent.putExtra(str2, bArr);
                    sendBroadcast(intent);
                    this.bufIndex = 0;
                }
            }
            return;
        }
        byte[] value2 = bluetoothGattCharacteristic.getValue();
        if (value2 != null && value2.length > 0) {
            new StringBuilder(value2.length);
            intent.putExtra(str2, new String(value2));
            sendBroadcast(intent);
        }
    }

    public IBinder onBind(Intent intent) {
        return this.mBinder;
    }

    public boolean onUnbind(Intent intent) {
        close();
        return super.onUnbind(intent);
    }

    public boolean initialize() {
        if (this.mBluetoothManager == null) {
            this.mBluetoothManager = (BluetoothManager) getSystemService("bluetooth");
            if (this.mBluetoothManager == null) {
                Log.e(TAG, "Unable to initialize BluetoothManager.");
                return false;
            }
        }
        this.mBluetoothAdapter = this.mBluetoothManager.getAdapter();
        if (this.mBluetoothAdapter != null) {
            return true;
        }
        Log.e(TAG, "Unable to obtain a BluetoothAdapter.");
        return false;
    }

    public boolean connect(String str) {
        if (this.mBluetoothAdapter == null || str == null) {
            Log.w(TAG, "BluetoothAdapter not initialized or unspecified address.");
            return false;
        }
        String str2 = this.mBluetoothDeviceAddress;
        if (str2 == null || !str.equals(str2) || this.mBluetoothGatt == null) {
            BluetoothDevice remoteDevice = this.mBluetoothAdapter.getRemoteDevice(str);
            if (remoteDevice == null) {
                Log.w(TAG, "Device not found.  Unable to connect.");
                return false;
            }
            this.mBluetoothGatt = remoteDevice.connectGatt(this, false, this.mGattCallback);
            Log.d(TAG, "Trying to create a new connection.");
            this.mBluetoothDeviceAddress = str;
            this.mConnectionState = 1;
            return true;
        }
        Log.d(TAG, "Trying to use an existing mBluetoothGatt for connection.");
        if (!this.mBluetoothGatt.connect()) {
            return false;
        }
        this.mConnectionState = 1;
        return true;
    }

    public void disconnect() {
        if (this.mBluetoothAdapter != null) {
            BluetoothGatt bluetoothGatt = this.mBluetoothGatt;
            if (bluetoothGatt != null) {
                bluetoothGatt.disconnect();
                return;
            }
        }
        Log.w(TAG, "BluetoothAdapter not initialized");
    }

    public void close() {
        BluetoothGatt bluetoothGatt = this.mBluetoothGatt;
        if (bluetoothGatt != null) {
            bluetoothGatt.close();
            this.mBluetoothGatt = null;
        }
    }

    public void readCharacteristic(BluetoothGattCharacteristic bluetoothGattCharacteristic) {
        if (this.mBluetoothAdapter != null) {
            BluetoothGatt bluetoothGatt = this.mBluetoothGatt;
            if (bluetoothGatt != null) {
                bluetoothGatt.readCharacteristic(bluetoothGattCharacteristic);
                return;
            }
        }
        Log.w(TAG, "BluetoothAdapter not initialized");
    }

    public void setCharacteristicNotification(BluetoothGattCharacteristic bluetoothGattCharacteristic, boolean z) {
        if (this.mBluetoothAdapter != null) {
            BluetoothGatt bluetoothGatt = this.mBluetoothGatt;
            if (bluetoothGatt != null) {
                bluetoothGatt.setCharacteristicNotification(bluetoothGattCharacteristic, z);
                if (Const.UUID_CHARACTER_RECEIVE.equals(bluetoothGattCharacteristic.getUuid())) {
                    BluetoothGattDescriptor descriptor = bluetoothGattCharacteristic.getDescriptor(Const.UUID_CLIENT_CHARACTER_CONFIG);
                    if (z) {
                        descriptor.setValue(BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE);
                    } else {
                        descriptor.setValue(BluetoothGattDescriptor.DISABLE_NOTIFICATION_VALUE);
                    }
                    this.mBluetoothGatt.writeDescriptor(descriptor);
                }
                return;
            }
        }
        Log.w(TAG, "BluetoothAdapter not initialized");
    }

    public List<BluetoothGattService> getSupportedGattServices() {
        BluetoothGatt bluetoothGatt = this.mBluetoothGatt;
        if (bluetoothGatt == null) {
            return null;
        }
        return bluetoothGatt.getServices();
    }

    public void write(BluetoothGattCharacteristic bluetoothGattCharacteristic, byte[] bArr) {
        int i = 0;
        while (bArr.length - i > 10) {
            byte[] bArr2 = new byte[10];
            System.arraycopy(bArr, i, bArr2, 0, 10);
            bluetoothGattCharacteristic.setValue(bArr2);
            this.mBluetoothGatt.writeCharacteristic(bluetoothGattCharacteristic);
            i += 10;
        }
        if (bArr.length - i != 0) {
            byte[] bArr3 = new byte[(bArr.length - i)];
            System.arraycopy(bArr, i, bArr3, 0, bArr.length - i);
            bluetoothGattCharacteristic.setValue(bArr3);
            this.mBluetoothGatt.writeCharacteristic(bluetoothGattCharacteristic);
        }
    }
}
