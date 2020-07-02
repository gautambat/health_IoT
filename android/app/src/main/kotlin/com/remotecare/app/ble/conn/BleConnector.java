package com.remotecare.app.bp.ble.conn;

import android.bluetooth.BluetoothGatt;
import android.bluetooth.BluetoothGattCallback;
import android.bluetooth.BluetoothGattCharacteristic;
import android.bluetooth.BluetoothGattDescriptor;
import android.bluetooth.BluetoothGattService;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;

import com.remotecare.app.bp.ble.bluetooth.BleBluetooth;
import com.remotecare.app.bp.ble.exception.GattException;
import com.remotecare.app.bp.ble.exception.OtherException;
import com.remotecare.app.bp.ble.exception.TimeoutException;
import com.remotecare.app.bp.ble.utils.BleLog;
import com.remotecare.app.bp.ble.utils.HexUtil;

import java.util.Arrays;
import java.util.UUID;
import java.util.concurrent.atomic.AtomicBoolean;

/* renamed from: com.drtrust.bp.ble.conn.BleConnector */
public class BleConnector {
    private static final int MSG_INDICATE_DES = 8;
    private static final int MSG_NOTIFY_CHA = 6;
    private static final int MSG_NOTIY_DES = 7;
    private static final int MSG_READ_CHA = 3;
    private static final int MSG_READ_DES = 4;
    private static final int MSG_READ_RSSI = 5;
    private static final int MSG_WRIATE_DES = 2;
    private static final int MSG_WRITE_CHA = 1;
    private static final String TAG = BleConnector.class.getSimpleName();
    private static final String UUID_CLIENT_CHARACTERISTIC_CONFIG_DESCRIPTOR = "00002902-0000-1000-8000-00805f9b34fb";
    private static int timeOutMillis = 10000;
    private BleBluetooth bleBluetooth;
    private BluetoothGatt bluetoothGatt;
    private BluetoothGattCharacteristic characteristic;
    private BluetoothGattDescriptor descriptor;
    /* access modifiers changed from: private */
    public Handler handler;
    private BluetoothGattService service;

    /* renamed from: com.drtrust.bp.ble.conn.BleConnector$MyHandler */
    private static final class MyHandler extends Handler {
        private MyHandler() {
        }

        public void handleMessage(Message message) {
            BleCallback bleCallback = (BleCallback) message.obj;
            if (bleCallback != null) {
                bleCallback.onFailure(new TimeoutException());
            }
            message.obj = null;
        }
    }

    public BleConnector(BleBluetooth bleBluetooth2) {
        this.handler = new MyHandler();
        this.bleBluetooth = bleBluetooth2;
        this.bluetoothGatt = bleBluetooth2.getBluetoothGatt();
        this.handler = new Handler(Looper.getMainLooper());
    }

    public BleConnector(BleBluetooth bleBluetooth2, BluetoothGattService bluetoothGattService, BluetoothGattCharacteristic bluetoothGattCharacteristic, BluetoothGattDescriptor bluetoothGattDescriptor) {
        this(bleBluetooth2);
        this.service = bluetoothGattService;
        this.characteristic = bluetoothGattCharacteristic;
        this.descriptor = bluetoothGattDescriptor;
    }

    public BleConnector(BleBluetooth bleBluetooth2, UUID uuid, UUID uuid2, UUID uuid3, UUID uuid4) {
        this(bleBluetooth2);
        withUUID(uuid, uuid2, uuid3);
    }

    public BleConnector(BleBluetooth bleBluetooth2, String str, String str2, String str3, String str4) {
        this(bleBluetooth2);
        withUUIDString(str, str2, str3);
    }

