import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String pId;
  String uId;
  String firstName;
  String lastName;
  String name;
  String gender;
  String mobile;
  String date;
  Timestamp dob;
  String imageUrl;
  bool isRegistered;
  num weight;
  num height;
  Timestamp createdOn;
  Timestamp updatedOn;
  OtherInfoBean otherInfo;

   factory User.fromMap(Map<String, dynamic> json) {
     if(json==null)
       return null;
    var user=  User(
        pId:json['pId'],
        uId :json['uId'])
     ..name = json['name']
     ..imageUrl = json['imageUrl']
    ..gender = json['gender']
    ..firstName = json['firstName']
    ..lastName = json['lastName']
    ..mobile = json['mobile']
    ..dob = json['dob']
    ..date = json['date']
    ..createdOn = json['createdOn']
    ..updatedOn = json['updatedOn']
    ..isRegistered = json['isRegistered']??false
    ..weight = json['weight']
    ..height = json['height']
    ..otherInfo = json['otherInfo'] != null ? OtherInfoBean.fromJson(json['otherInfo']) : null;

    return user;
  }

  User({this.pId, this.uId, this.name, this.firstName, this.lastName, this.gender, this.mobile, this.dob, this.isRegistered=false, this.weight, this.height, this.otherInfo, this.imageUrl, this.date, this.createdOn, this.updatedOn});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pId'] = this.pId;
    data['uId'] = this.uId;
    data['name'] = this.name;
    data['lastName'] = this.lastName;
    data['firstName'] = this.firstName;
    data['imageUrl'] = this.imageUrl;
    data['gender'] = this.gender;
    data['mobile'] = this.mobile;
    data['dob'] = this.dob;
    data['date'] = this.date;
    data['isRegistered'] = this.isRegistered??false;
    data['weight'] = this.weight;
    data['height'] = this.height;
    data['createdOn'] = this.createdOn;
    data['updatedOn'] = this.updatedOn;
    if (this.otherInfo != null) {
      data['otherInfo'] = this.otherInfo.toJson();
    }
    return data;
  }

}

class OtherInfoBean {
  String facilityId;
  String region;
  String deviceId;
  String pushToken;

  OtherInfoBean({this.facilityId, this.region, this.deviceId, this.pushToken});

  OtherInfoBean.fromJson(Map<String, dynamic> json) {    
    this.facilityId = json['facilityId'];
    this.region = json['region'];
    this.deviceId = json['deviceId'];
    this.pushToken = json['pushToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['facilityId'] = this.facilityId;
    data['region'] = this.region;
    data['deviceId'] = this.deviceId;
    data['pushToken'] = this.pushToken;
    return data;
  }
}
