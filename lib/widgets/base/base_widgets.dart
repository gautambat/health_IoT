import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:localstorage/localstorage.dart';
import 'package:remote_care/constants/constants.dart';
import 'package:remote_care/models/user.dart';
import 'package:remote_care/screens/authentication/signup_login_screen.dart';
import 'package:remote_care/screens/dashboard/pat_profile.dart';
import 'package:remote_care/service/firebase_auth_service.dart';

import '../drawer_patient.dart';

mixin BaseWidgets {

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
  PH_NUMBER,
  DOB,
  dob,
  GENDER,
}