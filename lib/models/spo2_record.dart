
import 'package:cloud_firestore/cloud_firestore.dart';

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class Spo2Record{

     int spo2;
     Timestamp recordedTime;
     bool isManual;

    Spo2Record({this.spo2,this.recordedTime,this.isManual});

    factory Spo2Record.fromMap({Map data,documentID}) {

      data = data ?? { };
      return Spo2Record(
        spo2: data['spo2'],
        recordedTime: data['recordedTime'],
        isManual: data['isManual']??true,
      );
    }
    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = new Map<String, dynamic>();
      data['recordedTime'] = recordedTime;
      data['spo2'] = spo2;
      data['isManual'] = isManual;
      return data;
    }





}