
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

@immutable
class PulseRecord{
    final String id;
     num pulse;
     Timestamp recordedTime;
     String deviceId;
     String pulseRange;
     String colorCode;
    bool isManual;


    PulseRecord({this.colorCode,this.id,this.pulse, this.recordedTime, this.deviceId,this.pulseRange,this.isManual});

    factory PulseRecord.fromMap(Map data,documentID) {
      data = data ?? { };
      return PulseRecord(
        id:documentID,
        pulse: data['pulse'],
        recordedTime: data['recordedTime'],
        deviceId: data['deviceId']?? '',
        pulseRange: data['pulseRange']?? '',
        colorCode: data['colorCode']?? '',
        isManual: data['isManual']??true,
      );
    }
    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = new Map<String, dynamic>();
      data['id'] = id;
      data['pulse'] = pulse;
      data['recordedTime'] = recordedTime;
      data['deviceId'] = deviceId;
      data['pulseRange'] = pulseRange;
      data['colorCode'] = colorCode;
      data['isManual'] = isManual;
      return data;
    }
    factory PulseRecord.fromSnapShot(DocumentSnapshot snapshot){
      var data = snapshot.data;
      data = data ?? {};
      if (data.isNotEmpty) {
        return PulseRecord(
          id: data['id'],
          pulse: data['pulse'],
          recordedTime: data['recordedTime'],
          deviceId: data['deviceId']?? '',
          pulseRange: data['pulseRange']?? '',
          colorCode: data['colorCode']?? '',
          isManual: data['isManual'],
        );
      }
      return null;
    }

}