import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:remote_care/constants/colors.dart';
import 'package:remote_care/constants/strings.dart';
import 'package:remote_care/constants/styles.dart';
import 'package:remote_care/constants/values.dart';
import 'package:remote_care/models/user.dart';
import 'package:remote_care/screens/main/base_state.dart';
import 'package:remote_care/store/dashboard/patient_registration_store.dart';
import 'package:remote_care/utils/utils.dart';
import 'package:remote_care/widgets/base/base_widgets.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'dart:async';

import '../../constants/strings.dart';
import '../../constants/strings.dart';
import '../../database/firestore/user_dao.dart';
import '../../widgets/base/base_widgets.dart';


class PatientProfileScreen extends StatefulWidget {
  final User user;

  PatientProfileScreen({Key key, this.user}) : super(key: key);

  @override
  _PatientProfileScreenState createState() {
    return _PatientProfileScreenState();
  }
}

class _PatientProfileScreenState extends BaseState<PatientProfileScreen> {

  GlobalKey<FormState> _formkey = new GlobalKey<FormState>();
  PatientRegistrationStore store =  new PatientRegistrationStore();
  GlobalKey<AutoCompleteTextFieldState<String>> key1 = new GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<String>> key2 = new GlobalKey();
  //Future<List<Doctor>> doctors;
  //ListsRecord cityList, stateList, relationList;
  User currentUser;
  //ListsRecord cityList, stateList, relationList;
  List<String> dummy = new List();
  //List<Doctor> doctorList;
  //List<User> user;
  //String url;
  //bool isRegisterd = true;
  //static String dob = '';
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
    currentUser = widget.user;
    store.phoneNumberController.text = currentUser.mobile;
    store.patientIDController.text = currentUser.pId;
    store.firstNameController.text = currentUser.firstName ?? null;
    store.lastNameController.text = currentUser.lastName ?? null;
    String gender = currentUser.gender ?? null;
    if(gender == 'Male')
      store.selectedGender = 0;
    else if(gender == 'Female')
      store.selectedGender = 1;
    else if(gender == 'Others')
      store.selectedGender = 2;
    else
      store.selectedGender = 0;
    store.heightController.text = currentUser.height != null ? currentUser.height.toString() ?? null : null;
    store.weightController.text = currentUser.weight != null ? currentUser.weight.toString() ?? null : null;
    store.imageUrl = currentUser.imageUrl ?? '';
    store.dateOfBirthText = currentUser.date ?? null;
    store.dobController.text = currentUser.date ?? null;
    init();
    //store.relationshipController.text = user[0].emergency.relationship ?? null;
  }

  @override
  void dispose() {
    super.dispose();
  }
  @override
  getAppBar() {
    return getAppBarWidgets(
        title: Titles.PROFILE,
        widgets:<Widget>[
          InkWell(
              onTap: (){
                if(_formkey.currentState.validate()){
                  store.updatePersonalData(currentUser,context, pushAndRemoveUntil);
                }
              },
              child: Container(
                  margin:EdgeInsets.only(right: 10),
                  child: Center(
                      child: Text(Strings.SAVE, textAlign: TextAlign.right, style: BaseStyles.appTitleTextStyle)
                  )
              )

          )

        ],
        leftWidget: IconButton(icon: Icon(Icons.arrow_back, color: Colors.white,), onPressed:() => pop()));
  }
