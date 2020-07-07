
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:remote_care/constants/constants.dart';
import 'package:remote_care/models/user.dart';
import 'package:remote_care/screens/main/base_state.dart';
import 'package:remote_care/store/dashboard/patient_registration_store.dart';
import 'package:remote_care/widgets/base/base_widgets.dart';

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
  var inputFormatters = [
    LengthLimitingTextInputFormatter(10),
    WhitelistingTextInputFormatter.digitsOnly,
  ];
  var textInputFormatter = [
    LengthLimitingTextInputFormatter(30),
    WhitelistingTextInputFormatter(RegexConst.nameRegExp)
  ];


  @override
  void initState() {
    super.initState();
    store.patientIDController.text =  store.pid == '' ? DateTime.now().millisecondsSinceEpoch.toString() : store.pid;
    if(store.pid == '')
      store.pid = store.patientIDController.text;
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


  @override
  init() async {


    currentUser = Provider.of<User>(context,listen: false);
    store.phoneNumberController.text = currentUser.mobile;


  }

  @override
  getPageContainer() {
    return loading ? Center(child: CircularProgressIndicator(),) : registrationContainer();
  }

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
          getTextField(label:Labels.PHONE_NUMBER, controller:store.phoneNumberController, type:TextInputType.number,formatters:inputFormatters,field:FIELD_TYPE.PH_NUMBER,onValidate: (value){
            return value.isEmpty ? ErrorMessages.EMPTY_CONTACT :  value.length < 10?ErrorMessages.INVALID_MOBILE:null;
          }),

        ],


      ),
    );
  }


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