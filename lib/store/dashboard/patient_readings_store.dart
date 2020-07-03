import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobx/mobx.dart';
import 'package:remote_care/constants/strings.dart';
import 'package:remote_care/database/firestore/record_dao.dart';
import 'package:remote_care/database/firestore/user_dao.dart';
import 'package:remote_care/models/bp_record.dart';
import 'package:remote_care/models/pulse_record.dart';
import 'package:remote_care/models/spo2_record.dart';
import 'package:remote_care/models/temp_record.dart';
import 'package:remote_care/models/user.dart';
import 'package:remote_care/utils/store_mixin.dart';
import 'package:remote_care/utils/utils.dart';

part 'patient_readings_store.g.dart';

class PatientReadingsStore =  PatientReadingsStoreBase with _$PatientReadingsStore;



abstract class PatientReadingsStoreBase with Store, StoreMixin {
  String type ="";

  @observable
  bool fromPulseReading = false;

  PatientReadingsStoreBase();

  static const platform = const MethodChannel("flutter.native/helper",JSONMethodCodec());

  Constants constant = new Constants();

  @observable
  String deviceId;
  @observable
  User user;
  @observable
  TextEditingController bpController = new TextEditingController();
  @observable
  TextEditingController bpDiaController = new TextEditingController();
  @observable
  TextEditingController spo2Controller = new TextEditingController();
  @observable
  TextEditingController glucoseController = new TextEditingController();
  @observable
  TextEditingController glucoseAfterMealControllr = new TextEditingController();
  @observable
  TextEditingController tempController = new TextEditingController();
  @observable
  bool emptyBp = false;
  @observable
  bool empty1Bp = false;
  @observable
  bool emptySpo2 = false;
  @observable
  bool emptyTemp = false;
  @observable
  bool emptyGlucose = false;
  @observable
  bool emptyAfterGlucose = false;
  @observable
  bool notEmptyPulse = false;
  @observable
  bool notEmptyFromDevicePulse = false;
  @observable
  var pulseController = new TextEditingController();
  var pulseFromDeviceController = new TextEditingController();

  @observable
  bool isHistoryScreen =false;





  /*readingValues() async {
    pulseReadingValues = await ListsDao().pulseReadingValues();
    spo2ReadingValues = await ListsDao().spo2ReadingValues();
    tempReadingValues = await ListsDao().tempReadingValues();
    weightReadingValues = await ListsDao().weightReadingValues();
    bpDiaReadingValues = await ListsDao().bpDiaReadingValues();
    bpSysReadingValues = await ListsDao().bpSysReadingValues();
    glucoseAfterMealReadingValues = await ListsDao().glucoseAfterMealReadingValues();
    glucoseBeforeMealReadingValues = await ListsDao().glucoseBeforeMealReadingValues();
  }*/


  @action
  setUser(user){
    /*Utils.instance.getDeviceId().then((value){
      deviceId = value;
    });*/
    this.user =  user;
    //print(user.toString());
  }

  @action
  onPulseChanged() {
    if (pulseController.text.isNotEmpty)
      notEmptyPulse = true;
    else
      notEmptyPulse = false;
  }

  @action
  onPulseFromDeviceChanged() {
    if (pulseFromDeviceController.text.isNotEmpty)
      notEmptyFromDevicePulse = true;
    else
      notEmptyFromDevicePulse = false;
  }

  @action
  onBpChanged() {
    if (bpController.text.isNotEmpty) {
      if (bpDiaController.text.isNotEmpty) {
        emptyBp = true;
        empty1Bp = true;
      }
      else {
        emptyBp = true;
        empty1Bp = false;
      }
    }
    else {
      emptyBp = false;
      empty1Bp = false;
    }
  }
@action
spo2Changed() {
  if (spo2Controller.text.isNotEmpty) {
    emptySpo2 = true;
  }
  else {
    emptySpo2 = false;
  }
  }
  @action
  tempChanged(){
    if (tempController.text.isNotEmpty) {
      emptyTemp = true;
    }
    else
      emptyTemp = false;
  }
  @action
  glucoseChanged() {

    if (glucoseController.text.isNotEmpty) {
      if (glucoseAfterMealControllr.text.isNotEmpty) {
        emptyGlucose = true;
        emptyAfterGlucose = true;
      }
      else {
        emptyGlucose = true;
        emptyAfterGlucose = false;
      }
    }
    else {
      emptyGlucose = false;
      emptyAfterGlucose = false;
    }


  }