    public BleConnector withUUID(UUID uuid, UUID uuid2, UUID uuid3) {
        if (uuid != null) {
            BluetoothGatt bluetoothGatt2 = this.bluetoothGatt;
            if (bluetoothGatt2 != null) {
                this.service = bluetoothGatt2.getService(uuid);
            }
        }
        BluetoothGattService bluetoothGattService = this.service;
        if (!(bluetoothGattService == null || uuid2 == null)) {
            this.characteristic = bluetoothGattService.getCharacteristic(uuid2);
        }
        BluetoothGattCharacteristic bluetoothGattCharacteristic = this.characteristic;
        if (!(bluetoothGattCharacteristic == null || uuid3 == null)) {
            this.descriptor = bluetoothGattCharacteristic.getDescriptor(uuid3);
        }
        return this;
    }

    public BleConnector withUUIDString(String str, String str2, String str3) {
        return withUUID(formUUID(str), formUUID(str2), formUUID(str3));
    }

    private UUID formUUID(String str) {
        if (str == null) {
            return null;
        }
        return UUID.fromString(str);
    }

    public boolean enableCharacteristicNotify(BleCharacterCallback bleCharacterCallback, String str) {
        if (getCharacteristic() == null || (getCharacteristic().getProperties() | 16) <= 0) {
            if (bleCharacterCallback != null) {
                bleCharacterCallback.onFailure(new OtherException("this characteristic not support notify!"));
                bleCharacterCallback.onInitiatedResult(false);
            }
            return false;
        }
        String str2 = TAG;
        StringBuilder sb = new StringBuilder();
        sb.append("characteristic.getProperties():");
        sb.append(getCharacteristic().getProperties());
        BleLog.m30w(str2, sb.toString());
        handleCharacteristicNotificationCallback(bleCharacterCallback, str);
        return setCharacteristicNotification(getBluetoothGatt(), getCharacteristic(), true, bleCharacterCallback);
    }

    public boolean disableCharacteristicNotify() {
        if (getCharacteristic() == null || (getCharacteristic().getProperties() | 16) <= 0) {
            return false;
        }
        String str = TAG;
        StringBuilder sb = new StringBuilder();
        sb.append("characteristic.getProperties():");
        sb.append(getCharacteristic().getProperties());
        BleLog.m30w(str, sb.toString());
        return setCharacteristicNotification(getBluetoothGatt(), getCharacteristic(), false, null);
    }

    private boolean setCharacteristicNotification(BluetoothGatt bluetoothGatt2, BluetoothGattCharacteristic bluetoothGattCharacteristic, boolean z, BleCharacterCallback bleCharacterCallback) {
        if (bluetoothGatt2 == null || bluetoothGattCharacteristic == null) {
            if (bleCharacterCallback != null) {
                bleCharacterCallback.onFailure(new OtherException("gatt or characteristic equal null"));
                bleCharacterCallback.onInitiatedResult(false);
            }
            return false;
        }
        boolean characteristicNotification = bluetoothGatt2.setCharacteristicNotification(bluetoothGattCharacteristic, z);
        String str = TAG;
        StringBuilder sb = new StringBuilder();
        sb.append("setCharacteristicNotification: ");
        sb.append(z);
        sb.append("\nsuccess: ");
        sb.append(characteristicNotification);
        sb.append("\ncharacteristic.getUuid(): ");
        sb.append(bluetoothGattCharacteristic.getUuid());
        BleLog.m12d(str, sb.toString());
        BluetoothGattDescriptor descriptor2 = bluetoothGattCharacteristic.getDescriptor(formUUID(UUID_CLIENT_CHARACTERISTIC_CONFIG_DESCRIPTOR));
        if (descriptor2 != null) {
            descriptor2.setValue(z ? BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE : BluetoothGattDescriptor.DISABLE_NOTIFICATION_VALUE);
            boolean writeDescriptor = bluetoothGatt2.writeDescriptor(descriptor2);
            if (bleCharacterCallback != null) {
                bleCharacterCallback.onInitiatedResult(writeDescriptor);
            }
            return writeDescriptor;
        }
        if (bleCharacterCallback != null) {
            bleCharacterCallback.onFailure(new OtherException("notify operation failed"));
            bleCharacterCallback.onInitiatedResult(false);
        }
        return false;
    }

