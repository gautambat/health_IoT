package com.remotecare.app.spo2;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.polidea.rxandroidble2.RxBleClient;
import com.polidea.rxandroidble2.RxBleDevice;
import com.polidea.rxandroidble2.scan.ScanSettings;
import com.remotecare.app.BaseActivity;
import com.remotecare.app.R;
import com.remotecare.app.RemoteCare;
import com.remotecare.app.spo2.bluetooth.Const;
import com.remotecare.app.spo2.bluetooth.ParseRunnable;

import java.util.ArrayList;
import java.util.List;

import io.reactivex.disposables.Disposable;


public class SPo2CaptureActivity extends BaseActivity implements ParseRunnable.OnDataChangeListener {


    private static final String TAG = SPo2CaptureActivity.class.getSimpleName();
    RxBleClient rxBleClient;
    boolean scanInProgress;
    private Disposable flowDisposable;
    public TextView spo2,pulse;
    OxiMeterData oxiMeterData;
    List<OxiMeterData> oxiMeterDataList;
//    PatientData patientData;
    Button saveOxiDataButton,connectionOxiButton;
    RelativeLayout spoeReadingLayout;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_connection);

        spo2 = findViewById(R.id.spo2);
        pulse = findViewById(R.id.pulse);
        saveOxiDataButton = findViewById(R.id.saveOxiDataButton);
        connectionOxiButton = findViewById(R.id.connectionOxiButton);
        spoeReadingLayout = findViewById(R.id.spoeReadingLayout);
        rxBleClient = RxBleClient.create(this);
//        scanForDevices();
//        patientData = new PatientData();
//        patientData.setName("Atchuta");
//        patientData.setDoctorId("123456");
//        patientData.setpId("1");
//        patientData.setAge("26");
//        patientData.setMobileNumber("9999999999");
//        FireStoreHelper.getInstance().addPatientData(patientData);
        oxiMeterDataList = new ArrayList<>();
        oxiMeterData = new OxiMeterData();
       ImageView imageview = findViewById(R.id.imageview);

        imageview.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
//                Intent intent  = new Intent();
//                setResult(1,intent);
                finish();
            }
        });
        saveOxiDataButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(oxiMeterData !=null){

                    //TODO  Send Data back to Flutter Activity populated.
                    //FireStoreHelper.getInstance().addOxiMeterData(oxiMeterData);
//                    saveOxiDataButton.setEnabled(false);

                    String android_id = RemoteCare.getInstance().android_id;
                    oxiMeterData.setDeviceId(android_id);
                    Intent intent  = new Intent();
                    Bundle bundle =  new Bundle();;
                    bundle.putSerializable("spo2",oxiMeterData);

                    intent.putExtras(bundle);
                    setResult(1,intent);
                    finish();
                    Toast.makeText(SPo2CaptureActivity.this, "Data Saved Successfully and the same will be reported to doctor", Toast.LENGTH_SHORT).show();
//                    oxiMeterData.save();

                }
            }
        });
        //intiGoogleFitOptions();


    }
    RxBleDevice device;

    void connectToDevice(RxBleDevice device){
        showProgressDialog(RemoteCare.CONNECTING);
        Disposable notification_setup = device.establishConnection(false)
                .flatMap(rxBleConnection -> rxBleConnection.setupNotification(Const.UUID_CHARACTER_RECEIVE))
                .doOnNext(notificationObservable -> {
                    hideProgressDialog();
                    Log.d(TAG, "Notification setup");
                    this.mParseRunnable = new ParseRunnable(SPo2CaptureActivity.this);
                    new Thread(this.mParseRunnable).start();

                })
                .flatMap(notificationObservable -> notificationObservable) // <-- Notification has been set up, now observe value changes.
                .subscribe(
                        bytes -> {
                            runOnUiThread(new Runnable() {
                                @Override
                                public void run() {
                                    connectionOxiButton.setVisibility(View.GONE);
                                    spoeReadingLayout.setVisibility(View.VISIBLE);
                                }
                            });

                            saveOxiDataButton.setEnabled(true);
                            mParseRunnable.add(bytes);

                            //oxiMeterData.setpId(patientData.getpId());
                        },
                        throwable -> {
                            // Handle an error here.
                            Log.d(TAG, "Exception raised while notification data.");
                        }
                );
    }
    ParseRunnable mParseRunnable;

    void scanForDevices(){
        showProgressDialog(RemoteCare.SEARCHING);
        scanInProgress= true;
        flowDisposable = rxBleClient.scanBleDevices(
                new ScanSettings.Builder()
                        .build())
                .subscribe(
                        rxBleScanResult -> {
                            // Process scan result here.
                            Log.d(TAG,"Found:"+rxBleScanResult.getBleDevice().getName());

                            if(rxBleScanResult.getBleDevice()!=null && rxBleScanResult.getBleDevice().getName()!=null){
                                if(rxBleScanResult.getBleDevice().getName().contains("BerryMed")){
                                    device =  rxBleScanResult.getBleDevice();
                                    hideProgressDialog();
                                    connectToDevice(device);
                                    this.flowDisposable.dispose();
                                }
                            }
                        },
                        throwable -> {
                            // Handle an error here.

                        }
                );
    }

    @Override
    public void onPulseWaveDetected() {
        int value= mParseRunnable.getOxiParams().getPulseRate();
        Log.d(TAG,"onPulseWaveDetected "+value);
        runOnUiThread(new Runnable() {

            @Override
            public void run() {
                    pulse.setText("" + value);
                    Log.d(TAG, "pulse:" + value);
                    oxiMeterData.setPulse(value);
                   // oxiMeterData.setRecordedTime(System.currentTimeMillis());

            }
        });
    }

    @Override
    public void onSpO2ParamsChanged() {
        int value= mParseRunnable.getOxiParams().getSpo2();
        runOnUiThread(new Runnable() {

            @Override
            public void run() {

                if (value!=127) {
                    spo2.setText("" + value);
                    Log.d(TAG, "Spo2:" + value);
                    oxiMeterData.setSpo2(value);
                   // oxiMeterData.setRecordedTime(System.currentTimeMillis());
                }

            }
        });

    }

    @Override
    public void onSpO2WaveChanged(int i) {
    }

    @Override
    public void onDataReceived() {

    }

    @Override
    protected void onStop() {
        super.onStop();
        if(flowDisposable!=null)
        flowDisposable.dispose();
        rxBleClient = null;

    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if(flowDisposable!=null)
            flowDisposable.dispose();
//        if(receiver!= null)
//            unregisterReceiver(receiver);
       // rxBleClient = null;
    }

    public void onConnectClicked(View view) {

        if(!scanInProgress){
            scanForDevices();
        }else if(flowDisposable!=null){
            flowDisposable.dispose();
            scanInProgress = false;

        }
    }
}
