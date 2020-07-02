import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:remote_care/constants/colors.dart';
import 'package:remote_care/constants/strings.dart';
import 'package:remote_care/database/firestore/admin_dao.dart';
import 'package:remote_care/database/firestore/user_dao.dart';
import 'package:remote_care/models/admin.dart';
import 'package:remote_care/models/user.dart';
import 'package:remote_care/screens/authentication/patient_registration_screen.dart';
import 'package:remote_care/screens/authentication/signup_login_screen.dart';
import 'package:remote_care/screens/dashboard/doctor_dash_board_screen.dart';
import 'package:remote_care/utils/utils.dart';
import 'package:remote_care/widgets/default_margin.dart';
import 'package:flutter/cupertino.dart';

import '../dashboard/home_screen.dart';





/// Builds the signed-in or non signed-in UI, depending on the user snapshot.
/// This widget should be below the [MaterialApp].
/// An [AuthWidgetBuilder] ancestor is required for this widget to work.
/// Note: this class used to be called [LandingPage].
class AuthWidget extends StatelessWidget {
  var role;
  String platformAppStoreUrl;
  
  bool isUpdateBoxShown = false;
  AuthWidget({Key key, @required this.userSnapshot}) : super(key: key);
  final AsyncSnapshot<User> userSnapshot;
  LocalStorage storage = new LocalStorage('cure_squad');
  @override
  Widget build(BuildContext context) {
    if (userSnapshot.connectionState == ConnectionState.active) {
      return isRegisteredOrNot(context);
    }
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }


  isRegisteredOrNot(BuildContext context) {
    if (userSnapshot.hasData) {
      role = storage.getItem('roleValue');
      //Role role=Provider.of<Role>(context,listen: false);
      if (role != null && role['role'] == Constants.ADMIN) {
        print(userSnapshot.data.uId);
        return FutureBuilder<Admin>(
          future: AdminDao(uid: userSnapshot.data.uId).getAdmin(),
            // ignore: missing_return
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                print('Waiting');
                return Container(
                    color: AppColors.white,
                    child: Container(
                        width: 50,
                        height: 50,
                        child: Center(child: CircularProgressIndicator())));
              }
              if (snapshot.hasData) {
                Admin admin = snapshot.data;
                print(admin.toJson());
                //log("Dcotor:::::"+userDetails.toJson().toString());
                if (admin != null &&
                    admin.uId != null) {
                  Provider<Admin>.value(value: admin);
                  return DefaultMargin(
                    padding: EdgeInsets.all(0),
                    child: DoctorDashBoardScreen(userDetails: admin),
                  );
                }
              }

            }
        );
        /*return FutureBuilder<Doctor>(
            future: getDoctor(userSnapshot.data.uId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                    color: AppColors.white,
                    child: Container(
                        width: 50,
                        height: 50,
                        child: Center(child: CircularProgressIndicator())));
              }
              if (snapshot.hasData) {
                Doctor userDetails = snapshot.data;
                //log("Dcotor:::::"+userDetails.toJson().toString());
                if (userDetails != null &&
                    userDetails.uId != null &&
                    userDetails.isRegistered) {
                  Provider<Doctor>.value(value: userDetails);
                  return DefaultMargin(
                    padding: EdgeInsets.all(0),
                    child: DoctorDashBoardScreen(userDetails: userDetails),
                  );
                } else {
                  return DoctorRegistration(userSnapshot.data);
                }
              } else {
                return DoctorRegistration(userSnapshot.data);
              }
//              return Container(
//                  color: AppColors.white,
//                  child:Container(width:50,
//                      height:50,child:Center(child:CircularProgressIndicator())));
            });*/
        // doctor login
      } else {
        return FutureBuilder(
            future: getUser(userSnapshot.data.uId), //UserDao().getUserByMobile(userSnapshot.data.mobile),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                    color: AppColors.white,
                    child: Container(
                        width: 50,
                        height: 50,
                        child: Center(child: CircularProgressIndicator())));
              }
              if (snapshot.hasData) {
                User userDetails = snapshot.data;
                /*log("Auth Widget userDetails" +
                    userDetails.toJson().toString());*/
                if (userDetails != null && userDetails.isRegistered) {
                  return HomeScreen(user: userDetails);
                }
              }
              return PatientRegistrationScreen(addPatient: false);
            });
      }
    } else {
      return SignUpLoginScreen();
    }
  }

  /*Future<User> getUserByMobileNumber(mobile) async {
    List<User> userDetails = await UserDao().getUserByMobile(mobile);
    if (userDetails != null && userDetails.isNotEmpty) {
      return await initPatient(userDetails[0]);
    }
    return null;
  }*/
  Future<User> getUser(uId) async {
    User userDetails = await UserDao(uid: uId).getUser();
    if (userDetails != null) {
      return await initPatient(userDetails);
    }
    return null;
  }

  Future<Admin> getAdmin(uId) async {
    Admin admin = await AdminDao(uid: uId).getAdmin();

  }
  /*Future<Doctor> getDoctorByMobileNumber(mobile) async {
    List<Doctor> userDetails = await DoctorDao().getUserDoctorByMobile(mobile);
    if (userDetails != null && userDetails.isNotEmpty) {
      return await initDoctor(userDetails[0]);
    }
    return null;
  }*/

  initPatient(user) async {
    var pushToken = await Utils.instance.getPushToken();
    OtherInfoBean otherInfo = OtherInfoBean();
    otherInfo
      ..pushToken = pushToken;
      //..deviceId = deviceId;
    user.otherInfo = otherInfo;
    //log("User Details:before write "+user.toJson().toString());
    return await UserDao(uid: user.uId).createUser(user).then((value) {
      return UserDao().user(uid: user.uId);
    }).then((value) => value);
  }

}