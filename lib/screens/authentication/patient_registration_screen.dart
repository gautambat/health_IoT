
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:http/http.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:remote_care/constants/colors.dart';
import 'package:remote_care/constants/styles.dart';
import 'package:remote_care/constants/values.dart';
import 'package:remote_care/models/user.dart';
import 'package:remote_care/screens/main/base_state.dart';
import 'package:remote_care/store/dashboard/patient_registration_store.dart';
import 'package:remote_care/utils/utils.dart';
import 'package:remote_care/widgets/base/base_widgets.dart';
import 'dart:convert';
//import 'package:http/http.';

import '../../database/firestore/user_dao.dart';
import '../../widgets/base/base_widgets.dart';


class PatientRegistrationScreen extends StatefulWidget {
  bool addPatient =false;
  PatientRegistrationScreen({this.addPatient});

  @override
  _PatientRegistrationScreenState createState() {
    return _PatientRegistrationScreenState();
  }
}

class _PatientRegistrationScreenState extends BaseState<PatientRegistrationScreen> {

  GlobalKey<FormState> _formkey = new GlobalKey<FormState>();
  PatientRegistrationStore store =  new PatientRegistrationStore();
  User currentUser;
  List<String> dummy = new List();
  var inputFormatters = [
    LengthLimitingTextInputFormatter(10),
    WhitelistingTextInputFormatter.digitsOnly,
  ];
  var textInputFormatter = [
    LengthLimitingTextInputFormatter(30),
    WhitelistingTextInputFormatter(RegexConst.nameRegExp)
  ];
  var addressInputFormatter = [
    LengthLimitingTextInputFormatter(40),
    WhitelistingTextInputFormatter(RegexConst.addressRegExp)
  ];
  var textNumberInputFormatter = [
    LengthLimitingTextInputFormatter(20),
    WhitelistingTextInputFormatter(RegexConst.textNumberRegExp)
  ];
  var zipFormatters = [
    LengthLimitingTextInputFormatter(6),
    WhitelistingTextInputFormatter.digitsOnly,
  ];
  var aadharFormatters = [
    LengthLimitingTextInputFormatter(12),
    WhitelistingTextInputFormatter.digitsOnly,
  ];


  @override
  void initState() {
    super.initState();
    store.patientIDController.text =  store.pid == '' ? DateTime.now().millisecondsSinceEpoch.toString() : store.pid;
    if(store.pid == '')
      store.pid = store.patientIDController.text;


    //doctors = DoctorDao().getDoctors();
  }

  @override
  void dispose() {
    super.dispose();
  }
  @override
  getAppBar() {
    return getAppBarWidgets(
        title: Titles.REGISTRATION,
        widgets:<Widget>[
      InkWell(
          onTap: () {
            if (_formkey.currentState.validate()) {
              log("form validated.");
            }
          },
          child: Observer(
          builder: (_) =>InkWell(
            onTap: (){
              if(_formkey.currentState.validate()){


                store.savePersonalData(currentUser,context,pushAndRemoveUntil);

              }
            },
            child: Container(
                margin:EdgeInsets.only(right: 10),
                child: Center(
                    child: Text(!store.isPatientDetailsSaved?Strings.SAVE:Strings.SUBMIT, textAlign: TextAlign.right, style: BaseStyles.appTitleTextStyle))),
          )
          )
      ),
    ],
        leftWidget: null
    );
  }
//  @override
//  getAppBar() => getAppBarWidgets(title: "Registration", widgets: [Text("SAVE")], leftWidget: null);
  @override
  withDefaultMargins() {
    return false;
  }

  //String name;
  bool loading = false;
  /*Future getPincodeData(String zip) async {
    Response response = await get(
      'https://api.postalpincode.in/pincode/$zip',
      headers: {
        "Accept": "application/json"
      }
    );
    //log(response.body);
    List data = json.decode(response.body);
    log(data[0]['PostOffice'][0]);
    store.cityController.text = data[0]['PostOffice'][0]['Region'];
    store.stateController.text = data[0]['PostOffice'][0]['State'];

  }*/

  @override
  init() async {
    setState(() {
      loading = true;
    });
    //await Lists();//.then((value) {});

    setState(() {
      loading = false;
    });


    currentUser = Provider.of<User>(context,listen: false);
    store.phoneNumberController.text = currentUser.mobile;


  }

  @override
  getPageContainer() {
    return loading ? Center(child: CircularProgressIndicator(),) : registrationContainer();
    /*Column(
      children: <Widget>[
    Visibility(visible:!addPatient,child:getTabViewButtons()),
        Expanded(
          child: Observer(
              builder: (_) => store.isPatientDetailsSaved?insuranceContainer():registrationContainer()
          ),
        )

      ],
    );*/
  }
  /*getTabViewButtons(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(flex:1,child:getTabPersonalDetails(Strings.PERSONAL_DETAILS,true)),
        Expanded(flex:1,child:getTabItemInsurance())
      ],
    );
  }
  getHeadingLabel(title){
    return Container(
      margin: Margins.baseMarginVertical,
      child: Text(
        title,
        textAlign: TextAlign.left,
        style: TextStyle(
          color: AppColors.primaryText,
          fontWeight: FontWeight.w700,
          fontSize: 16,
          height: 1.5,
        ),
      ),
    );
  }*/


