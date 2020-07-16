
import 'package:cloud_firestore/cloud_firestore.dart';

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class PulseRecord{
     num pulse;
     Timestamp recordedTime;
     bool isManual;


    PulseRecord({this.pulse, this.recordedTime,this.isManual});

    factory PulseRecord.fromMap({Map data,documentID}) {
      data = data ?? { };
      return PulseRecord(
        pulse: data['pulse'],
        recordedTime: data['recordedTime'],
        isManual: data['isManual']??true,
      );
    }
    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = new Map<String, dynamic>();
      data['pulse'] = pulse;
      data['recordedTime'] = recordedTime;
      data['isManual'] = isManual;
      return data;
    }


}