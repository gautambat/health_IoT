import 'package:cloud_firestore/cloud_firestore.dart';

class Admin{
  String name;
  Timestamp createdOn;
  String imageUrl;
  String mobile;
  String uId;
  bool isApproved;

  Admin({this.name = 'Admin', this.createdOn, this.mobile, this.imageUrl, this.uId, this.isApproved = true});

  factory Admin.fromMap(Map data) {
    data = data ?? {};
    return Admin(
      uId: data['uId'],
      name: data['name'],
      createdOn: data['createdOn'],
      imageUrl: data['imageUrl'],
      mobile: data['mobile'],
      isApproved: data['isApproved']
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uId'] = uId;
    data['name'] = name;
    data['createdOn'] = createdOn;
    data['imageUrl'] = imageUrl;
    data['mobile'] = mobile;
    data['isApproved'] = isApproved;
    return data;
  }
}