    public boolean enableCharacteristicIndicate(BleCharacterCallback bleCharacterCallback, String str) {
        if (getCharacteristic() == null || (getCharacteristic().getProperties() | 16) <= 0) {
            if (bleCharacterCallback != null) {
                bleCharacterCallback.onFailure(new OtherException("this characteristic not support indicate!"));
            }
            return false;
        }
        String str2 = TAG;
        StringBuilder sb = new StringBuilder();
        sb.append("characteristic.getProperties():");
        sb.append(getCharacteristic().getProperties());
        BleLog.m30w(str2, sb.toString());
        handleCharacteristicIndicationCallback(bleCharacterCallback, str);
        return setCharacteristicIndication(getBluetoothGatt(), getCharacteristic(), true, bleCharacterCallback);
    }

    public boolean disableCharacteristicIndicate() {
        if (getCharacteristic() == null || (getCharacteristic().getProperties() | 16) <= 0) {
            return false;
        }
        String str = TAG;
        StringBuilder sb = new StringBuilder();
        sb.append("characteristic.getProperties():");
        sb.append(getCharacteristic().getProperties());
        BleLog.m30w(str, sb.toString());
        return setCharacteristicIndication(getBluetoothGatt(), getCharacteristic(), false, null);
    }

    private boolean setCharacteristicIndication(BluetoothGatt bluetoothGatt2, BluetoothGattCharacteristic bluetoothGattCharacteristic, boolean z, BleCharacterCallback bleCharacterCallback) {
        if (bluetoothGatt2 == null || bluetoothGattCharacteristic == null) {
            if (bleCharacterCallback != null) {
                bleCharacterCallback.onFailure(new OtherException("gatt or characteristic equal null"));
                bleCharacterCallback.onInitiatedResult(false);
            }
            return false;
        }
        boolean characteristicNotification = bluetoothGatt2.setCharacteristicNotification(bluetoothGattCharacteristic, z);
        String str = TAG;
        StringBuilder sb = new StringBuilder();
        sb.append("setCharacteristicIndication:");
        sb.append(z);
        sb.append("\nsuccess:");
        sb.append(characteristicNotification);
        sb.append("\ncharacteristic.getUuid():");
        sb.append(bluetoothGattCharacteristic.getUuid());
        BleLog.m12d(str, sb.toString());
        BluetoothGattDescriptor descriptor2 = bluetoothGattCharacteristic.getDescriptor(formUUID(UUID_CLIENT_CHARACTERISTIC_CONFIG_DESCRIPTOR));
        if (descriptor2 != null) {
            descriptor2.setValue(z ? BluetoothGattDescriptor.ENABLE_INDICATION_VALUE : BluetoothGattDescriptor.DISABLE_NOTIFICATION_VALUE);
            boolean writeDescriptor = bluetoothGatt2.writeDescriptor(descriptor2);
            if (bleCharacterCallback != null) {
                bleCharacterCallback.onInitiatedResult(writeDescriptor);
            }
            return writeDescriptor;
        }
        if (bleCharacterCallback != null) {
            bleCharacterCallback.onFailure(new OtherException("indicate operation failed"));
            bleCharacterCallback.onInitiatedResult(false);
        }
        return false;
    }

    public boolean writeCharacteristic(byte[] bArr, BleCharacterCallback bleCharacterCallback, String str) {
        if (bArr == null) {
            if (bleCharacterCallback != null) {
                bleCharacterCallback.onFailure(new OtherException("the data to be written is empty"));
                bleCharacterCallback.onInitiatedResult(false);
            }
            return false;
        } else if (getCharacteristic() == null || (getCharacteristic().getProperties() & 12) == 0) {
            if (bleCharacterCallback != null) {
                bleCharacterCallback.onFailure(new OtherException("this characteristic not support write!"));
                bleCharacterCallback.onInitiatedResult(false);
            }
            return false;
        } else {
            String str2 = TAG;
            StringBuilder sb = new StringBuilder();
            sb.append(getCharacteristic().getUuid());
            sb.append("\ncharacteristic.getProperties():");
            sb.append(getCharacteristic().getProperties());
            sb.append("\ncharacteristic.getValue(): ");
            sb.append(Arrays.toString(getCharacteristic().getValue()));
            sb.append("\ncharacteristic write bytes: ");
            sb.append(Arrays.toString(bArr));
            sb.append("\nhex: ");
            sb.append(HexUtil.encodeHexStr(bArr));
            BleLog.m12d(str2, sb.toString());
            handleCharacteristicWriteCallback(bleCharacterCallback, str);
            getCharacteristic().setValue(bArr);
            return handleAfterInitialed(getBluetoothGatt().writeCharacteristic(getCharacteristic()), bleCharacterCallback);
        }
    }

