
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

///BP record  Model
@immutable
class GlucoseRecord{
    final String id;
     num beforeMeal;
     Timestamp recordedTime;
     num afterMeal;
     String deviceId;
     String beforeMealRange;
     String afterMealRange;
    String colorCodeAfterMeal;
    String colorCodeBeforeMeal;
     bool isManual;

    GlucoseRecord({this.id,this.beforeMeal, this.recordedTime, this.afterMeal, this.deviceId,this.colorCodeBeforeMeal,this.colorCodeAfterMeal,this.beforeMealRange,this.afterMealRange,this.isManual});

    factory GlucoseRecord.fromMap(Map data,documentID) {
      data = data ?? { };
      return GlucoseRecord(
        id:documentID,
        beforeMeal: data['beforeMeal'],
        colorCodeAfterMeal: data['colorCodeAfterMeal']?? '',
        colorCodeBeforeMeal: data['colorCodeBeforeMeal']?? '',
        recordedTime: data['recordedTime'],
        afterMeal: data['afterMeal']?? '',
        deviceId: data['deviceId']?? '',
        beforeMealRange: data['beforeMealRange']?? '',
        afterMealRange: data['afterMealRange']?? '',
        isManual: data['isManual']??true,
      );
    }
    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = new Map<String, dynamic>();
      data['id'] = id;
      data['recordedTime'] = recordedTime;
      data['afterMeal'] = afterMeal;
      data['beforeMeal'] = beforeMeal;
      data['colorCodeAfterMeal'] = colorCodeAfterMeal;
      data['colorCodeBeforeMeal'] = colorCodeBeforeMeal;
      data['deviceId'] = deviceId;
      data['beforeMealRange'] = beforeMealRange;
      data['afterMealRange'] = afterMealRange;
      data['isManual'] = isManual;
      return data;
    }
    factory GlucoseRecord.fromSnapShot(DocumentSnapshot snapshot){
      var data = snapshot.data;
      data = data ?? {};
      if (data.isNotEmpty) {
        return GlucoseRecord(
          id: data['id'],
          beforeMeal: data['beforeMeal'],
          recordedTime: data['recordedTime'],
          afterMeal: data['afterMeal']?? '',
          colorCodeAfterMeal: data['colorCodeAfterMeal']?? '',
          colorCodeBeforeMeal: data['colorCodeBeforeMeal']?? '',
          deviceId: data['deviceId']?? '',
          beforeMealRange: data['systoticRange']?? '',
          afterMealRange: data['afterMealRange']?? '',
          isManual: data['isManual'],
        );
      }
      return null;
    }




}