  @action
  Future<void> pulseClicked(String uid, BuildContext context) async {
    /*String userId;
    if (uid != null) {
      userId = uid;
    }
    else {
      User user = Provider.of<User>(context, listen: false);
      userId = user.uid;
    }*/
    int pulseValue = int.parse(pulseController.text);
    notEmptyPulse = false;


    pulseSaved(pulseValue,pulseController.text,context,false);




  }
  //Alert related logic
//  alertDoctor(alertValue) async{
//    //var doctorUid = user.linkedDoctors[0];
//    Map<String,dynamic> alertDetails = Map();
//    alertDetails["isAlerted"] = true;
//    alertDetails["alertedValue"] = alertValue;
//    alertDetails["id"] = user.pId;
//    alertDetails["uId"] = user.uId;
//    alertDetails["linkedDoctors"] = user.linkedDoctors;
//
//    await UserDao(uid: user.uId).createAlert(alertDetails);
////    for(var doctorUid in user.linkedDoctors){
////      await  DoctorDao(uid: doctorUid).getPatient(user.pId).then((value) {
////        value.isAlerted = true;
////        value.alertedValue = alertValue;
////        value.id = user.pId;
////        DoctorDao(uid: doctorUid).createPatientUser(value).then((value) {
////          //print("Alerted Record inserted in doctor");
////        } );
////      });
////    }
//  }
//  //check if the value  range is high
//  isInAlertRange(range){
//    return range =="alert"||range =="high";
//  }

