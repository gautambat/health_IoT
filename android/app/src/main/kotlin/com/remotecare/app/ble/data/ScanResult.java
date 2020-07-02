package com.remotecare.app.bp.ble.data;

import android.bluetooth.BluetoothDevice;
import android.os.Parcel;
import android.os.Parcelable;

/* renamed from: com.drtrust.bp.ble.data.ScanResult */
public class ScanResult implements Parcelable {
    public static final Creator<ScanResult> CREATOR = new Creator<ScanResult>() {
        public ScanResult createFromParcel(Parcel parcel) {
            return new ScanResult(parcel);
        }

        public ScanResult[] newArray(int i) {
            return new ScanResult[i];
        }
    };
    private byte mConnected;
    private BluetoothDevice mDevice;
    private int mRssi;
    private byte[] mScanRecord;
    private long mTimestampNanos;

    public int describeContents() {
        return 0;
    }

    public ScanResult(BluetoothDevice bluetoothDevice, int i, byte[] bArr, long j) {
        this.mDevice = bluetoothDevice;
        this.mScanRecord = bArr;
        this.mRssi = i;
        this.mTimestampNanos = j;
        this.mConnected = 0;
    }

    protected ScanResult(Parcel parcel) {
        this.mDevice = (BluetoothDevice) parcel.readParcelable(BluetoothDevice.class.getClassLoader());
        this.mScanRecord = parcel.createByteArray();
        this.mRssi = parcel.readInt();
        this.mTimestampNanos = parcel.readLong();
        this.mConnected = parcel.readByte();
    }

    public void writeToParcel(Parcel parcel, int i) {
        parcel.writeParcelable(this.mDevice, i);
        parcel.writeByteArray(this.mScanRecord);
        parcel.writeInt(this.mRssi);
        parcel.writeLong(this.mTimestampNanos);
        parcel.writeByte(this.mConnected);
    }

    public BluetoothDevice getDevice() {
        return this.mDevice;
    }

    public void setDevice(BluetoothDevice bluetoothDevice) {
        this.mDevice = bluetoothDevice;
    }

    public byte[] getScanRecord() {
        return this.mScanRecord;
    }

    public void setScanRecord(byte[] bArr) {
        this.mScanRecord = bArr;
    }

    public int getRssi() {
        return this.mRssi;
    }

    public void setRssi(int i) {
        this.mRssi = i;
    }

    public long getTimestampNanos() {
        return this.mTimestampNanos;
    }

    public void setTimestampNanos(long j) {
        this.mTimestampNanos = j;
    }

    public boolean getConnected() {
        return this.mConnected != 0;
    }

    public void setConnected(boolean z) {
        this.mConnected = z ? (byte) 1 : 0;
    }
}