    public boolean readCharacteristic(BleCharacterCallback bleCharacterCallback, String str) {
        if (getCharacteristic() == null || (this.characteristic.getProperties() & 2) <= 0) {
            if (bleCharacterCallback != null) {
                bleCharacterCallback.onFailure(new OtherException("this characteristic not support read!"));
                bleCharacterCallback.onInitiatedResult(false);
            }
            return false;
        }
        String str2 = TAG;
        StringBuilder sb = new StringBuilder();
        sb.append(getCharacteristic().getUuid());
        sb.append("\ncharacteristic.getProperties(): ");
        sb.append(getCharacteristic().getProperties());
        sb.append("\ncharacteristic.getValue(): ");
        sb.append(Arrays.toString(getCharacteristic().getValue()));
        BleLog.m12d(str2, sb.toString());
        setCharacteristicNotification(getBluetoothGatt(), getCharacteristic(), false, bleCharacterCallback);
        handleCharacteristicReadCallback(bleCharacterCallback, str);
        return handleAfterInitialed(getBluetoothGatt().readCharacteristic(getCharacteristic()), bleCharacterCallback);
    }

    public boolean readRemoteRssi(BleRssiCallback bleRssiCallback) {
        handleRSSIReadCallback(bleRssiCallback);
        return handleAfterInitialed(getBluetoothGatt().readRemoteRssi(), bleRssiCallback);
    }

    private void handleCharacteristicNotificationCallback(final BleCharacterCallback bleCharacterCallback, final String str) {
        if (bleCharacterCallback != null) {
            listenAndTimer(bleCharacterCallback, 6, str, new BluetoothGattCallback() {
                AtomicBoolean msgRemoved = new AtomicBoolean(false);

                public void onCharacteristicChanged(BluetoothGatt bluetoothGatt, BluetoothGattCharacteristic bluetoothGattCharacteristic) {
                    if (!this.msgRemoved.getAndSet(true)) {
                        BleConnector.this.handler.removeMessages(6, this);
                    }
                    if (bluetoothGattCharacteristic.getUuid().equals(UUID.fromString(str))) {
                        bleCharacterCallback.onSuccess(bluetoothGattCharacteristic);
                    }
                }
            });
        }
    }

    private void handleCharacteristicIndicationCallback(final BleCharacterCallback bleCharacterCallback, final String str) {
        if (bleCharacterCallback != null) {
            listenAndTimer(bleCharacterCallback, 8, str, new BluetoothGattCallback() {
                AtomicBoolean msgRemoved = new AtomicBoolean(false);

                public void onCharacteristicChanged(BluetoothGatt bluetoothGatt, BluetoothGattCharacteristic bluetoothGattCharacteristic) {
                    if (!this.msgRemoved.getAndSet(true)) {
                        BleConnector.this.handler.removeMessages(8, this);
                    }
                    if (bluetoothGattCharacteristic.getUuid().equals(UUID.fromString(str))) {
                        bleCharacterCallback.onSuccess(bluetoothGattCharacteristic);
                    }
                }
            });
        }
    }

