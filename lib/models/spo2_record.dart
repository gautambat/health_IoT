
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

@immutable
class Spo2Record{
    final String id;
     int spo2;
     int pulse;
     Timestamp recordedTime;
     String deviceId;
     String spo2Range;
     String colorCode;
     bool isManual;

    Spo2Record({this.id,this.spo2, this.pulse,this.recordedTime, this.colorCode,this.deviceId,this.spo2Range,this.isManual});

    factory Spo2Record.fromMap({Map data,documentID}) {

      data = data ?? { };
      //print("SPo2 data:"+data.toString());
      return Spo2Record(
        id:documentID??'',
        spo2: data['spo2'],
        pulse: data['pulse'],
        recordedTime: data['recordedTime'],
        deviceId: data['deviceId']?? '',
        spo2Range: data['spo2Range']?? '',
        colorCode: data['colorCode']?? '',
        isManual: data['isManual']??true,
      );
    }
    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = new Map<String, dynamic>();
      data['id'] = id;
      data['recordedTime'] = recordedTime;
      data['spo2'] = spo2;
      data['pulse'] = pulse;
      data['deviceId'] = deviceId;
      data['spo2Range'] = spo2Range;
      data['colorCode'] = colorCode;
      data['isManual'] = isManual;
      return data;
    }
    factory Spo2Record.fromSnapShot(DocumentSnapshot snapshot){
      var data = snapshot.data;
      data = data ?? {};
      if (data.isNotEmpty) {
        return Spo2Record(
          id: data['id'],
          spo2: data['spo2'],
          pulse: data['pulse'],
          recordedTime: data['recordedTime'],
          deviceId: data['deviceId']?? '',
          spo2Range: data['spo2Range']?? '',
          colorCode: data['colorCode']?? '',
          isManual: data['isManual'],
        );
      }
      return null;
    }




}