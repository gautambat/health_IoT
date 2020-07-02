
package com.remotecare.app;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import com.google.gson.Gson;
import com.remotecare.app.spo2.OxiMeterData;
import com.remotecare.app.spo2.SPo2CaptureActivity;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.JSONMethodCodec;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "flutter.native/helper";

    public static  final int REQUEST_CODE_SPO2 = 0x011;
    private static final String TAG = MainActivity.class.getSimpleName();
    private MethodChannel.Result finalResult;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
       // GeneratedPluginRegistrant.registerWith(MainActivity.this);
        new MethodChannel(getFlutterEngine().getDartExecutor(), CHANNEL, JSONMethodCodec.INSTANCE).setMethodCallHandler(
                (call, result) -> {
                    if(call.method.equals("fromSp")){
                        Intent i = new Intent(MainActivity.this, SPo2CaptureActivity.class);
                        finalResult = result;
                        startActivityForResult(i,REQUEST_CODE_SPO2);
                    }
                }
        );
    }




    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
//        OxiMeterData spo2 = new  OxiMeterData();
//        spo2.setPulse(120);
//        spo2.setSpo2(85);
//        spo2.setManual(false);
//        Gson spo2Json = new Gson();
//        String s = spo2Json.toJson(spo2);
//        Log.d(TAG,spo2.toString());
//        finalResult.success(s);
        if(data!=null){
            Bundle extras = data.getExtras();
            switch (requestCode){
                case REQUEST_CODE_SPO2:

//                    OxiMeterData spo2 = new  OxiMeterData();
//                    spo2.setPulse(120);
//                    spo2.setSpo2(85);
//                    spo2.setManual(false);
//                    Gson spo2Json = new Gson();
//                    String s1 = spo2Json.toJson(spo2);
//                    Log.d(TAG,spo2.toString());
//                    finalResult.success(s1);
                    if(extras!=null){
                        OxiMeterData spo2 = (OxiMeterData) extras.getSerializable("spo2");
//                        Log.d(TAG,spo2.toString());
                        Gson spo2Json = new Gson();
                        String s = spo2Json.toJson(spo2);
                        Log.d(TAG,spo2.toString());
                        finalResult.success(s);
                    }
                    break;

            }
        }
    }
}