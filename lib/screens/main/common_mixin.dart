import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:remote_care/constants/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:file/file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file/local.dart';
import 'dart:io' as io;
import 'package:http/http.dart' as http;

////CommonMixin
/// @author Yakub.
///
///  Mixin which shares the common functionality with the BaseState
///  Few of its includes Toast, and Route Navigation,Logger and Firebase logging
mixin CommonMixin {

  BuildContext getContext();

  ///logs a [message] on the Log console
  log(message){
    Logger("RemoteCare").log(Level.INFO, message);
  }

  /// displays a toast with [message] provided with default [duration] short and [gravity] bottom.
  showToast({@required message, duration: 1,gravity: 0}) => Toast.show(
      message, getContext(), duration: duration,
      gravity: gravity);

  showDlg({String message, BuildContext context}) {
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
            title: Text(message),
            //content: Text("Dialog Content"),
          );
        }
    );
  }

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

  /// Return the MaterialPageRoute Object with Screen Name set with the default Settings.
  MaterialPageRoute buildMaterialPageRoute({@required screen,settings})=> MaterialPageRoute(
      maintainState: true,
      settings: RouteSettings(name:getScreenName(screen)),
      builder: (context) => screen);

  /// push the screen to navigation stack using navigator to the desired [screen]
  void push(screen)=>
      Navigator.push(
          getContext(),
          buildMaterialPageRoute(screen: screen));

///Replace the existing screen on the navigation stack with [screen]
  void pushReplacement(screen)=>
      Navigator.pushReplacement(
          getContext(),
          buildMaterialPageRoute(screen: screen));

  /// Clear the navigation stack til [screen]
  void pushAndRemoveUntil(screen)=>
      Navigator.pushAndRemoveUntil(
          getContext(),
          buildMaterialPageRoute(screen: screen),(Route<dynamic> route) => false);

  ///Remove the latest screen in the navigation stack
  void pop(){
    Navigator.of(getContext()).pop();
  }

  /// Gets the screen name of [screen]
  @protected
  String getScreenName(screen){
    return screen.runtimeType.toString();

  }
  getPushToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('pushToken');
  }
  savePushToken(token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('pushToken',token);
  }
  getRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('role');
  }
  setDeviceId(deviceId) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('deviceId',deviceId);
  }
  hideKeyboard() {
    FocusScope.of(getContext()).unfocus();
  }

  //String _filePath;


}