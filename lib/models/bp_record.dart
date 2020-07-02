
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

///BP record  Model
@immutable
class BPRecord{
    final String id;
     int sys;
     Timestamp recordedTime;
     int dia;
     String deviceId;
     String systoticRange;
     String diaRange;
     String colorCodeSys;
     String colorCodeDia;
     bool isManual;

    BPRecord({this.id,this.sys, this.recordedTime, this.dia, this.deviceId,this.systoticRange,this.colorCodeDia,this.colorCodeSys,this.diaRange,this.isManual});

    factory BPRecord.fromMap({Map data,documentID}) {
      data = data ?? { };
      return BPRecord(
        id:documentID,
        sys: data['sys'],
        recordedTime: data['recordedTime'],
        dia: data['dia'],
        deviceId: data['deviceId']?? '',
        systoticRange: data['systoticRange']?? '',
        diaRange: data['diaRange']?? '',
        colorCodeSys: data['colorCodeSys']?? '',
        colorCodeDia: data['colorCodeDia']?? '',
        isManual: data['isManual']??true,
      );
    }
    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = new Map<String, dynamic>();
      data['id'] = id;
      data['recordedTime'] = recordedTime;
      data['dia'] = dia;
      data['sys'] = sys;
      data['deviceId'] = deviceId;
      data['systoticRange'] = systoticRange;
      data['diaRange'] = diaRange;
      data['colorCodeSys'] = colorCodeSys;
      data['colorCodeDia'] = colorCodeDia;
      data['isManual'] = isManual;
      return data;
    }
    factory BPRecord.fromSnapShot(DocumentSnapshot snapshot){
      var data = snapshot.data;
      data = data ?? {};
      if (data.isNotEmpty) {
        return BPRecord(
          id: data['id'],
          sys: data['sys'],
          recordedTime: data['recordedTime'],
          dia: data['dia'],
          deviceId: data['deviceId']?? '',
          systoticRange: data['systoticRange']?? '',
          diaRange: data['diaRange']?? '',
          colorCodeSys: data['colorCodeSys']?? '',
          colorCodeDia: data['colorCodeDia']?? '',
          isManual: data['isManual']??true,
        );
      }
      return null;
    }




}