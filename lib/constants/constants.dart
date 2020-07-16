import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Radii {
  static const BorderRadiusGeometry k4pxRadius = BorderRadius.all(Radius.circular(4));
}

class Shadows {
  static const BoxShadow primaryShadow = BoxShadow(
    color: Color.fromARGB(13, 0, 0, 0),
    offset: Offset(0, 2),
    blurRadius: 5,
  );
}

class Borders {
  static const BorderSide primaryBorder = BorderSide(
    color: Color.fromARGB(255, 151, 151, 151),
    width: 1,
    style: BorderStyle.solid,
  );
  static const BorderSide noBorder = BorderSide(
    color: Colors.transparent,
    width: 1,
    style: BorderStyle.solid,
  );
  static const BorderSide secondaryBorder = BorderSide(
    color: Color.fromARGB(255, 227, 232, 237),
    width: 1,
    style: BorderStyle.solid,
  );
  static const BorderSide errorBorder = BorderSide(
    color: Color.fromARGB(255, 255, 0, 0),
    width: 1,
    style: BorderStyle.solid,
  );
  static const outlineInputBorder = OutlineInputBorder(
      borderSide: Borders.secondaryBorder,
      borderRadius: Radii.k4pxRadius
  );
  static const outlineErrorInputBorder = OutlineInputBorder(
      borderSide: Borders.errorBorder,
      borderRadius: Radii.k4pxRadius
  );
}

class Margins{
  static const EdgeInsets baseMarginVertical =  EdgeInsets.only(top: 8,bottom: 8);
  static const EdgeInsets baseMarginHorizontalScreen =  EdgeInsets.only(left: 16,right: 16);
  static const EdgeInsets baseMarginAllScreen =  EdgeInsets.only(left:16.0,right:16.0,top:5,bottom: 5);
}

class BaseStyles{
  static TextStyle hintTextStyle = TextStyle(
    color: AppColors.primaryText,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: 1.66667,
  );
  static TextStyle loginSubHeadingTextStyle = TextStyle(
    color: AppColors.secondaryText,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 1.5,
  );
  static const TextStyle editLabelTextStyle = TextStyle(
    color: AppColors.secondaryText,

  );
  static const TextStyle editTextTextStyle2 = TextStyle(
    color: AppColors.secondaryText,
    fontWeight: FontWeight.w600,
    fontSize: 16,
    height: 1.5,
  );

  static const TextStyle editTextTextStyle = TextStyle(
    color: AppColors.primaryText,
    fontWeight: FontWeight.w600,
    fontSize: 16,
    height: 1.5,
  );
  static const TextStyle eRxTextStyle = TextStyle(
    color: AppColors.primaryText,
    fontWeight: FontWeight.w600,
    fontSize: 14,
    height: 1.5,
  );
  static const TextStyle editHintTextStyle = TextStyle(
    color: Color.fromARGB(255, 221, 225, 230),
    fontFamily: "Manrope",
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 1.5,
  );
  static TextStyle baseTextStyle = TextStyle(color: AppColors.primaryText,
    fontWeight: FontWeight.w600,
    fontSize: 14,
    height: 1.428571,);


  static TextStyle titleTextStyle = TextStyle(
    color: AppColors.primaryText,
    fontWeight: FontWeight.w700,
    fontSize: 24,
    height: 1.33333,
  );

  static TextStyle loginHeadingTextStyle =
  TextStyle(
    color: AppColors.primaryText,
    fontWeight: FontWeight.w700,
    fontSize: 24,
    height: 1.45833,
  );
  static TextStyle errorTextStyle = TextStyle(
    color: AppColors.errorColor,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: 1.33333,
  );

