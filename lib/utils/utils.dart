

import 'package:connectivity/connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utils{
  Utils._privateConstructor();
  static final Utils _instance = Utils._privateConstructor();

  static Utils get instance => _instance;

  getPushToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('pushToken');
  }

  Future<bool> isInternetConnected() async {

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

   getFirebaseEventsValues({pId,uId,dId,patientName,patientMobile,deviceId,doctorName,doctorMobile,type,value,doctor,user, isTagged,fileName,fileSize,fileType,folderName}){
    Map<String, dynamic> values = new Map();
    if(fileName != null)
      values['fileName'] = fileName;
    if(fileSize != null)
      values['fileSize'] = fileSize;
    if(fileType!=null)
      values['fileType'] = fileType;
    if(folderName!=null)
      values["folderName"] =folderName;
    if(doctor != null)
      values['doctor'] = doctor;
    if(isTagged != null)
      values['isTagged'] = isTagged;
    if(user!=null)
      values['user'] = user;
    if(pId!=null)
      values["pId"] =pId;
    if(uId!=null)
      values["uId"] =uId;
    if(dId!=null)
      values["dId"] =dId;
    if(deviceId!=null)
      values["deviceId"] =deviceId;
    if(patientName!=null)
      values["patientName"] =patientName;
    if(patientMobile!=null)
      values["patientMobile"] =patientMobile;
    if(doctorName!=null)
      values["doctorName"] =doctorName;
    if(doctorMobile!=null)
      values["doctorMobile"] =doctorMobile;
    if(type!=null)
      values["type"] =type;
    if(value!=null)
      values["value"] =value;

    return values;
  }




}