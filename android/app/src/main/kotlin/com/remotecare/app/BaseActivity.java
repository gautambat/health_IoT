package com.remotecare.app;


import android.app.ProgressDialog;
import android.graphics.Color;
import android.os.Bundle;
import android.widget.ProgressBar;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

public abstract class BaseActivity extends AppCompatActivity{

    private static final String TAG = BaseActivity.class.getSimpleName();
//    private AlertDialog progressAlertDialog;
    private ProgressDialog progressAlertDialog;
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }
    public void showProgressDialog(String message) {
        try {
            if (!isFinishing()) {
                if (progressAlertDialog != null)
                    if (progressAlertDialog.isShowing())
                        progressAlertDialog.dismiss();
                 progressAlertDialog = new ProgressDialog(this);
//                progressAlertDialog.setTitle("Loading");
                progressAlertDialog.setMessage(message);
                progressAlertDialog.setCancelable(true); // disable dismiss by tapping outside of the dialog
                progressAlertDialog.show();
                ProgressBar progressbar=(ProgressBar)progressAlertDialog.findViewById(android.R.id.progress);
                progressbar.getIndeterminateDrawable().setColorFilter(Color.parseColor("#ff00ba75"), android.graphics.PorterDuff.Mode.SRC_IN);
//                AlertDialog.Builder builder = new AlertDialog.Builder(this);
//                builder.setCancelable(true); // if you want user to wait for some process to finish,
//                builder.setView(R.layout.progress_dialog);
//                this.progressAlertDialog = builder.create();
                /*WindowManager.LayoutParams lp = new WindowManager.LayoutParams();
                Window window = progressAlertDialog.getWindow();
                lp.copyFrom(window.getAttributes());
                lp.width = WindowManager.LayoutParams.MATCH_PARENT;
                lp.height = WindowManager.LayoutParams.WRAP_CONTENT;
                window.setAttributes(lp);
                progressAlertDialog.setCancelable(false);
                progressAlertDialog.getWindow().setBackgroundDrawable(new ColorDrawable(android.graphics.Color.TRANSPARENT));*/

//                progressAlertDialog.show();
            }
        }catch (Exception e){
            e.printStackTrace();
        }

    }
    /**
     * Dismiss progress bar
     */
    public void hideProgressDialog() {
        if (!isFinishing())
            if (progressAlertDialog != null && progressAlertDialog.isShowing())
                progressAlertDialog.dismiss();
    }
}