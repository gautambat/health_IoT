import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobx/mobx.dart';
import 'package:health_iot/constants/constants.dart';
import 'package:health_iot/database/firestore/record_dao.dart';
import 'package:health_iot/models/bp_record.dart';
import 'package:health_iot/models/pulse_record.dart';
import 'package:health_iot/models/spo2_record.dart';
import 'package:health_iot/models/temp_record.dart';
import 'package:health_iot/models/user.dart';
import 'package:health_iot/utils/store_mixin.dart';

part 'patient_readings_store.g.dart';

class PatientReadingsStore =  PatientReadingsStoreBase with _$PatientReadingsStore;



abstract class PatientReadingsStoreBase with Store, StoreMixin {
  String type ="";

  @observable
  bool fromPulseReading = false;
  @observable
  bool fromSpo2Reading = false;

  PatientReadingsStoreBase();

  static const platform = const MethodChannel("flutter.native/helper",JSONMethodCodec());

  Constants constant = new Constants();

  @observable
  bool manual;
  @observable
  User user;
  @observable
  TextEditingController bpController = new TextEditingController();
  @observable
  TextEditingController bpDiaController = new TextEditingController();
  @observable
  TextEditingController spo2Controller = new TextEditingController();
  //TextEditingController spo2FromDeviceController = new TextEditingController();
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
  bool notEmptyPulse = false;
  @observable
  bool notEmptyFromDevicePulse = false;
  @observable
  bool notEmptyFromDeviceSpo2 = false;
  @observable
  var pulseController = new TextEditingController();
  //var pulseFromDeviceController = new TextEditingController();

  @action
  setUser(user){
    /*Utils.instance.getDeviceId().then((value){
      deviceId = value;
    });*/
    this.user =  user;
    //print(user.toString());
  }

  @action
  onPulseChanged(bool isManual) {
    if (pulseController.text.isNotEmpty) {
      notEmptyPulse = true;
      manual = isManual;
    }


    else
      notEmptyPulse = false;
  }

  /*@action
  onPulseFromDeviceChanged() {
    if (pulseFromDeviceController.text.isNotEmpty)
      notEmptyFromDevicePulse = true;
    else
      notEmptyFromDevicePulse = false;
  }

  @action
  onSpo2FromDeviceChanged() {
    if (spo2FromDeviceController.text.isNotEmpty)
      notEmptyFromDeviceSpo2 = true;
    else
      notEmptyFromDeviceSpo2 = false;
  }*/

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
spo2Changed(bool isManual) {
  if (spo2Controller.text.isNotEmpty) {
    emptySpo2 = true;
    manual = isManual;
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
  Future<void> pulseClicked(String uid, BuildContext context) async {

    int pulseValue = int.parse(pulseController.text);
    notEmptyPulse = false;


    pulseSaved(pulseValue,pulseController.text,context,manual);




  }

  @action
  Future<void> bpSaveClicked(String uid, BuildContext context) async {
    String userId= user.uId;

    emptyBp = false;
    empty1Bp = false;





        BPRecord bpRecord = new BPRecord();


        bpRecord.sys = num.parse(bpController.text);
        bpRecord.dia = num.parse(bpDiaController.text);
        bpRecord.isManual = true;
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

    emptySpo2 = false;





      Spo2Record spo2Record = new Spo2Record();


      spo2Record.spo2 = num.parse(spo2Controller.text);
      spo2Record.recordedTime = Timestamp.now();
      spo2Record.isManual = manual;
      await RecordDao(uid: userId).addSpo2Record(spo2Record).then((value) {
        spo2Controller.text="";
        saveShowDlg(ErrorMessages.SPO2_DETAILS_SAVED, context);


        /*if(fromPulseReading && notEmptyFromDevicePulse){

          int pulseValue = int.parse(pulseFromDeviceController.text);
          notEmptyFromDevicePulse = false;
          fromPulseReading = false;

          pulseSaved(pulseValue,pulseFromDeviceController.text,context,true);
        }
        else{
          saveShowDlg(ErrorMessages.SPO2_DETAILS_SAVED, context);


        }*/


      });



  }
  @action
  Future<void> tempClicked(String uid, BuildContext context) async {
    String userId= user.uId;
    emptyTemp = false;






      TempRecord tempRecord = new TempRecord();

      tempRecord.isManual = true;
      tempRecord.temp = num.parse(tempController.text);
      tempRecord.recordedTime = Timestamp.now();
      await RecordDao(uid: userId).addTempRecord(tempRecord).then((value) {
        saveShowDlg(ErrorMessages.TEMP_DETAILS_SAVED, context);


        // showToast(message: "Temparature Details Saved");

        tempController.text = "";
      });





  }


@action
Future<void> deviceValuesReading(int selectedTab, BuildContext context) async {
    if (selectedTab == 0) {
      //BP
      /*try {
        final String result = await platform.invokeMethod('fromBP');
        response = result;

      }  catch (e) {
        response = "Failed to Invoke: '${e.message}'.";
      }*/
      showDlg('Currently implemented only for Pulse and SPO2', context);
    }
    else if (selectedTab == 1) {
      try {
        var result = await platform.invokeMethod('fromSp');
        if(result!=null) {
          var parsedJson = json.decode(result.toString());

          //print("result"+result);
          var spo2record = Spo2Record.fromMap(data: parsedJson);
            spo2Controller.text = spo2record.spo2.toString();

          if(spo2Controller.text.isNotEmpty)
            spo2Changed(false);

        }
      }  catch (e) {
      }
    }
    else if (selectedTab ==2) {
      //Temp
      /*try {
        final String result = await platform.invokeMethod('fromTemp');
        response = result;

//        tempController.text = response;
      }  catch (e) {
        response = "";
      }*/
      showDlg('Currently implemented only for Pulse and SPO2', context);
    }
    else  {
      try {
        final String result = await platform.invokeMethod('fromSp');
        if(result!=null) {
          var parsedJson = json.decode(result.toString());

          //print("result"+result);
          var pulserecord = PulseRecord.fromMap(data: parsedJson);
          pulseController.text = pulserecord.pulse.toString();
          if(pulseController.text.isNotEmpty)
            onPulseChanged(false);

        }
      }  catch (e) {
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

  Future<void> pulseSaved(int pulseValue, text, BuildContext context, bool manual) async {

      PulseRecord pulseRecord = new PulseRecord();

      pulseRecord.pulse = num.parse(text);
      pulseRecord.recordedTime = Timestamp.now();
      pulseRecord.isManual = manual;

      await RecordDao(uid: user.uId).addPulseRecord(pulseRecord).then((value) {
        pulseController.text="";
        saveShowDlg(ErrorMessages.PULSE_DETAILS_SAVED, context);

        text = "";

        //showToast(message: "Pulse Details Saved");
      });



  }



}