  @action
  Future<void> bpSaveClicked(String uid, BuildContext context) async {
    String userId= user.uId;
//    if (uid != null) {
//      userId = uid;
//    }
//    else {
//      User user = Provider.of<User>(context, listen: false);
//      userId = user.uid;
//    }
    emptyBp = false;
    empty1Bp = false;

    int bpValue = int.parse(bpController.text);




      int bpDiaValue = int.parse(bpDiaController.text);



        BPRecord bpRecord = new BPRecord();


        bpRecord.sys = num.parse(bpController.text);
        bpRecord.dia = num.parse(bpDiaController.text);
        bpRecord.isManual = true;
        bpRecord.deviceId = deviceId;
        bpRecord.recordedTime = Timestamp.now();
        await RecordDao(uid: userId).addBPRecord(bpRecord).then((value) {
          saveShowDlg(ErrorMessages.BP_DETAILS_SAVED, context);
          //showToast(message: "Bp Details Saved");

          bpController.text = "";
          bpDiaController.text = "";

        });





  }
  @action
  Future<void> spo2Clicked(String uid, BuildContext context) async {
    String userId= user.uId;
//    if (uid != null) {
//      userId = uid;
//    }
//    else {
//      User user = Provider.of<User>(context, listen: false);
//      userId = user.uid;
//    }
    emptySpo2 = false;
    int spo2Value = int.parse(spo2Controller.text);




      Spo2Record spo2Record = new Spo2Record();


      spo2Record.spo2 = num.parse(spo2Controller.text);
      spo2Record.recordedTime = Timestamp.now();
      spo2Record.isManual = true;
      spo2Record.deviceId = deviceId;
      await RecordDao(uid: userId).addSpo2Record(spo2Record).then((value) {
        spo2Controller.text="";


        if(fromPulseReading && notEmptyFromDevicePulse){

          int pulseValue = int.parse(pulseFromDeviceController.text);
          notEmptyFromDevicePulse = false;
          fromPulseReading = false;

          pulseSaved(pulseValue,pulseFromDeviceController.text,context,true);
        }
        else{
          saveShowDlg(ErrorMessages.SPO2_DETAILS_SAVED, context);


        }


      });



  }
  @action
  Future<void> tempClicked(String uid, BuildContext context) async {
    String userId= user.uId;
//    if (uid != null) {
//      userId = uid;
//    }
//    else {
//      User user = Provider.of<User>(context, listen: false);
//      userId = user.uid;
//    }
    emptyTemp = false;


    double tempDoubleValue = double.parse(tempController.text);
    int tempValue = tempDoubleValue.toInt();


      TempRecord tempRecord = new TempRecord();

      tempRecord.isManual = true;
      tempRecord.deviceId = deviceId;
      tempRecord.temp = num.parse(tempController.text);
      tempRecord.recordedTime = Timestamp.now();
      await RecordDao(uid: userId).addTempRecord(tempRecord).then((Value) {
        saveShowDlg(ErrorMessages.TEMP_DETAILS_SAVED, context);


        // showToast(message: "Temparature Details Saved");

        tempController.text = "";
      });





  }


@action
Future<void> deviceValuesReading(int selectedTab) async {
    String response = "";
    if (selectedTab ==0) {
      try {
        final String result = await platform.invokeMethod('fromPulse');
        /*if(result!=null) {
          var parsedJson = json.decode(result.toString());

          //print("result"+result);
          var spo2record = Spo2Record.fromMap(data: parsedJson);
          spo2Controller.text = spo2record.spo2.toString();
          String pulse = spo2record.pulse.toString();
          if(pulse!=null){
            fromPulseReading = true;
            notEmptyFromDevicePulse = true;
            pulseFromDeviceController.text = spo2record.pulse.toString();
            onPulseFromDeviceChanged();
          }
          if(spo2Controller.text.isNotEmpty)
            spo2Changed();

        }*/
      }  catch (e) {
        response = "Failed to Invoke: '${e.message}'.";
      }
    }
    else if (selectedTab == 1) {
      try {
        final String result = await platform.invokeMethod('fromBP');
        response = result;

      }  catch (e) {
        response = "Failed to Invoke: '${e.message}'.";
      }
    }
    else if (selectedTab ==2) {
      try {
        var result = await platform.invokeMethod('fromSp');
        if(result!=null) {
          var parsedJson = json.decode(result.toString());

          //print("result"+result);
          var spo2record = Spo2Record.fromMap(data: parsedJson);
            spo2Controller.text = spo2record.spo2.toString();
            String pulse = spo2record.pulse.toString();
            if(pulse!=null){
              fromPulseReading = true;
              notEmptyFromDevicePulse = true;
              pulseFromDeviceController.text = spo2record.pulse.toString();
             onPulseFromDeviceChanged();
            }
          if(spo2Controller.text.isNotEmpty)
            spo2Changed();

        }
      }  catch (e) {
        response = "Failed to Invoke: '${e.message}'.";
      }
    }
    else if (selectedTab ==3) {
      try {
        final String result = await platform.invokeMethod('fromGlucose');
        response = result;

//        glucoseController.text = response;
      }  catch (e) {
        response = "Failed to Invoke: '${e.message}'.";
      }
    }
    else  {
      try {
        final String result = await platform.invokeMethod('fromTemp');
        response = result;

//        tempController.text = response;
      }  catch (e) {
        response = "";
      }
    }


  }





   typeValues(int clickedValue) {
    if(clickedValue ==Constants.BP)
      type = TabTitle.BP;
    else if(clickedValue ==Constants.PULSE)
      type = TabTitle.PULSE;
    else if(clickedValue ==Constants.TEMP)
      type = TabTitle.TEMP;
    else if(clickedValue ==Constants.SPO2)
      type = TabTitle.SPO2;
  }

  Future<void> pulseSaved(int pulseValue, text, BuildContext context, bool fromDevicePulse) async {

      PulseRecord pulseRecord = new PulseRecord();

      pulseRecord.pulse = num.parse(text);
      pulseRecord.recordedTime = Timestamp.now();
      //pulseRecord.pulseRange = rangeValue;
      pulseRecord.deviceId = deviceId;

      if(!fromPulseReading)
      pulseRecord.isManual = true;
      else
        pulseRecord.isManual = false;
      await RecordDao(uid: user.uId).addPulseRecord(pulseRecord).then((value) {

       if(!fromDevicePulse)
        {
          pulseController.text="";
          saveShowDlg(ErrorMessages.PULSE_DETAILS_SAVED, context);
        }
       else
{
  pulseFromDeviceController.text="";
  saveShowDlg(ErrorMessages.PULSE_SPO2_DETAILS_SAVED, context);

}
        text = "";

        //showToast(message: "Pulse Details Saved");
      });



  }



}