  /*getGenderContainer(){
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: Margins.baseMarginVertical,
            child: Text(
              Hints.GENDER,
              style: TextStyle(
                color: AppColors.primaryText,
                fontWeight: FontWeight.w400,
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ),
          Padding(
            padding: Margins.baseMarginVertical,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                getButton("Male", 0),
                getButton("Female", 1),
                getButton("Others", 2)
              ],
            ),
          )
        ]
    );
  }*/
  getPersonalForm(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          getTextField(focus:false,context: context,inputAction: TextInputAction.next,hint:Hints.FIRST_NAME, label:Labels.FIRST_NAME, controller:store.firstNameController, type:TextInputType.text,formatters:textInputFormatter,onValidate: (value){
            return value.isEmpty
                ? ErrorMessages.EMPTY_NAME : (RegexConst.nameRegExp.hasMatch(value) ? null : ErrorMessages.INVALID_NAME);
          }),
          getTextField(focus:true,context: context,inputAction: TextInputAction.next,hint:Hints.LAST_NAME, label:Labels.LAST_NAME, controller:store.lastNameController, type:TextInputType.text,formatters:textInputFormatter,onValidate: (value){
            return value.isEmpty
                ? ErrorMessages.EMPTY_NAME : (RegexConst.nameRegExp.hasMatch(value) ? null : ErrorMessages.INVALID_NAME);
          }),
          getTextField(hint:Hints.PATIENT_ID, label:Labels.PATIENT_ID, controller:store.patientIDController, type:TextInputType.text,field:FIELD_TYPE.PID,onValidate: (value){
            //return value.isEmpty? "Please enter your name":null;
          }),
          /*getMultiSelectDropdownTextField(hint: Labels.DOCTOR, title: Labels.DOCTOR, onValidate: (value) {
            return value == null || value.length == 0 ? ErrorMessages.OPTION : null;
          }, onSaved: (value) {
            if(value == null)
              return null;
            store.selectedDoctors = value;
          }, data: doctorData),*/
          //getDoctorWidget(),
          getTextField(label:Labels.PHONE_NUMBER, controller:store.phoneNumberController, type:TextInputType.number,formatters:inputFormatters,field:FIELD_TYPE.PH_NUMBER,onValidate: (value){
            return value.isEmpty ? ErrorMessages.EMPTY_CONTACT :  value.length < 10?ErrorMessages.INVALID_MOBILE:null;
          }),
          /*getHeadingLabel(Strings.PERSONAL_DETAILS),
          InkWell(
            onTap: () {
              _selectDate();   // Call Function that has showDatePicker()
            },
            child: IgnorePointer(
              child: getTextField(focus: true,context: context,inputAction: TextInputAction.next,hint:Hints.DOB, label:Labels.DOB, controller:store.dateOfBirthController, type:TextInputType.text,onValidate: (value){
                return value.isEmpty? ErrorMessages.DOB:null;
              }),
            ),
          ),
          getGenderContainer(),
          getTextField(focus:false,context: context,inputAction: TextInputAction.next,hint:Hints.ZIP, label:Labels.ZIP, controller:store.zipCodeController, type:TextInputType.numberWithOptions(
            decimal: false,
            signed: false,
          ),formatters:zipFormatters,onSubmit: (value) async {
            await getPincodeData(value);
          },onValidate: (value){
            return (value.isNotEmpty && RegexConst.numberRegExp.hasMatch(value) && value.toString().length == 6 ? null : ErrorMessages.INVALID_ZIP);
          }),
          getTextField(focus: true,context: context,hint:Hints.ADDRESS, label:Labels.ADDRESS, controller:store.addressController, type:TextInputType.text,formatters:addressInputFormatter,onValidate: (value){
            return (value.isNotEmpty && (RegexConst.addressRegExp.hasMatch(value))? null : ErrorMessages.EMPTY_ADDRESS);
          }),
          store.pid.isEmpty || store.pid == null ? Container() : Container(
            margin: Margins.baseMarginVertical,
            child: getAutoFillTextField(context: context, key: key1, controller: store.cityController, suggestions: cityList == null ? dummy : cityList.list, hint: Hints.CITY, label: Labels.CITY, onChanged: (text) => store.city = text),
          ),
          store.pid.isEmpty || store.pid == null ? Container() : Container(
            margin: Margins.baseMarginVertical,
            child: getAutoFillTextField(context: context, key: key2, controller: store.stateController, suggestions: stateList == null ? dummy : stateList.list, hint: Hints.STATE, label: Labels.STATE, onChanged: (value) => store.state = value),
          ),
          getTextField(context: context,inputAction: TextInputAction.done, hint:Hints.AADHAAR, label:Labels.AADHAAR, controller:store.aadharNumberController, type:TextInputType.numberWithOptions(
            decimal: false,
            signed: false,
          ),formatters:aadharFormatters,onValidate: (value){
            return (value.isEmpty || (RegexConst.numberRegExp.hasMatch(value) && value.toString().length == 12) ? null : 'Enter a valid Adhar Number');
          }),*/

        ],


      ),
    );
  }
  /*getInsuranceForm(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          getHeadingLabel("Insurance (Optional)"),
          getTextField(focus: false,context: context,inputAction: TextInputAction.next,hint:Hints.INSURANCE, label:Labels.INSURANCE, controller:store.insuranceNameController, type:TextInputType.text,formatters:textInputFormatter,onValidate: (value){
//            return value.isEmpty? "Please enter your name":null;
            return (value.isEmpty || (RegexConst.nameRegExp.hasMatch(value))? null : ErrorMessages.INSURANCE);
          }),
          getTextField(focus: false,context: context,inputAction: TextInputAction.next,hint:Hints.MEMBER_ID, label:Labels.MEMBER_ID, controller:store.membershipController,formatters:textNumberInputFormatter,onValidate: (value){
            //return (value.isEmpty ? null : 'Enter a valid Member ID');
          }),
          getTextField(focus: false,context: context,inputAction: TextInputAction.next,hint:Hints.PHONE_NUMBER, label:Labels.PHONE_NUMBER, controller:store.contactController, type:TextInputType.numberWithOptions(
            decimal: false,
            signed: false,
          ),formatters:inputFormatters,onValidate: (value){
            return (value.isEmpty || (RegexConst.numberRegExp.hasMatch(value) && value.toString().length == 10 && (value.toString()[0] == '6' || value.toString()[0] == '7' || value.toString()[0] == '8' || value.toString()[0] == '9')) ? null : ErrorMessages.INVALID_MOBILE);
          }),

          getHeadingLabel("Emergency Contact (Optional)"),
          getTextField(context: context,focus: false,inputAction: TextInputAction.next,hint:Hints.EMERGENCY_NAME, label:Labels.NAME, controller:store.emergencyNameController, type:TextInputType.text,formatters:textInputFormatter,onValidate: (value){
            //return value.isEmpty? "Please enter name of the person":null;
            return (value.isEmpty || (RegexConst.nameRegExp.hasMatch(value))? null : ErrorMessages.INVALID_NAME);
          }),
          getTextField(context: context,focus: true,inputAction: TextInputAction.done,hint:Hints.PHONE_NUMBER, label:Labels.PHONE_NUMBER, controller:store.emergencyPhoneController,type:TextInputType.numberWithOptions(
            decimal: false,
            signed: false,
          ),formatters:inputFormatters,onValidate: (value){
            return (value.isEmpty || (RegexConst.numberRegExp.hasMatch(value) && value.toString().length == 10 && (value.toString()[0] == '6' || value.toString()[0] == '7' || value.toString()[0] == '8' || value.toString()[0] == '9')) ? null : ErrorMessages.INVALID_MOBILE);
          }),
          getLOVTextField(hint: Hints.RELATIONSHIP, label: Labels.RELATIONSHIP, index: -1, items: relationList.list, value: store.relation, onChanged: (value) => store.relation = value, onValidate: (value) {

          })
          //getLOVTextField(hint: Hints.RELATIONSHIP, label: Labels.RELATIONSHIP, index: Constants.RELATIONSHIP, value: store.relation, onChanged: (value) => store.relation = value, onValidate: (value) {}),
          //getSearchDropField(hint: Hints.RELATIONSHIP, label: Labels.RELATIONSHIP, inputFormatters: textInputFormatter, controller: store.relationshipController, index: Constants.RELATIONSHIP, value: store.relation, onChanged: (value) => store.relation = value, onValidate: (value) => null)


        ],


      ),
    );
  }*/
  /*Widget insuranceContainer() {
    return SingleChildScrollView(
      child: Padding(
        padding: Margins.baseMarginHorizontalScreen,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Form(
                key: _formkey,
                autovalidate: false,
                child: getInsuranceForm(),
              ),
            )
          ],
        ),
      ),
    );
  }*/

  Widget registrationContainer() {
    return SingleChildScrollView(
      child: Stack(
        children: <Widget> [Padding(
          padding: Margins.baseMarginHorizontalScreen,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  store.getImage(currentUser.uId, context);
                },
                child: Container(
                  margin: EdgeInsets.only(top: 30.0),
                  height: 70.0,
                  width: 70.0,
                  decoration: store.imageUrl != '' ? BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(store.imageUrl)
                      )
                  ) : BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue[100],
                  ),
                  child: store.imageUrl == '' ? Icon(Icons.person, size: 30, color: AppColors.iconColor,) : Container(),
                ),
              ),
              Container(
                margin: Margins.baseMarginVertical,
                child: Text(
                  Strings.UPLOAD,
                  style: TextStyle(
                    color: Color.fromARGB(255, 29, 111, 220),
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    height: 1.42857,
                  ),
                ),
              ),
              Container(
                child: Form(
                  key: _formkey,
                  autovalidate: false,
                  child: getPersonalForm()
                ),
              )
            ],
          ),
        ),]
      ),
    );
  }



}