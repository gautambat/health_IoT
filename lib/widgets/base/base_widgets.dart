import 'dart:core';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:remote_care/constants/styles.dart';
import 'package:remote_care/constants/values.dart';
import 'package:remote_care/models/user.dart';
import 'package:remote_care/screens/authentication/signup_login_screen.dart';
import 'package:remote_care/screens/dashboard/pat_profile.dart';
import 'package:remote_care/service/firebase_auth_service.dart';
import 'package:remote_care/widgets/multiselect_dropfield.dart';
import 'package:remote_care/widgets/search_droplist.dart';

import '../../constants/styles.dart';
import '../../constants/styles.dart';
import '../../constants/styles.dart';
import '../drawer_patient.dart';

mixin BaseWidgets {

  /*getTabImage(iconName){
    return Image.asset(iconName, fit: BoxFit.none);
  }
  getTabImageTint(iconName,color){
    return Image.asset(iconName, fit: BoxFit.none,color: color,);
  }*/
  getTabText(text){
    return Text(text,style: BaseStyles.navigationTextStyle);
  }
  getTabTextActive(text){
    return Text(text,style: BaseStyles.navigationTextStyle2);
  }

  getEmptyAppBar() => PreferredSize(child: Container(), preferredSize: Size(0, 0));

  buildBottomSheet(context,widget){
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => Padding(padding:Margins.baseMarginVertical,child:widget));
  }
  getSimpleAppBar(title){
    return AppBar(
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: AppColors.secondaryElement,
        title: Text(title,style: BaseStyles.appTitleTextStyle)
    );
  }
  getAppBarWidgets({@required title,@required widgets,@required leftWidget}){
    return AppBar(
        leading: leftWidget,
        centerTitle: true,
        elevation: 0.5,
        backgroundColor: AppColors.secondaryBackground,
        title: Text(title,style: BaseStyles.appTitleTextStyle),actions:widgets
    );
  }

  getTextField({context,hint,label,controller,type,inputAction,maxLines,suffixicon,formatters,field,onValidate,focus,onSubmit,onChange}){
    if (focus == null) {
      focus = true;
    }
    return Container(
      margin: Margins.baseMarginVertical,
      child: TextFormField(
        textCapitalization: TextCapitalization.sentences,
        controller: controller,
        keyboardType: type,
        textInputAction:inputAction ,
        maxLines: maxLines,
        onEditingComplete: () => focus ? FocusScope.of(context).unfocus() : FocusScope.of(context).nextFocus(),
        //initialValue: initial,
        onChanged: (text){
          onChange(text);
        },
        onFieldSubmitted: onSubmit != null ? onSubmit : (text) {},
        readOnly: (field==FIELD_TYPE.PID||field==FIELD_TYPE.PH_NUMBER||field==FIELD_TYPE.dob||field==FIELD_TYPE.name)?true:false,
        inputFormatters: formatters,
        validator:(value)=> onValidate(value),
        enableSuggestions:false ,
        style: (field==FIELD_TYPE.PID||field==FIELD_TYPE.PH_NUMBER||field==FIELD_TYPE.dob||field==FIELD_TYPE.name)?BaseStyles.editTextTextStyle2:BaseStyles.editTextTextStyle,
        decoration: InputDecoration(
//          contentPadding: EdgeInsets.zero,
          filled: true,
//          helperText: label,
          fillColor: AppColors.primaryBackground,
          enabledBorder: Borders.outlineInputBorder,
          focusedBorder: Borders.outlineInputBorder,
          errorBorder: Borders.outlineErrorInputBorder,
          focusedErrorBorder: Borders.outlineErrorInputBorder,
          hintText: hint,
          labelText: label,
          enabled: true,
          suffixIcon: suffixicon,
          alignLabelWithHint: true,


          //floatingLabelBehavior: FloatingLabelBehavior.always,
          labelStyle: BaseStyles.editLabelTextStyle,
          hintStyle: BaseStyles.editHintTextStyle,
        ),
      ),
    );
  }
  getFormDropField({hint,label,controller,type,formatters,field,onValidate}){
    return Container(
      margin: Margins.baseMarginVertical,
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        //textInputAction: ,
        onChanged: (text){

        },
        //initialValue: initial,
        readOnly: (field==FIELD_TYPE.PID||field==FIELD_TYPE.PH_NUMBER||field==FIELD_TYPE.dob)?true:false,
        inputFormatters: formatters,
        validator:(value)=> onValidate(value),
        enableSuggestions:false ,
        style: BaseStyles.editTextTextStyle,
        decoration: InputDecoration(
//          contentPadding: EdgeInsets.zero,
          filled: true,
//          helperText: label,
          fillColor: AppColors.primaryBackground,
          enabledBorder: Borders.outlineInputBorder,
          focusedBorder: Borders.outlineInputBorder,
          errorBorder: Borders.outlineErrorInputBorder,
          focusedErrorBorder: Borders.outlineErrorInputBorder,
          hintText: hint,
          labelText: label,
          enabled: true,

          //floatingLabelBehavior: FloatingLabelBehavior.always,
          labelStyle: BaseStyles.editLabelTextStyle,
          hintStyle: BaseStyles.editHintTextStyle,
        ),
      ),
    );
  }

  getLOVTextField({hint, label, value, onChanged, onValidate, index, List<String>items}) {
    if(index == -1) {
      return Container(
        margin: Margins.baseMarginVertical,
        child: DropdownButtonFormField (
          decoration: InputDecoration(
            filled: true,
//          helperText: label,
            fillColor: AppColors.primaryBackground,
            enabledBorder: Borders.outlineInputBorder,
            focusedBorder: Borders.outlineInputBorder,
            errorBorder: Borders.outlineErrorInputBorder,
            focusedErrorBorder: Borders.outlineErrorInputBorder,
            // hintText: "Enter QTY",
            labelText: label,
            enabled: true,
            hintText: hint,
            //floatingLabelBehavior: FloatingLabelBehavior.always,
            labelStyle: BaseStyles.editTextTextStyle2,
            hintStyle: BaseStyles.editHintTextStyle,
          ),
          style: BaseStyles.editLabelTextStyle,
          validator: (value) => onValidate(value),
          value: value,
          onChanged: (text) => onChanged(text),
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: BaseStyles.editTextTextStyle),
            );
          }).toList(),
        ),
      );
    }
    return StreamBuilder(
      stream: Firestore.instance.collection('Lists').snapshots(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(),);
        }
        ////print('a');
        List <String> list = new List<String>();
        for(int i = 0; i < snapshot.data.documents.length; i++) {
          ////print('1');
          //List l = snapshot.hasData ? snapshot.data.documents[index]['list'] : [];
          if(snapshot.data.documents[i]['uid'] == index) {
            ////print('index : ' + index.toString());
            List l = snapshot.data.documents[i]['list'];
            for (int i = 0; i < l.length; i++) {
              list.add(l[i].toString());
            }
            break;
          }
          else {
            continue;
          }
          ////print(l);
        }
        ////print(snapshot.data.documents.length);
        return Container(
          margin: Margins.baseMarginVertical,
          child: DropdownButtonFormField (

            decoration: InputDecoration(
              filled: true,
//          helperText: label,
              fillColor: AppColors.primaryBackground,
              enabledBorder: Borders.outlineInputBorder,
              focusedBorder: Borders.outlineInputBorder,
              errorBorder: Borders.outlineErrorInputBorder,
              focusedErrorBorder: Borders.outlineErrorInputBorder,
              // hintText: "Enter QTY",
              labelText: label,
              enabled: true,
              hintText: hint,
              //floatingLabelBehavior: FloatingLabelBehavior.always,
              labelStyle: BaseStyles.editTextTextStyle2,
              hintStyle: BaseStyles.editHintTextStyle,
            ),
            style: BaseStyles.editLabelTextStyle,
            validator: (value) => onValidate(value),
            value: value,
            onChanged: (text) => onChanged(text),
            items: list.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Container(margin: EdgeInsets.all(0),child: Text(value, style: BaseStyles.editTextTextStyle, overflow: TextOverflow.ellipsis,)),
              );
            }).toList(),
            ),
          );
      }
    );
  }

  getSearchDropField({value, hint, label, onChanged, context, items, inputFormatters, controller, index, onValidate, setter }){
    if(index == -1) {
      return Container(
        margin: Margins.baseMarginVertical,
        child: DropDownFieldCustom(
          context: context,
          onValidate: onValidate,
          value: value,
          items: items,
          setter: setter,
          //length: list.length,
          hintText: hint,
          labelText: label,
          onValueChanged: onChanged,
          inputFormatters: inputFormatters,
          labelStyle: BaseStyles.editTextTextStyle2,
          hintStyle: BaseStyles.editHintTextStyle,
          controller: controller,
          textStyle: BaseStyles.editTextTextStyle,
          //itemsVisibleInDropdown: items.length,
        ),
      );
    }
    return StreamBuilder(
      stream: Firestore.instance.collection('Lists').snapshots(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(),);
        }
        ////print('a');
        List <String> list = new List<String>();
        for(int i = 0; i < snapshot.data.documents.length; i++) {
          ////print('1');
          //List l = snapshot.hasData ? snapshot.data.documents[index]['list'] : [];
          if(snapshot.data.documents[i]['uid'] == index) {
            ////print('index : ' + index.toString());
            List l = snapshot.data.documents[i]['list'];
            for (int i = 0; i < l.length; i++) {
              list.add(l[i].toString());
            }
            break;
          }
          else {
            continue;
          }
          ////print(l);
        }
        ////print('a');
        ////print(list);
        return Container(
          margin: Margins.baseMarginVertical,
          child: DropDownFieldCustom(
            context: context,
            onValidate: onValidate,
            value: value,
            items: list,
            setter: setter,
            //length: list.length,
            hintText: hint,
            labelText: label,
            onValueChanged: onChanged,
            inputFormatters: inputFormatters,
            labelStyle: BaseStyles.editTextTextStyle2,
            hintStyle: BaseStyles.editHintTextStyle,
            controller: controller,
            textStyle: BaseStyles.editTextTextStyle,
            //itemsVisibleInDropdown: items.length,
          ),
        );
      }
    );
  }

  getMultiSelectDropdownTextField({hint, onSaved, onValidate, initial, title, data}) {
    return Container(
      margin: Margins.baseMarginVertical,
      child: MultiSelectFormFieldCustom(
        autovalidate: false,
        dataSource: data,
        textField: 'display',
        valueField: 'value',
        onSaved: onSaved,
        validator: onValidate,
        initialValue: initial,
        hintText: hint,
        titleText: title,

      ),
    );
  }

  getBaseTextField(hint,controller){
    return Container(
      margin: Margins.baseMarginVertical,
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.text,
        onChanged: (text){
          //store.isContactNumberEmpty = false;
        },

        style: BaseStyles.baseTextStyle,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.homeScreenBackground,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius:Radii.k4pxRadius,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius:Radii.k4pxRadius,
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: Radii.k4pxRadius,
          ),
          hintText: hint,
          hintStyle: BaseStyles.hintTextStyle,
        ),
      ),
    );
  }
  getDateFormatDay(date){
    return Jiffy.unix(date).format('dd/MM');
  }
  getDateFormat( date ) {
    return Jiffy.unix(date).format('dd/MM•HH:mm');
  }

  getDrawerTile({title, onTap, icon}) {
    return GestureDetector(
      child: Container(
        height: 40,
        margin: EdgeInsets.only(left: 15),
        child: Row(
          children: <Widget>[
            Flexible(
              flex: 2,
              child: icon
            ),
            SizedBox(width: 30,),
            Expanded(
              flex: 8,
              child: Text(title, style: BaseStyles.baseTextStyle,),
            )
          ],
        ),
      ),
      onTap: onTap,
    );
  }

  getEmptyState({Widget action, @required String errorMessage, @required errorTitle}) {
    errorMessage == null ? errorMessage = 'Seems like there are no values yet' : null;
    errorTitle == null ? errorTitle = 'No Readings Added' : null;
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          //getTabImage('assets/images/reading.png'),
          Text(errorTitle, style: BaseStyles.editTextTextStyle.copyWith(fontWeight: FontWeight.bold),),
          Text( errorMessage, style: BaseStyles.editLabelTextStyle,),
          action != null ? action : Container()
        ],
      ),
    );
  }



  var temp;
  bool appointmentEnabled;
  LocalStorage storage = new LocalStorage('cure_squad');

  getDraw({BuildContext context, User user}) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children:
        <Widget>[
          Container(
            height: 140.0,
            width: MediaQuery.of(context).size.width*0.75,
            child: PatientDrawer(context, user),
            decoration: BoxDecoration(
              color: AppColors.secondaryBackground,
            ),
          ),
          SizedBox(height: 10,),
          getDrawerTile(title: Titles.PROFILE, icon: Icon(Icons.person), onTap: () async {
            Navigator.push(context, MaterialPageRoute(builder: (context) => PatientProfileScreen(user: user)));
          }),
          Divider(
            thickness:0.3,
          ),
//          getDrawerTile(title: Titles.APPOINTMENTS, icon: CustomIcon.APPOINTMENTS, onTap: () {
//            temp = storage.getItem('patient_appointment');
//            appointmentEnabled = temp['appointment'];
//            if(appointmentEnabled) {
//              Navigator.push(context, MaterialPageRoute(
//                  builder: (context) => AppointmentScreen(patientUser: user,)));
//            }
//            else {
//              showDlg(message: ErrorMessages.APPOINTMENT_DISABLED, context: context);
//            }
//          }),
//          Divider(
//            thickness:0.3,
//          ),
//          getDrawerTile(title: Titles.SUBSCRIPTIONS, icon: CustomIcon.CARESERVICES, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentScreen(title: Titles.SUBSCRIPTIONS,)))),
//          Divider(
//            thickness:0.3,
//          ),
//          getDrawerTile(title: Titles.EMERGENCY, icon: CustomIcon.EMERGENCY, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EmergencyCall(user: user)))),
//          Divider(
//            thickness:0.3,
//          ),
          /*getDrawerTile(title: Titles.LABTESTS, icon: CustomIcon.LABTESTS, onTap: () => Navigator.pop(context)),
          Constants.IS_DOCTOR ? null : Divider(
            thickness:0.3,
          ),
          Constants.IS_DOCTOR ? null : getDrawerTile(title: Titles.PHARMACY, icon: CustomIcon.PHARMACY, onTap: () => Navigator.pop(context)),
          Constants.IS_DOCTOR ? null : Divider(
            thickness:0.3,
          ),*/
          /*getDrawerTile(title: Titles.CARESERVICES, icon: CustomIcon.CARESERVICES, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentScreen(title: Titles.CARESERVICES,)))),
          Divider(
            thickness:0.3,
          ),
          getDrawerTile(title: Titles.CARECENTER, icon: CustomIcon.CARECENTER, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentScreen(title: Titles.CARECENTER,)))),
          Divider(
            thickness:0.3,
          ),*/
          /*Constants.IS_DOCTOR ? null : getDrawerTile(title: Titles.FITNESS, icon: CustomIcon.FITNESS, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>Fitness()))),
          Constants.IS_DOCTOR ? null : Divider(
            thickness:0.3,
          ),
          Constants.IS_DOCTOR ? null : getDrawerTile(title: Titles.ASSISTANCE, icon: CustomIcon.ASSISTANCE, onTap: () => Navigator.pop(context)),
          Constants.IS_DOCTOR ? null : Divider(
            thickness:0.3,
          ),*/
          /*getDrawerTile(title: Titles.ABOUT_US, icon: CustomIcon.ABOUT, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => WebView(title: Titles.ABOUT_US, ext: '', url: Constants.ABOUT_US_URL,)))),
          Divider(
            thickness:0.3,
          ),
//          getDrawerTile(title: Titles.CONTACT_US, icon: CustomIcon.CONTACT, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>PickupLayout(scaffold: ContactUs())))),
//          Divider(
//            thickness:0.3,
//          ),
          getDrawerTile(title: Titles.TERMS_CONDITIONS, icon: CustomIcon.TERMS, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>WebView(title: Titles.TERMS_CONDITIONS, ext: '', url: Constants.TERMS_Conditions_URl,)))),
          Divider(
            thickness:0.3,
          ),
          getDrawerTile(title: Titles.PRIVACY, icon: CustomIcon.PRIVACY, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>WebView(title: Titles.PRIVACY, ext: '', url: Constants.PRIVACY_POLICY_URl,)))),
          Divider(
            thickness:0.3,
          ),*/
          getDrawerTile(title: Titles.LOGOUT, icon: Icon(Icons.power_settings_new), onTap: (){
            //Provider.of<FirebaseAnalytics>(context,listen: false).logEvent(name: FirebaseEvent.PAT_LOGOUT,parameters: user.toJson());
            FirebaseAuthService().signOut();
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SignUpLoginScreen()), (route) => false);
            //pushAndRemoveUntil(SignUpLoginScreen());
            //showToast(message: "logout successful");
          },),
          Divider(
            thickness:0.3,
          ),
        ],
      ),
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
  }



  getNointernetConnectionWidget({message}){
    return Container(
      child: Center(child: Column(children: <Widget>[
        Text(message, style: BaseStyles.baseTextStyle,),

      ],),),
    );
  }

  getNoHistoryFoundContainer({message}){
    return Container(
        margin: EdgeInsets.only(top: 50),
        child: Center(
            child: Text(
              message,
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: BaseStyles.baseTextStyle,
            )));
  }

  showDlg({String message, BuildContext context}) {
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
            title: Text(message),
            //content: Text("Dialog Content"),
          );
        }
    );
  }
}

enum FIELD_TYPE{
  NAME,
  name,
  PID,
  DID,
  PH_NUMBER,
  DOB,
  dob,
  GENDER,
  ADDRESS,
  ADHAR
}