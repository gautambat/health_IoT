
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mobx/mobx.dart';
import 'package:remote_care/constants/constants.dart';
import 'package:remote_care/models/role.dart';
import 'package:remote_care/screens/authentication/otp_verification_screen.dart';
import 'package:remote_care/service/firebase_auth_service.dart';
import 'package:remote_care/utils/store_mixin.dart';
import 'package:remote_care/utils/utils.dart';

part 'signup_login_store.g.dart';

class SignUpLoginStore = SignUpLoginStoreBase with _$SignUpLoginStore;

abstract class SignUpLoginStoreBase with Store, StoreMixin {

  final LocalStorage storage = new LocalStorage('cure_squad');

  BuildContext context;

  SignUpLoginStoreBase();

  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  @observable
  String currentSelectedRole;
@observable
  bool isLoginScreen = false;
  String selectedCountryCode = "+91";
  Function push;
  String mobileNumber = "";

  @observable
  String errorMessage = "";

  @observable
  bool isContactNumberEmpty = false;

  @action
  roleValueChanged(String newValue){
    currentSelectedRole =newValue;
  }

  List<String> roleList =[Constants.PATIENT,Constants.ADMIN];
  @action
  onContinueTapped(Function pushScreen,BuildContext context, adminList) async {
    print(1);
    this.context=context;
    this.push = pushScreen;
    mobileNumber = phoneNumberController.text;
    if (phoneNumberController.text.isEmpty) {
      print(2);
      errorMessage = ErrorMessages.EMPTY_MOBILE;
      return;
    } else if (phoneNumberController.text.length < 10) {
      print(3);
      errorMessage = ErrorMessages.INVALID_MOBILE;
      return;
    }

    else if (!(phoneNumberController.text.toString()[0] == '6' || phoneNumberController.text.toString()[0] == '7' || phoneNumberController.text.toString()[0] == '8' || phoneNumberController.text.toString()[0] == '9')) {
      print(4);
      errorMessage = ErrorMessages.INVALID_MOBILE;
      return;
    }
    else if(currentSelectedRole==null){
      print(5);
      errorMessage = ErrorMessages.ROLE_SELECT_ERROR;
      return;
    }
    else if(currentSelectedRole == Constants.ADMIN) {
      print(6);
      //print(adminList);
      int i, cond = 0;
      for(i = 0; i < adminList.length; i++) {
        //print(adminList[i].mobile);
        if(adminList[i].mobile == '+91'+phoneNumberController.text) {
          cond = 1;
          break;
        }
      }
      if(cond == 0) {
        errorMessage = 'Admin does not exist with this number';
        return;
      }
      else {
        showProgress(context);
        sendOTP(mobileNumber, onCodeSent, onError);
      }
    }
    else if (!isLoginScreen) {
      print(7);
      showProgress(context);
      sendOTP(mobileNumber, onCodeSent, onError);
      /*await UserDao().getUserByMobile(mobileNumber).then((value) {
        if (value.length > 0) {
          hideProgress(context);
          errorMessage = ErrorMessages.MOBILE_EXIST;
        } else {
          //print("user not exist");
          sendOTP(mobileNumber, onCodeSent, onError);
        }
      });*/
    } else {
      print(8);
      if(await Utils.instance.isInternetConnected() ){
      //  if (Constants.IS_DOCTOR) {
        if (Constants.ADMIN==currentSelectedRole || Constants.PATIENT==currentSelectedRole) {
          print(9);
          //doctor login
          var mobileNumberCheck = selectedCountryCode + phoneNumberController.text;
          sendOTP(mobileNumber, onCodeSent, onError);

//          await DoctorDao().getUserDoctorByMobile(mobileNumberCheck).then((value) {
//
//            if (value.length > 0) {
//              hideProgress();
//              sendOTP(mobileNumber, onCodeSent, onError);
//
//            } else {
//              //print("user not exist");
//              hideProgress();
//              errorMessage = ErrorMessages.MOBILE_NOT_EXIST;
//            }
//          });
        }
        else
          {
//            Navigator.push(
//              context,
//              MaterialPageRoute(builder: (context) => AccountScreen()),
//            );
          }
      }
      else{
        showDlg(ErrorMessages.NO_INTERNET_CONNECTION,context);
      }


    }
  }

  sendOTP(mobileNumber, onCodeSent, onError) async {
    showProgress(context);
    mobileNumber = selectedCountryCode + " " + phoneNumberController.text;
    print(mobileNumber);
    await FirebaseAuthService().sendOTP(mobileNumber, onCodeSent, onError);
  }

  onCodeSent(verificationId, forceResendingToken) async {

    await saveRole(currentSelectedRole);
    String role = await getRole();
    //print("role"+role);

Role value=new Role();
value.role=role;


    storage.setItem('roleValue', value.toJSONEncodable());


//Provider<Role>.value(value: value);
    hideProgress(context);
    push(OTPVerificationScreen(
        mobileNumber: mobileNumber, verificationId: verificationId,));
  }

  onError(AuthException error) {
    hideProgress(context);
    print(error.message);
    errorMessage = error.toString();
    switch (error.code) {
      case ErrorMessages.verifyPhoneNumberError:
        showDlg(ErrorMessages.NO_INTERNET_CONNECTION, context);
        errorMessage="";
        break;
      default:
        errorMessage = error.toString();
    }

    //print("typeError"+error.code);
  }
}
