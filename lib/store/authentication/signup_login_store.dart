
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mobx/mobx.dart';
import 'package:health_iot/constants/constants.dart';
import 'package:health_iot/models/role.dart';
import 'package:health_iot/screens/authentication/otp_verification_screen.dart';
import 'package:health_iot/service/firebase_auth_service.dart';
import 'package:health_iot/utils/store_mixin.dart';
import 'package:health_iot/utils/utils.dart';

part 'signup_login_store.g.dart';

class SignUpLoginStore = SignUpLoginStoreBase with _$SignUpLoginStore;

abstract class SignUpLoginStoreBase with Store, StoreMixin {

  final LocalStorage storage = new LocalStorage('health_iot');

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

      int i, cond = 0;
      for(i = 0; i < adminList.length; i++) {

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

      showProgress(context);
      sendOTP(mobileNumber, onCodeSent, onError);

    } else {

      if(await Utils.instance.isInternetConnected() ){

        if (Constants.ADMIN==currentSelectedRole || Constants.PATIENT==currentSelectedRole) {
          sendOTP(mobileNumber, onCodeSent, onError);


        }
        else
          {

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