    private void handleCharacteristicWriteCallback(final BleCharacterCallback bleCharacterCallback, final String str) {
        if (bleCharacterCallback != null) {
            listenAndTimer(bleCharacterCallback, 1, str, new BluetoothGattCallback() {
                public void onCharacteristicWrite(BluetoothGatt bluetoothGatt, BluetoothGattCharacteristic bluetoothGattCharacteristic, int i) {
                    BleConnector.this.handler.removeMessages(1, this);
                    if (i != 0) {
                        bleCharacterCallback.onFailure(new GattException(i));
                    } else if (bluetoothGattCharacteristic.getUuid().equals(UUID.fromString(str))) {
                        bleCharacterCallback.onSuccess(bluetoothGattCharacteristic);
                    }
                }
            });
        }
    }

    private void handleCharacteristicReadCallback(final BleCharacterCallback bleCharacterCallback, final String str) {
        if (bleCharacterCallback != null) {
            listenAndTimer(bleCharacterCallback, 3, str, new BluetoothGattCallback() {
                AtomicBoolean msgRemoved = new AtomicBoolean(false);

                public void onCharacteristicRead(BluetoothGatt bluetoothGatt, BluetoothGattCharacteristic bluetoothGattCharacteristic, int i) {
                    if (!this.msgRemoved.getAndSet(true)) {
                        BleConnector.this.handler.removeMessages(3, this);
                    }
                    if (i != 0) {
                        bleCharacterCallback.onFailure(new GattException(i));
                    } else if (bluetoothGattCharacteristic.getUuid().equals(UUID.fromString(str))) {
                        bleCharacterCallback.onSuccess(bluetoothGattCharacteristic);
                    }
                }
            });
        }
    }

    private void handleRSSIReadCallback(final BleRssiCallback bleRssiCallback) {
        if (bleRssiCallback != null) {
            listenAndTimer(bleRssiCallback, 5, BleBluetooth.READ_RSSI_KEY, new BluetoothGattCallback() {
                public void onReadRemoteRssi(BluetoothGatt bluetoothGatt, int i, int i2) {
                    BleConnector.this.handler.removeMessages(5, this);
                    if (i2 == 0) {
                        bleRssiCallback.onSuccess(i);
                    } else {
                        bleRssiCallback.onFailure(new GattException(i2));
                    }
                }
            });
        }
    }

    private boolean handleAfterInitialed(boolean z, BleCallback bleCallback) {
        if (bleCallback != null) {
            if (!z) {
                bleCallback.onFailure(new OtherException("write or read operation failed"));
            }
            bleCallback.onInitiatedResult(z);
        }
        return z;
    }

    private void listenAndTimer(BleCallback bleCallback, int i, String str, BluetoothGattCallback bluetoothGattCallback) {
        bleCallback.setBluetoothGattCallback(bluetoothGattCallback);
        this.bleBluetooth.addGattCallback(str, bluetoothGattCallback);
        this.handler.sendMessageDelayed(this.handler.obtainMessage(i, bleCallback), (long) timeOutMillis);
    }

    public BluetoothGatt getBluetoothGatt() {
        return this.bluetoothGatt;
    }

    public BleConnector setBluetoothGatt(BluetoothGatt bluetoothGatt2) {
        this.bluetoothGatt = bluetoothGatt2;
        return this;
    }

    public BluetoothGattService getService() {
        return this.service;
    }

    public BleConnector setService(BluetoothGattService bluetoothGattService) {
        this.service = bluetoothGattService;
        return this;
    }

    public BluetoothGattCharacteristic getCharacteristic() {
        return this.characteristic;
    }

    public BleConnector setCharacteristic(BluetoothGattCharacteristic bluetoothGattCharacteristic) {
        this.characteristic = bluetoothGattCharacteristic;
        return this;
    }

    public BluetoothGattDescriptor getDescriptor() {
        return this.descriptor;
    }

    public BleConnector setDescriptor(BluetoothGattDescriptor bluetoothGattDescriptor) {
        this.descriptor = bluetoothGattDescriptor;
        return this;
    }

    public int getTimeOutMillis() {
        return timeOutMillis;
    }

    public BleConnector setTimeOutMillis(int i) {
        timeOutMillis = i;
        return this;
    }
}
