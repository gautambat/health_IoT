import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobx/mobx.dart';
import 'package:remote_care/constants/constants.dart';
import 'package:remote_care/service/firebase_auth_service.dart';
import 'package:remote_care/utils/store_mixin.dart';
import 'package:remote_care/utils/utils.dart';

part 'otp_verification_store.g.dart';

class OTPVerificationStore =  OTPVerificationStoreBase with _$OTPVerificationStore;

abstract class OTPVerificationStoreBase with Store,StoreMixin{
  var verificationCode;

  BuildContext resendContext;

  var context;

  OTPVerificationStoreBase();

  @observable
  String errorMessage="";
  String userMobileNumber="";
  String selectedCountryCode = "+91";

  Function push;
  @action
  verifyOTP(context,pushScreen,smsCode,verificationId,mobileNumber,name) async{
    this.context=context;
    userMobileNumber =mobileNumber;
    push = pushScreen;
    if(smsCode?.isEmpty??true){
      errorMessage = ErrorMessages.ENTER_OTP;
      return;
    }else{
      if(await Utils.instance.isInternetConnected() ){
        showProgress(context);
        //onError(ErrorMessages.INVALID_OTP);
        await FirebaseAuthService().verifyOTP(smsCode, verificationId, onSuccess, onError);
      }
      else{
        showDlg(ErrorMessages.NO_INTERNET_CONNECTION, context);
      }


    }

  }

  void onSuccess() async{
   // User user = Provider.of<User>(context,listen: false);



//dialog();


//    User user = new User();
//    user.mobile= userMobileNumber;

    //await UserDao(uid: "NIVVQ0a8y1h4oFIJB3ui9JOx9cm1").createUser(user).then((value){
//    await UserDao(uid: user.uid).createUser(user).then((value){
//      hideProgress();
//      push(HomeScreen());
//
//    });

    //    hideProgress();

//   await UserDao().getUserByMobile(userMobileNumber).then((value) async {
//      if(value.length>0){
//        value[0].isRegister =true;
//        value[0].mobile = userMobileNumber;
//        hideProgress();
//        push(HomeScreen());
//      }else{
//        //print("user not exist");
//        await UserDao(uid: user.uid).createUser(user).then((value){
//          hideProgress();
//            push(HomeScreen());
//
//        });
//     }
  //  });



//
    ////print("onSuccess");

  }
  void onError(PlatformException error){
    hideProgress(context);

    switch (error.code) {
      case ErrorMessages.ERROR_INVALID_VERIFICATION_CODE:
        errorMessage = ErrorMessages.INVALID_OTP;
        break;
        case ErrorMessages.ERROR_SESSION_EXPIRED:
        errorMessage = ErrorMessages.OTP_SESSION_EXPIRED;
        break;
        case ErrorMessages.ERROR_NETWORK_REQUEST_FAILED:
        //errorMessage = ErrorMessages.OTP_NETWORKFAILED;
        showDlg(ErrorMessages.NO_INTERNET_CONNECTION, context);
        errorMessage="";
        break;
      default:
        errorMessage = error.toString();
    }

    //print("typeError"+error.code);
  }

  void shoDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            actions: [
              FlatButton(
                child: Text(PopUpMessages.CLOSE),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
            title: Text("OTP sent successfully"),
            //content: Text("Dialog Content"),
          );
        }
    );
  }

  @action
  resendOTP(String mobileNumber,BuildContext context){
    this.resendContext= context;
    sendOTP(mobileNumber, onCodeSent, onErrorResend);
  }

  sendOTP(mobileNumber, onCodeSent, onErrorResend) async {
    showProgress(context);
    mobileNumber = selectedCountryCode + " " + mobileNumber;
    await FirebaseAuthService().sendOTP(mobileNumber, onCodeSent, onErrorResend);
  }

    onErrorResend(AuthException error) {
      hideProgress(context);
      switch (error.code) {
        case ErrorMessages.verifyPhoneNumberError:
          showDlg(ErrorMessages.NO_INTERNET_CONNECTION, resendContext);
          errorMessage="";
          break;
        default:
          errorMessage = error.toString();
      }

      //print("typeErrorResend"+error.code);
    }

  onCodeSent(verificationId, forceResendingToken) {
    verificationCode = verificationId;
    //print("verificationId"+verificationCode);
    hideProgress(context);
    shoDialog(resendContext);


  }



}