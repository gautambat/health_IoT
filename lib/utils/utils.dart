

import 'package:connectivity/connectivity.dart';

class Utils{
  Utils._privateConstructor();
  static final Utils _instance = Utils._privateConstructor();

  static Utils get instance => _instance;


  Future<bool> isInternetConnected() async {

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }





}