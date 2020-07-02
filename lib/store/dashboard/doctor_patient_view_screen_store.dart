import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:jiffy/jiffy.dart';
import 'package:mobx/mobx.dart';
import 'package:remote_care/constants/colors.dart';
import 'package:remote_care/constants/styles.dart';
import 'package:remote_care/models/bp_record.dart';
import 'package:remote_care/models/glucose_record.dart';
import 'package:remote_care/models/pulse_record.dart';
import 'package:remote_care/models/spo2_record.dart';
import 'package:remote_care/models/temp_record.dart';
import 'package:remote_care/models/user.dart';
import 'package:remote_care/screens/dashboard/Readings/patient_readings.dart';
import 'package:remote_care/utils/store_mixin.dart';

part 'doctor_patient_view_screen_store.g.dart';

class DoctorPatientViewScreenStore =  DoctorPatientViewScreenStoreBase with _$DoctorPatientViewScreenStore;

abstract class DoctorPatientViewScreenStoreBase with Store,StoreMixin{

  String differenceInYears="";

  List<BPRecord> bpRecords =new List();
  List<Spo2Record> spo2Records =new List();
  List<PulseRecord> pulseRecords =new List();
  List<TempRecord> tempRecords =new List();
  List<GlucoseRecord> glucoseRecord =new List();

  String secondText="";

  String colorCode2;




  recordImageClicked({@required int clickedValue,bool isHistory=false,Function push,User user}) {

    push(PatientReadingValuesScreen(
      user:user,
      clickedValue:clickedValue,
      bpRecords: bpRecords,
      spo2Records: spo2Records,
      glucoseRecords: glucoseRecord,
      pulseRecords: pulseRecords,
      tempRecords: tempRecords,
      isHistoryScreen: isHistory,
    ));

  }

  dobYears(User patientUser) {

    if(patientUser.dob!=null)
    {
      final DateTime dobTimeStamp = DateTime.fromMillisecondsSinceEpoch(patientUser.dob.millisecondsSinceEpoch);

      //String birthdayString = Jiffy.unix(userRecords[0].dob.millisecondsSinceEpoch).format('dd/MM•HH.mm');
      var presntTime = Timestamp.now();

      final DateTime timeStampNow = DateTime.fromMillisecondsSinceEpoch(presntTime.millisecondsSinceEpoch);

      Duration dur =  timeStampNow.difference(dobTimeStamp);
      differenceInYears = (dur.inDays/365).floor().toString();
      log(differenceInYears+"Date of birth");
    }
  }


