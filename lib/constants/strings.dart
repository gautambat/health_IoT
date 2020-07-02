//library constants;

import 'package:flutter/material.dart';

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

  //Page Titles

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
  static const PULSEHINT = 'Pulse (min)';
  static const GLUCOSEHINTBEFORE = 'Before Meal(Ml/OL)';
  static const GLUCOSEHINTAFTER = 'After Meal(Ml/OL)';
  static const WEIGHTHINT = 'Weight(kg)';
  static const TEMPHINT = 'Temparature( \u2109)';
  static const BPSYS = 'BP Systolic(mmHg)';
  static const BPDIA = 'BP Diastolic(mmHg)';
  static const SPO2HINT = 'SpO2 Level(%)';
  static const PATIENT_ID = 'Patient ID';
  static const DOB = 'Date of Birth';
  static const ADDRESS = 'Address';
  static const CITY = 'City';
  static const STATE = 'State';
  static const ZIP = 'Zip Code';
  static const HEIGHT = 'Height';

}
class RegexConst{
  static final RegExp addressRegExp = RegExp('[ a-zA-Z0-9#-()&./,:{}+_=@*|><]');
  static final RegExp nameRegExp = RegExp('[a-zA-Z&. ]');
  static final RegExp numberRegExp = RegExp('[0-9]');
  static final RegExp tempRegExp = RegExp('[0-9.]');
  static final RegExp textNumberRegExp = RegExp('[a-zA-Z0-9]');
}
class Constants {
  static const PULSE= 0;
  static const BP= 1;
  static const SPO2= 2;
  static const GLUCOSE= 3;
  static const WEIGHT= 5;
  static const TEMP= 4;

  static const Appointment_Date = "Appointment Date";
  static const Appointment_Time = "Appointment Time";


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
  static const INVALID_ZIP = 'Enter a valid ZipCode';
  static const OTP_RESEND = 'OTP has been successfully resent.';
  static const NO_INTERNET_CONNECTION = "No internet Connection";


  //readings
  static const BP_DETAILS_SAVED ="Bp  Details Saved";
  static const PULSE_DETAILS_SAVED ="Pulse  Details Saved";
  static const PULSE_SPO2_DETAILS_SAVED ="Pulse and SPO2 Details Saved";
  static const GLUCOSE_DETAILS_SAVED ="Glucose  Details Saved";
  static const TEMP_DETAILS_SAVED ="Temp  Details Saved";
  static const WEIGHT_DETAILS_SAVED ="Weight Saved";
  static const SPO2_DETAILS_SAVED ="SPO2  Details Saved";


  static const PULSE_RANGE ="Please enter pulse range values 40 to 200";
  static const SPO2_RANGE ="Please enter spo2 range values 75 to 100";
  static const TEMP_RANGE ="Please enter Temp range values 95 \u2109  to 106.7 \u2109";
  static const BP_RANGE_DIA ="Please enter bp diastolic range values 40 to 100";
  static const BP_RANGE_SYS ="Please enter bp systolic range values 70 to 190";

}

class TabTitle{
  static const PULSE = 'Pulse';
  static const BP = 'BP';
  static const SPO2 = 'SPO2';
  static const GLUCOSE = 'Glucose';
  static const TEMP = 'Temp';
  static const WEIGHT = 'Weight';
}

class CollectionType{
  static const BP = "bp";
  static const TEMP = "temp";
  static const PULSE = "pulse";
  static const SPO2 = "spo2";
  static const GLUCOSE = "glucose";
  static const weight = 'weight';
}

class NavigationTitles{
  static const SIGN_UP = "Sign Up";
  static const LOGIN = "Login";
  static const HOME_PAGE = "Home";
  static const DASHBOARD = "Dashboard";

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
  static const HISTORY = "History";
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
