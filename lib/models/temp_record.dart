
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

@immutable
class TempRecord{
    final String id;
     num temp;
     Timestamp recordedTime;
     String deviceId;
     //String tempRange;
     //String colorCode;
     bool isManual;

    TempRecord({this.id,this.temp, this.recordedTime, this.deviceId,this.isManual});

    factory TempRecord.fromMap(Map data,documentID) {
      data = data ?? { };
      return TempRecord(
        id:documentID,
        temp: data['temp'],
        recordedTime: data['recordedTime'],
        deviceId: data['deviceId']?? '',
        //tempRange: data['tempRange']?? '',
        //colorCode: data['colorCode']?? '',
        isManual: data['isManual']??true,
      );
    }
    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = new Map<String, dynamic>();
      data['id'] = id;
      data['recordedTime'] = recordedTime;
      data['temp'] = temp;
      data['deviceId'] = deviceId;
      //data['tempRange'] = tempRange;
      //data['colorCode'] = colorCode;
      data['isManual'] = isManual;
      return data;
    }





}