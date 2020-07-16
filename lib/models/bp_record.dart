
import 'package:cloud_firestore/cloud_firestore.dart';

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class BPRecord{
     int sys;
     Timestamp recordedTime;
     int dia;
     bool isManual;

    BPRecord({this.sys, this.recordedTime, this.dia, this.isManual});

    factory BPRecord.fromMap({Map data,documentID}) {
      data = data ?? { };
      return BPRecord(
        sys: data['sys'],
        recordedTime: data['recordedTime'],
        dia: data['dia'],
        isManual: data['isManual']??true,
      );
    }
    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = new Map<String, dynamic>();
      data['recordedTime'] = recordedTime;
      data['dia'] = dia;
      data['sys'] = sys;
      data['isManual'] = isManual;
      return data;
    }


}