  static TextStyle navigationTextStyle = TextStyle(
    color: AppColors.secondaryText,
    fontFamily: "Manrope",
    fontWeight: FontWeight.w500, //400
    fontSize: 11, //10
    height: 1.4,
  );
  static TextStyle navigationTextStyle2 = TextStyle(
    color: AppColors.activeIconColor,
    fontFamily: "Manrope",
    fontWeight: FontWeight.w500, //400
    fontSize: 11, //10
    height: 1.4,
  );
  static TextStyle appTitleTextStyle =TextStyle(
    color: AppColors.white,//Color.fromARGB(255, 255, 255, 255),
    fontWeight: FontWeight.w500,
    fontSize: 16,
    height: 1.625,
  );

}

class AppColors {

  static const Color primaryBackground = Color.fromARGB(255, 255, 255, 255);
  static const Color secondaryBackground = Color.fromARGB(255, 0, 186, 117);
  static const Color ternaryBackground = Color.fromARGB(255, 0, 166, 102);
  static const Color primaryElement = Color.fromARGB(255, 239, 240, 244);
  static const Color secondaryElement = Color.fromARGB(255, 255, 255, 255);
  static const Color accentElement = Color.fromARGB(255, 151, 151, 151);
  static const Color primaryText = Color.fromARGB(255, 45, 52, 64);
  static const Color secondaryText = Color.fromARGB(255, 123, 132, 147);
  static const Color accentText = Color.fromARGB(255, 174, 182, 196);
  static const Color errorColor = Colors.red;
  static const Color buttonTextColor = Color.fromARGB(255, 255, 255, 255);
  static const Color homeScreenBackground = Color.fromARGB(255, 248, 248, 248);
  static const Color homeScreenBackgroundWhite = Colors.white;
  static const Color white = Colors.white;

  static  Color appBarColor = Colors.greenAccent;
  static Color activeIconColor = Color(0xff1d6fdc);
  static Color iconColor = Color(0xff7b8392);
  static Color tabColor = Color(0xff1d6fdc);
  static Color notificationColor = Color(0x1a1d6fdc);
}

class Strings{

    static const UPLOAD = 'Upload';
    static const UPDATE = 'Update';
    static const CHANGE_NUMBER = 'Change Number';
    static const RESEND_OTP = 'Resend OTP';
    static const RESEND_OTP_SUCCESS = 'OTP sent successfully';
    static const SAVE = 'Save';
    static const SUBMIT = 'Submit';
    static const I_DID_NOT_RECEIVE = 'I did not receive the code';

    static const EXIT_BACK='Tap back again to leave';


}

class Hints {
  static const NAME = 'What is your name?';
  static const FIRST_NAME = 'What is your first name?';
  static const LAST_NAME = 'What is your last name?';
  static const PHONE_NUMBER = 'Phone Number';
  static const GENDER = "What’s your gender?";
  static const PATIENT_ID = 'Patient ID';
  static const DOB = 'What is your Date of Birth?';
  static const ADDRESS = 'Where do you live?';
  static const CITY = 'City';
  static const STATE = 'State';
  static const ZIP = 'Zip Code';
  static const HEIGHT = 'Height in cm';

}

class Labels {
  static const NAME = 'Name';
  static const FIRST_NAME = 'First Name';
  static const LAST_NAME = 'Last Name';
  static const PHONE_NUMBER = 'Phone Number';
  static const PULSEHINT = 'Pulse(bpm)';
  static const TEMPHINT = 'Temparature( \u2109)';
  static const BPSYS = 'BP Systolic(mmHg)';
  static const BPDIA = 'BP Diastolic(mmHg)';
  static const SPO2HINT = 'SpO2(%)';
  static const PATIENT_ID = 'Patient ID';
  static const DOB = 'Date of Birth';
  static const HEIGHT = 'Height';

}
class RegexConst{
  static final RegExp nameRegExp = RegExp('[a-zA-Z&. ]');
  static final RegExp numberRegExp = RegExp('[0-9]');
  static final RegExp tempRegExp = RegExp('[0-9.]');
  static final RegExp textNumberRegExp = RegExp('[a-zA-Z0-9]');
}
class Constants {
  static const PULSE= 3;
  static const BP= 0;
  static const SPO2= 1;
  static const TEMP= 2;
  static const PATIENT = "Patient";
  static const ADMIN = 'Admin';

}

