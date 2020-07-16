import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:remote_care/constants/constants.dart';
import 'package:remote_care/screens/main/base_state.dart';
import 'package:remote_care/store/authentication/otp_verification_store.dart';
import 'package:remote_care/widgets/custom_button.dart';
import 'package:remote_care/widgets/otp_text_field.dart';

class OTPVerificationScreen extends StatefulWidget {

  final String mobileNumber;
  final  String verificationId;
  final String forceResendingToken;
  final String name;

  OTPVerificationScreen({Key key,this.mobileNumber,this.name,this.forceResendingToken,this.verificationId}) : super(key: key);

  @override
  _OTPVerificationScreenState createState() {
    return _OTPVerificationScreenState();
  }
}

class _OTPVerificationScreenState extends BaseState<OTPVerificationScreen> {
  OTPVerificationStore store = OTPVerificationStore();
  String smsCode="";
  String selectedCountryCode = "+91";

  @override
  pageTitle()=>"";

  @override
  getAppBar() {
    return getAppBarWidgets(title:Titles.VERIFY_OTP_TITLE,leftWidget:  InkWell(
    onTap: () {
      pop();
    },child:Icon(Icons.arrow_back, color: AppColors.white,)), widgets: null);
  }

  @override
  init() {
    store.verificationCode = widget.verificationId;
    return super.init();
  }

  @override
  canGoBack() {
    return true;
  }
  @override
  getBackgroundColor() =>AppColors.homeScreenBackgroundWhite;

  @override
  getPageContainer() {
    return  SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 30),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    Titles.VERIFY_OTP,
                    textAlign: TextAlign.left,
                    style:TextStyle(
                      color: AppColors.primaryText,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      height: 1.33333,
                    ),
                  ),
                  Text(
                    Titles.ENTER_OTP_DESC +" "+ this.widget.mobileNumber,
                    //Titles.ENTER_OTP_DESC,
                    textAlign: TextAlign.left,
                    style: BaseStyles.hintTextStyle,
                  ),
                GestureDetector(
                    onTap: (){
pop();
},
                    child: Container(
                     margin: EdgeInsets.only(top: 10,bottom: 10),
                     child: Text(
                    //Titles.ENTER_OTP_DESC + this.widget.mobileNumber,
                    'Change Number',
                    textAlign: TextAlign.left,
                    style: BaseStyles.errorTextStyle,
                  )))
                ]),
          ),
          Padding(
            padding: const EdgeInsets.only(top:10.0,bottom: 10),
            child: Column(children: <Widget>[
              OTPTextField(onSubmit: (value){
                smsCode = value;
              },),
              Observer(builder: (_) =>
                  Text(store.errorMessage,style: BaseStyles.errorTextStyle)
              ),
              getContinueOrLoginButton(),

              Container(
                  margin: EdgeInsets.only(top: 30,bottom: 5),
                  child: Text(
                    //Titles.ENTER_OTP_DESC + this.widget.mobileNumber,
                    Strings.I_DID_NOT_RECEIVE,
                    textAlign: TextAlign.left,
                    style: BaseStyles.hintTextStyle,
                  )),
              GestureDetector(
                  onTap: (){
                    //store.resendOTP(this.widget.mobileNumber);

                    store.resendOTP(this.widget.mobileNumber,context);


                  },
                  child:Container(
                  child: Text(
                    //Titles.ENTER_OTP_DESC + this.widget.mobileNumber,
                    Strings.RESEND_OTP,
                    textAlign: TextAlign.left,
                    style: BaseStyles.errorTextStyle,
                  )) )          ]),
          )
        ],
      ),
    );
  }
  getContinueOrLoginButton(){
    return CustomButton(title:Titles.VERIFY,color: AppColors.secondaryBackground, onPressed: () async {


     // if(_formKey.currentState.validate()){


    store.verifyOTP(context,push,
    smsCode,
    store.verificationCode,
    this.widget.mobileNumber,
    this.widget.name);



 //     }
   });
  }




}