  getValuesTemp(List<TempRecord> data, List<Widget> widgets) {

    if(data.length >=3){
      widgets.add(Expanded(flex:2.33.toInt(),child:getValue("temp",data[0].colorCode,data[0].temp.toString()+" \u2109",Jiffy.unix(data[0].recordedTime.millisecondsSinceEpoch).format('dd/MM•HH.mm'))));
      widgets.add(Expanded(flex:2.33.toInt(),child: getValue("temp",data[1].colorCode,data[1].temp.toString()+" \u2109",Jiffy.unix(data[1].recordedTime.millisecondsSinceEpoch).format('dd/MM•HH.mm'))));
      widgets.add( Expanded(flex:2.33.toInt(),child: getValue("temp",data[2].colorCode,data[2].temp.toString()+" \u2109",Jiffy.unix(data[2].recordedTime.millisecondsSinceEpoch).format('dd/MM•HH.mm'))));

    }
    else if(data.length == 2){
      widgets.add(Expanded(flex:2.33.toInt(),child: getValue("temp",data[0].colorCode,data[0].temp.toString()+" \u2109",Jiffy.unix(data[0].recordedTime.millisecondsSinceEpoch).format('dd/MM•HH.mm'))));
      widgets.add(Expanded(flex:2.33.toInt(),child: getValue("temp",data[1].colorCode,data[1].temp.toString()+" \u2109",Jiffy.unix(data[1].recordedTime.millisecondsSinceEpoch).format('dd/MM•HH.mm'))));
      widgets.add(Expanded(flex:2.33.toInt(),child: getValue("","","--","--/--.--.--")));

    }
    else if(data.length == 1){
      widgets.add(Expanded(flex:2.33.toInt(),child: getValue("temp",data[0].colorCode,data[0].temp.toString()+" \u2109",Jiffy.unix(data[0].recordedTime.millisecondsSinceEpoch).format('dd/MM•HH.mm'))));
      widgets.add( Expanded(flex:2.33.toInt(),child: getValue("","","--","--/--.--.--")));
      widgets.add( Expanded(flex:2.33.toInt(),child: getValue("","","--","--/--.--.--")));

    }

    else if(data.length == 0){
      widgets.add(Expanded(flex:2.33.toInt(),child: getValue("","","--","--/--.--.--")));
      widgets.add(Expanded(flex:2.33.toInt(),child: getValue("","","--","--/--.--.--")));
      widgets.add(Expanded(flex:2.33.toInt(),child: getValue("","","--","--/--.--.--")));
    }

  }
  getValuesSpo2(List<Spo2Record> data, List<Widget> widgets) {
    if(data.length >=3){
      widgets.add(Expanded(flex:2.33.toInt(),child:getValue("spo2",data[0].colorCode,data[0].spo2.toString(),Jiffy.unix(data[0].recordedTime.millisecondsSinceEpoch).format('dd/MM•HH.mm'))));
      widgets.add(Expanded(flex:2.33.toInt(),child: getValue("spo2",data[1].colorCode,data[1].spo2.toString(),Jiffy.unix(data[1].recordedTime.millisecondsSinceEpoch).format('dd/MM•HH.mm'))));
      widgets.add( Expanded(flex:2.33.toInt(),child: getValue("spo2",data[2].colorCode,data[2].spo2.toString(),Jiffy.unix(data[2].recordedTime.millisecondsSinceEpoch).format('dd/MM•HH.mm'))));

    }
    else if(data.length == 2){
      widgets.add(Expanded(flex:2.33.toInt(),child: getValue("spo2",data[0].colorCode,data[0].spo2.toString(),Jiffy.unix(data[0].recordedTime.millisecondsSinceEpoch).format('dd/MM•HH.mm'))));
      widgets.add(Expanded(flex:2.33.toInt(),child: getValue("spo2",data[1].colorCode,data[1].spo2.toString(),Jiffy.unix(data[1].recordedTime.millisecondsSinceEpoch).format('dd/MM•HH.mm'))));
      widgets.add(Expanded(flex:2.33.toInt(),child: getValue("","","--","--/--.--.--")));

    }
    else if(data.length == 1){
      widgets.add(Expanded(flex:2.33.toInt(),child: getValue("spo2",data[0].colorCode,data[0].spo2.toString(),Jiffy.unix(data[0].recordedTime.millisecondsSinceEpoch).format('dd/MM•HH.mm'))));
      widgets.add( Expanded(flex:2.33.toInt(),child: getValue("","","--","--/--.--.--")));
      widgets.add( Expanded(flex:2.33.toInt(),child: getValue("","","--","--/--.--.--")));

    }

    else if(data.length == 0){
      widgets.add(Expanded(flex:2.33.toInt(),child: getValue("","","--","--/--.--.--")));
      widgets.add(Expanded(flex:2.33.toInt(),child: getValue("","","--","--/--.--.--")));
      widgets.add(Expanded(flex:2.33.toInt(),child: getValue("","","--","--/--.--.--")));
    }

  }
  getValuesBp(List<BPRecord> data, List<Widget> widgets) {
    if(data.length >=3){
      widgets.add(Expanded(flex:2,child:getValue("bp",data[0].colorCodeSys+"/"+data[0].colorCodeDia,data[0].sys.toString()+"/"+data[0].dia.toString(),Jiffy.unix(data[0].recordedTime.millisecondsSinceEpoch).format('dd/MM•HH.mm'))));
      widgets.add(Expanded(flex:2,child: getValue("bp",data[1].colorCodeSys+"/"+data[1].colorCodeDia ,data[1].sys.toString()+"/"+data[1].dia.toString(),Jiffy.unix(data[1].recordedTime.millisecondsSinceEpoch).format('dd/MM•HH.mm'))));
      widgets.add( Expanded(flex:2,child: getValue("bp",data[2].colorCodeSys+"/"+data[2].colorCodeDia,data[2].sys.toString()+"/"+data[2].dia.toString(),Jiffy.unix(data[2].recordedTime.millisecondsSinceEpoch).format('dd/MM•HH.mm'))));

    }
    else if(data.length == 2){
      widgets.add(Expanded(flex:2,child: getValue("bp",data[0].colorCodeSys+"/"+data[0].colorCodeDia ,data[0].sys.toString()+"/"+data[0].dia.toString(),Jiffy.unix(data[0].recordedTime.millisecondsSinceEpoch).format('dd/MM•HH.mm'))));
      widgets.add(Expanded(flex:2,child: getValue("bp",data[1].colorCodeSys+"/"+data[1].colorCodeDia,data[1].sys.toString()+"/"+data[1].dia.toString(),Jiffy.unix(data[1].recordedTime.millisecondsSinceEpoch).format('dd/MM•HH.mm'))));
      widgets.add(Expanded(flex:2,child: getValue("","","--","--/--.--.--")));

    }
    else if(data.length == 1){
      widgets.add(Expanded(flex:2,child: getValue("bp",data[0].colorCodeSys+"/"+data[0].colorCodeDia,data[0].sys.toString()+"/"+data[0].dia.toString(),Jiffy.unix(data[0].recordedTime.millisecondsSinceEpoch).format('dd/MM•HH.mm'))));
      widgets.add( Expanded(flex:2,child: getValue("","","--","--/--.--.--")));
      widgets.add( Expanded(flex:2,child: getValue("","","--","--/--.--.--")));

    }

    else if(data.length == 0){
      widgets.add(Expanded(flex:2.33.toInt(),child: getValue("","","--","--/--.--.--")));
      widgets.add(Expanded(flex:2.33.toInt(),child: getValue("","","--","--/--.--.--")));
      widgets.add(Expanded(flex:2.33.toInt(),child: getValue("","","--","--/--.--.--")));
    }

  }
  @action
  takeECG(push) async{
    try {
      const platform = const MethodChannel("flutter.native/helper",JSONMethodCodec());
      final String result = await platform.invokeMethod('registerECG');
      //print("received ECG report:"+result);
      //push(new PdfViewerScreen(result));
    }  catch (e) {
//     "Failed to Invoke: '${e.message}'."
    }
  }
  void getValuesGlucose(List<GlucoseRecord> data, List<Widget> widgets) {

    if(data.length >=3){
      widgets.add(Expanded(flex:2.33.toInt(),child:getValue("glucose",data[0].colorCodeBeforeMeal+"/"+data[0].colorCodeAfterMeal,data[0].beforeMeal.toString()+"/"+data[0].afterMeal.toString(),Jiffy.unix(data[0].recordedTime.millisecondsSinceEpoch).format('dd/MM•HH.mm'))));
      widgets.add(Expanded(flex:2.33.toInt(),child:getValue("glucose",data[1].colorCodeBeforeMeal+"/"+data[1].colorCodeAfterMeal,data[1].beforeMeal.toString()+"/"+data[1].afterMeal.toString(),Jiffy.unix(data[1].recordedTime.millisecondsSinceEpoch).format('dd/MM•HH.mm'))));
      widgets.add(Expanded(flex:2.33.toInt(),child:getValue("glucose",data[2].colorCodeBeforeMeal+"/"+data[2].colorCodeAfterMeal,data[2].beforeMeal.toString()+"/"+data[2].afterMeal.toString(),Jiffy.unix(data[2].recordedTime.millisecondsSinceEpoch).format('dd/MM•HH.mm'))));

    }
    else if(data.length == 2){
      widgets.add(Expanded(flex:2.33.toInt(),child:getValue("glucose",data[0].colorCodeBeforeMeal+"/"+data[0].colorCodeAfterMeal,data[0].beforeMeal.toString()+"/"+data[0].afterMeal.toString(),Jiffy.unix(data[0].recordedTime.millisecondsSinceEpoch).format('dd/MM•HH.mm'))));
      widgets.add(Expanded(flex:2.33.toInt(),child:getValue("glucose",data[1].colorCodeBeforeMeal+"/"+data[1].colorCodeAfterMeal,data[1].beforeMeal.toString()+"/"+data[1].afterMeal.toString(),Jiffy.unix(data[1].recordedTime.millisecondsSinceEpoch).format('dd/MM•HH.mm'))));
      widgets.add(Expanded(flex:2.33.toInt(),child: getValue("","","--","--/--.--.--")));

    }
    else if(data.length == 1){
      widgets.add(Expanded(flex:2.33.toInt(),child:getValue("glucose",data[0].colorCodeBeforeMeal+"/"+data[0].colorCodeAfterMeal  ,data[0].beforeMeal.toString()+"/"+data[0].afterMeal.toString(),Jiffy.unix(data[0].recordedTime.millisecondsSinceEpoch).format('dd/MM•HH.mm'))));
      widgets.add( Expanded(flex:2.33.toInt(),child: getValue("","","--","--/--.--.--")));
      widgets.add( Expanded(flex:2.33.toInt(),child: getValue("","","--","--/--.--.--")));

    }

    else if(data.length == 0){
      widgets.add(Expanded(flex:2.33.toInt(),child: getValue("","","--","--/--.--.--")));
      widgets.add(Expanded(flex:2.33.toInt(),child: getValue("","","--","--/--.--.--")));
      widgets.add(Expanded(flex:2.33.toInt(),child: getValue("","","--","--/--.--.--")));
    }

  }
  void getValuesPulse(List<PulseRecord> data, List<Widget> widgets) {

    if(data.length >=3){
      widgets.add(Expanded(flex:2.33.toInt(),child:getValue("pulse",data[0].colorCode,data[0].pulse.toString(),Jiffy.unix(data[0].recordedTime.millisecondsSinceEpoch).format('dd/MM•HH.mm'))));
      widgets.add(Expanded(flex:2.33.toInt(),child: getValue("pulse",data[1].colorCode,data[1].pulse.toString(),Jiffy.unix(data[1].recordedTime.millisecondsSinceEpoch).format('dd/MM•HH.mm'))));
      widgets.add( Expanded(flex:2.33.toInt(),child: getValue("pulse",data[2].colorCode,data[2].pulse.toString(),Jiffy.unix(data[2].recordedTime.millisecondsSinceEpoch).format('dd/MM•HH.mm'))));

    }
    else if(data.length == 2){
      widgets.add(Expanded(flex:2.33.toInt(),child: getValue("pulse",data[0].colorCode,data[0].pulse.toString(),Jiffy.unix(data[0].recordedTime.millisecondsSinceEpoch).format('dd/MM•HH.mm'))));
      widgets.add(Expanded(flex:2.33.toInt(),child: getValue("pulse",data[1].colorCode,data[1].pulse.toString(),Jiffy.unix(data[1].recordedTime.millisecondsSinceEpoch).format('dd/MM•HH.mm'))));
      widgets.add(Expanded(flex:2.33.toInt(),child: getValue("","","--","--/--.--.--")));

    }
    else if(data.length == 1){
      widgets.add(Expanded(flex:2.33.toInt(),child: getValue("pulse",data[0].colorCode,data[0].pulse.toString(),Jiffy.unix(data[0].recordedTime.millisecondsSinceEpoch).format('dd/MM•HH.mm'))));
      widgets.add( Expanded(flex:2.33.toInt(),child: getValue("","","--","--/--.--.--")));
      widgets.add( Expanded(flex:2.33.toInt(),child: getValue("","","--","--/--.--.--")));

    }

    else if(data.length == 0){
      widgets.add(Expanded(flex:2.33.toInt(),child: getValue("","","--","--/--.--.--")));
      widgets.add(Expanded(flex:2.33.toInt(),child: getValue("","","--","--/--.--.--")));
      widgets.add(Expanded(flex:2.33.toInt(),child: getValue("","","--","--/--.--.--")));
    }

  }