class PopUpMessages{
  static const CLOSE = "Close";
}

class ErrorMessages{
  static const EMPTY_MOBILE = "Please enter valid Mobile Number";
  static const EMPTY_CONTACT = "Please enter Contact Number";
  static const ENTER_OTP = "Please enter OTP sent to your mobile";
  static const INVALID_OTP = "Invalid OTP";
  static const OTP_SESSION_EXPIRED = "OTP Session Expired";
  static const OTP_NETWORKFAILED = "Network Failed";
  static const ERROR_INVALID_VERIFICATION_CODE = "ERROR_INVALID_VERIFICATION_CODE";
  static const ERROR_SESSION_EXPIRED = "ERROR_SESSION_EXPIRED";
  static const ERROR_NETWORK_REQUEST_FAILED = "ERROR_NETWORK_REQUEST_FAILED";
  static const verifyPhoneNumberError = "verifyPhoneNumberError";
  static const INVALID_MOBILE = "Not a valid Mobile Number";
  static const ROLE_SELECT_ERROR = "Please select role";
  static const EMPTY_NAME = "Please enter your Name";
  static const INVALID_NAME = 'Enter a valid Name';
  static const GENDERNOTSELECTED = "Please Select gender";
  static const DOB ="Enter Date Of Birth";
  static const No_READINGS ="No Readings Added";
  static const No_READINGS_SUBTITLE ="Seems like you've not added any readings yet";
  static const PATIENT_DETAILS_NOT_Found ="Patients details not found";
  static const OPTION = 'Please select an Option';
  static const OTP_RESEND = 'OTP has been successfully resent.';
  static const NO_INTERNET_CONNECTION = "No internet Connection";


  //readings
  static const BP_DETAILS_SAVED ="Bp  Details Saved";
  static const PULSE_DETAILS_SAVED ="Pulse  Details Saved";
  static const TEMP_DETAILS_SAVED ="Temp  Details Saved";
  static const SPO2_DETAILS_SAVED ="SPO2  Details Saved";

}

class TabTitle{
  static const PULSE = 'Pulse';
  static const BP = 'BP';
  static const SPO2 = 'SpO2';
  static const TEMP = 'Temp';
  static const WEIGHT = 'Weight';
}

class CollectionType{
  static const BP = "bp";
  static const TEMP = "temp";
  static const PULSE = "pulse";
  static const SPO2 = "spo2";
}

class Titles{
  static const APP_NAME = "Remotecare";
  static const SIGN_UP = "Sign Up";
  static const REMOTE_LOGIN = "Login to Remotecare";
  static const SELECT_REMOTE_ROLE = "Select your role and enter your number";
  static const SIGN_UP_DESC = "Enter your basic details to sign up";
  static const LOGIN = "Login";
  static const VERIFY_OTP_TITLE = "Verify OTP";
  static const VERIFY = "Verify";
  static const READINGS = "Take Reading";
  static const PROCEED = "Proceed";
  static const LOGIN_with_mobile = "Login with Phone Number";
  static const LOGIN_DESC = "Please enter your login details";
  static const LOGIN_DESCRIPTION = "We will send you an OTP to verify your phone number";
  static const SIGNUP_BTN_CONTINUE = "Continue";
  static const ENTER_OTP = "Enter OTP";
  static const VERIFY_OTP = "Verify Number";
  static const ENTER_OTP_DESC = "We sent you a code on";
  static const NEW_HERE = "New Here?";
  static const HAVE_ACCOUNT = "Have an account?";
  static const PROFILE = 'Profile';
  static const DASHBOARD = "Dashboard";
  static const REGISTRATION="Registration";
  static const SAVE="Save";
  static const LOGOUT = 'Logout';

}