//  @override
//  getAppBar() => getAppBarWidgets(title: "Registration", widgets: [Text("SAVE")], leftWidget: null);
  @override
  withDefaultMargins() {
    return false;
  }

  /*Future Lists() async {
    cityList = await ListsDao().getCityList();
    stateList = await ListsDao().getStateList();
    relationList = await ListsDao().getRelatonshipList();
    doctorList = await DoctorDao().getDoctors();
  }*/

  //String name;
  //bool loading = false;

  @override
  getPageContainer() {

    return Column(
      children: <Widget>[
        //getTabViewButtons(),
        Expanded(
          child: registrationContainer()

        )

      ],
    );
  }



  getGenderContainer(){
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          getHeadingLabel("Gender"),
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
  }

  getPersonalForm(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          getTextField(focus:true,context: context,inputAction: TextInputAction.next,hint:Hints.FIRST_NAME, label:Labels.FIRST_NAME, controller:store.firstNameController, type:TextInputType.text,formatters:textInputFormatter,onValidate: (value){
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
          }),
          currentUser.date == null ? InkWell(
            onTap: () {
              _selectDate();   // Call Function that has showDatePicker()
            },
            child: IgnorePointer(
              child: getTextField(focus: true,context: context,inputAction: TextInputAction.next,hint:Hints.DOB, label:Labels.DOB, controller:store.dateOfBirthController, type:TextInputType.text,onValidate: (value){
                return value.isEmpty? ErrorMessages.DOB:null;
              }),
            ),
          ) :
          getTextField(hint:Hints.DOB, label:Labels.DOB, controller:store.dobController, field: FIELD_TYPE.dob, type:TextInputType.text, formatters: inputFormatters,onValidate: (value){

          }),
          getGenderContainer(),
          //getTextField(hint: Hints.EMAIL, label: Labels.EMAIL, context: context, focus: false, inputAction: TextInputAction.next, controller: store.emailController, onValidate: (value) {}),
          getTextField(hint: Hints.HEIGHT, label: Labels.HEIGHT, context: context, focus: false, inputAction: TextInputAction.next, controller: store.heightController, onValidate: (value) {}, type: TextInputType.numberWithOptions(
            signed: false,
          )),
          getTextField(hint: TabTitle.WEIGHT, label: TabTitle.WEIGHT, context: context, focus: false, inputAction: TextInputAction.next, controller: store.weightController, onValidate: (value) {}, type: TextInputType.numberWithOptions(
            signed: false,
          )),

        ],


      ),
    );
  }

  void _selectDate() async{
    store.date = await showDatePicker(
        context: context,
        initialDate:DateTime(1980),
        firstDate:DateTime(1920),
        lastDate: DateTime(2018)
    );
    store.dateOfBirth = Timestamp.fromDate(store.date);
    store.dateOfBirthController.text = Jiffy(store.date).format("dd/MM/yyyy");
    store.dobController.text = Jiffy(store.date).format("dd/MM/yyyy");
    //store.dateOfBirthText = Jiffy(store.date).format("dd/MM/yyyy");
    //store.date = store.dateOfBirthController.text;

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
                  onTap: () async {

                    await store.getImage(currentUser.uId, context);
                    setState(() {
                      //print(store.imageUrl+' prof');
                    });
                  },
                  child: store.imageUrl != '' ?  Container(
                    margin: EdgeInsets.only(top: 30.0),
                    height: 70.0,
                    width: 70.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(store.imageUrl)
                        )
                    ),
                  ):
                  Container(
                    margin: EdgeInsets.only(top: 30.0),
                    height: 70.0,
                    width: 70.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue[100]
                    ),
                    child: Icon(Icons.person, color: AppColors.iconColor,),
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

  getButton(text,index){
    var unSelectedDecor = BoxDecoration(
      color: AppColors.primaryElement,
      border: Border.fromBorderSide(Borders.secondaryBorder),
      boxShadow: [
        Shadows.primaryShadow,
      ],
      borderRadius: Radii.k4pxRadius,
    );
    var selectedDecor = BoxDecoration(
      color: Color.fromARGB(26, 29, 111, 220),
      border: Border.all(width: 1,
        color: Color.fromARGB(255, 29, 111, 220),
      ),
      borderRadius: Radii.k4pxRadius,
    );

    var selectedColor = Color.fromARGB(255, 29, 111, 220);
    return InkWell(
        onTap: (){
          store.selectedGender = index;
        },
        child: Observer(
          builder: (_) => Container(
            width: 100,
            height: 40,
            decoration: store.selectedGender==index?selectedDecor:unSelectedDecor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: store.selectedGender==index?selectedColor:AppColors.primaryText,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    height: 1.42857,
                  ),
                ),
              ],
            ),
          ),
        ));
  }

}