  getValue(from,colorCode,value,date){
    if(from =="bp"|| from =="glucose"){
      var value1 = value.split("/");
      var firstText ="";
      secondText ="";
      if(value1.length>0){
        firstText = value1[0];
        secondText = value1[1];
        value =firstText;
      }

      var riskValue = colorCode.split("/");
      var riskFirst ="";
      colorCode2 ="";
      if(riskValue.length>0){
        riskFirst = riskValue[0];
        colorCode2 = riskValue[1];
        colorCode = riskFirst;
      }

    }
    return  Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              fit: FlexFit.loose,
              child: Text(
                value,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color:(colorCode!=null && colorCode!="")? Color(int.parse(colorCode)):AppColors.secondaryText,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  height: 1.428571,),
              ),
            ),
            Visibility(
                visible: (from=="bp"|| from=="glucose"),
                child:Flexible(
                  fit: FlexFit.loose,
                  child: Text(
                    "/"+secondText,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color:(colorCode2!=null && colorCode2!="")? Color(int.parse(colorCode2)):AppColors.secondaryText,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      height: 1.428571,),
                  ),
                )),
          ],) ,
        Flexible(
          fit: FlexFit.loose,
          child: Text(
            date,
//                "25/03•12.30",
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color:(colorCode!=null && colorCode!="")? Color(int.parse(colorCode)):AppColors.secondaryText,
              fontWeight: FontWeight.w600,
              fontSize: 12,
              height: 1.428571,),
          ),

        )
      ],);


  }

}