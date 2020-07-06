
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

@immutable
class PulseRecord{
    final String id;
     num pulse;
     //num spo2;
     Timestamp recordedTime;
     String deviceId;
     //String pulseRange;
     //String colorCode;
    bool isManual;


    PulseRecord({this.deviceId,this.id,this.pulse, this.recordedTime,this.isManual});

    factory PulseRecord.fromMap({Map data,documentID}) {
      data = data ?? { };
      return PulseRecord(
        id:documentID,
        pulse: data['pulse'],
        //spo2:data['spo2'],
        recordedTime: data['recordedTime'],
        deviceId: data['deviceId']?? '',
        //pulseRange: data['pulseRange']?? '',
        //colorCode: data['colorCode']?? '',
        isManual: data['isManual']??true,
      );
    }
    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = new Map<String, dynamic>();
      data['id'] = id;
      data['pulse'] = pulse;
      //data['spo2'] = spo2;
      data['recordedTime'] = recordedTime;
      data['deviceId'] = deviceId;
      //data['pulseRange'] = pulseRange;
      //data['colorCode'] = colorCode;
      data['isManual'] = isManual;
      return data;
    }


}