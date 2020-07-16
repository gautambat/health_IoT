

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:health_iot/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

mixin StoreMixin{
  showProgress(BuildContext context) {
  hideProgress(context);

    ProgressDialog pr= new ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);

    pr.style(
        padding: EdgeInsets.all(10),
        message: 'Loading...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: Container(
            child: Center(
                child:SizedBox(height:30,width: 30,child:CircularProgressIndicator()))),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        //textDirection: TextDirection.rtl,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600)
    );

     pr.show();

    //EasyLoading.show(status:message);
  }
  showError({message = "Something went wrong..."}){
    //hideProgress();
  }
  hideProgress(BuildContext context){
    ProgressDialog pr= new ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
pr.hide();
  }
  showToast(String message,BuildContext context) {
    Toast.show(message, context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);

  }

  saveRole(role) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('role',role);
  }
  getRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('role');
  }

  saveShowDlg(String s, BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            actions: [
              FlatButton(
                child: Text(PopUpMessages.CLOSE),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              )
            ],
            title: Text(s),
            //content: Text("Dialog Content"),
          );
        }
    );
  }
  showDlg(String s, BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            actions: [
              FlatButton(
                child: Text(PopUpMessages.CLOSE),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
            title: Text(s),
            //content: Text("Dialog Content"),
          );
        }
    );
  }



}