package com.remotecare.app;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.TextView;

public class SpoActivity extends Activity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_sp);
        TextView spo2Textview =(TextView)findViewById(R.id.spo2Textview);


        int index= getIntent().getIntExtra("index",0);
        spo2Textview.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent  = new Intent();
                Bundle bundle =  new Bundle();;
                bundle.putSerializable("index",index);

                intent.putExtras(bundle);
                setResult(1,intent);
                finish();
            }
        });
    }
}
