
import 'package:cloud_firestore/cloud_firestore.dart';

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class TempRecord{

     num temp;
     Timestamp recordedTime;
     bool isManual;

    TempRecord({this.temp, this.recordedTime, this.isManual});

    factory TempRecord.fromMap(Map data,documentID) {
      data = data ?? { };
      return TempRecord(
        temp: data['temp'],
        recordedTime: data['recordedTime'],
        isManual: data['isManual']??true,
      );
    }
    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = new Map<String, dynamic>();
      data['recordedTime'] = recordedTime;
      data['temp'] = temp;
      data['isManual'] = isManual;
      return data;
    }





}