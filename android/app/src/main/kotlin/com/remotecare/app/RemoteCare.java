package com.remotecare.app;

import android.content.ComponentName;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.IBinder;
import android.provider.Settings;
import android.util.Log;

import com.remotecare.app.bp.ble.BluetoothService;
import com.remotecare.app.bp.ble.data.ScanResult;

import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback;
import io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin;
import io.flutter.plugins.firebasemessaging.FlutterFirebaseMessagingService;

public class RemoteCare extends io.flutter.app.FlutterApplication implements PluginRegistrantCallback{

    private static final String TAG = RemoteCare.class.getSimpleName();
    public BluetoothService mBluetoothService;
    public BluetoothServiceCallback mBluetoothServiceCallback;
    public static RemoteCare mAppContext = null;
    private ScanResult mConnectedDevice;
    public static final String DEVICE_SCAN_KEYWORDS = "BP2941";
    public static final long DEVICE_SCAN_TIMEOUT = 5000;
    public static final String UNIT_KPA = "kPa";
    public static final String UNIT_MMHG = "mmHg";
    public static final String UUID_NOTIFY = "0000fff1-0000-1000-8000-00805f9b34fb";
    public static final String UUID_SERVICE = "0000fff0-0000-1000-8000-00805f9b34fb";
    public static final String UUID_WRITE = "0000fff2-0000-1000-8000-00805f9b34fb";
    public static final String SEARCHING = "Searching for the device, make sure you switch on the bluetooth on the device";
    public static final String CONNECTING = "Please wait while we connect to your device";
    public interface BluetoothServiceCallback {
        void onServiceConnected(BluetoothService bluetoothService);
        void onServiceDisconnected();
    }
    ServiceConnection mBluetoothServiceConnection =  new ServiceConnection() {
        @Override
        public void onServiceConnected(ComponentName name, IBinder service) {
            Log.d(TAG, "BluetoothServiceConnected");
            RemoteCare.this.mBluetoothService = ((BluetoothService.BluetoothBinder) service).getService();
            if (mBluetoothServiceCallback != null) {
                mBluetoothServiceCallback.onServiceConnected(mBluetoothService);
            }
        }

        @Override
        public void onServiceDisconnected(ComponentName name) {
            Log.d(TAG, "BluetoothServiceDisconnected");
            if (RemoteCare.this.mBluetoothServiceCallback != null) {
                RemoteCare.this.mBluetoothServiceCallback.onServiceDisconnected();
            }
            RemoteCare.this.mBluetoothService = null;
        }
    };
    public static synchronized RemoteCare getInstance() {
        RemoteCare appContext;
        synchronized (RemoteCare.class) {
            appContext = mAppContext;
        }
        return appContext;
    }

    public BluetoothService getBluetoothService() {
        return this.mBluetoothService;
    }

    public void setBluetoothService(BluetoothService bluetoothService) {
        this.mBluetoothService = bluetoothService;
    }

    public void setConnectedDevice(ScanResult scanResult) {
        this.mConnectedDevice = scanResult;
    }

    public ScanResult getConnectedDevice() {
        return this.mConnectedDevice;
    }

    public void bindBluetoothService(BluetoothServiceCallback bluetoothServiceCallback) {
        Log.d(this.TAG, "bindBluetoothService");
        this.mBluetoothServiceCallback = bluetoothServiceCallback;
        bindService(new Intent(this, BluetoothService.class), this.mBluetoothServiceConnection, BIND_AUTO_CREATE);
    }

    public void unbindBluetoothService() {
        Log.d(this.TAG, "unbindBluetoothService");
        unbindService(this.mBluetoothServiceConnection);
    }

    public String android_id;
    @Override
    public void onCreate() {
        super.onCreate();
        mAppContext = this;
        android_id = Settings.Secure.getString(this.getContentResolver(), Settings.Secure.ANDROID_ID);
        FlutterFirebaseMessagingService.setPluginRegistrant(this);
    }
    @Override
    public void registerWith(PluginRegistry registry) {
        FirebaseMessagingPlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin"));
    }

}
