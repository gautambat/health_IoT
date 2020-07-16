import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:health_iot/constants/constants.dart';
import 'package:health_iot/models/admin.dart';
import 'package:health_iot/screens/main/base_state.dart';
import 'package:health_iot/service/firestore_service.dart';
import 'package:health_iot/store/authentication/signup_login_store.dart';
import 'package:health_iot/widgets/custom_button.dart';

class SignUpLoginScreen extends StatefulWidget {
  final bool isLogin;

  SignUpLoginScreen({Key key, this.isLogin = true}) : super(key: key);

  @override
  _SignUpLoginScreenState createState() {
    return _SignUpLoginScreenState();
  }
}

class _SignUpLoginScreenState extends BaseState<SignUpLoginScreen> {



  SignUpLoginStore store = SignUpLoginStore();

  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  String value, selectedCountryCode;
  List<String> countryCodesList = ['+91', '+1', '+61', '+971', '+64'];

  bool _validate = false, loading = false;


  @override
  void initState() {
    store.isLoginScreen = this.widget.isLogin;
    setState(() {
      loading = true;
    });
    init();


    super.initState();
  }

  @override
  init() async {
    await getAdmins();
    setState(() {
      loading = false;
    });
  }

  @override
  getAppBar() {
    // TODO: implement getAppBar
    return getEmptyAppBar();
  }

  @override
  getBackgroundColor() => AppColors.homeScreenBackgroundWhite;

  @override
  withDefaultMargins() => true;

  @override
  getPageContainer() {
    return loading ? Center(child: CircularProgressIndicator(),) : Center(
      child: SingleChildScrollView(
        child: Form(
            key: _formKey,
            autovalidate: _validate,
            child: Observer(
              builder: (_) => Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Column(children: <Widget>[
                      store.isLoginScreen ? Container() : getNameWidget(),

                      loginHeading(),
                      roleContainer(),

                      phoneNumberContainer(),
                      // enterContactNumberWidget(),
                      getContinueOrLoginButton(),

                      //privacyPolicyContainer()

                      //getLoginSigUpLink()
                    ]),
                  )
                ],
              ),
            )),
      ),
    );
  }

  getLoginSigUpLink() {
    return Observer(
      builder: (_) => Container(
        margin: EdgeInsets.only(top: 20),
        child: InkWell(
          onTap: () {
            store.isLoginScreen = !store.isLoginScreen;
          },
          child: RichText(
            text: TextSpan(children: [
              TextSpan(
                text:
                    store.isLoginScreen ? Titles.NEW_HERE : Titles.HAVE_ACCOUNT,
                style: TextStyle(
                  color: AppColors.primaryText,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
              TextSpan(
                text: store.isLoginScreen ? Titles.SIGN_UP : Titles.LOGIN,
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }

  List<Admin> adminList = new List();

  Future getAdmins() async {
    adminList = await FirestoreService.instance.getDocumentsInCollection(path: 'admin', builder: (data) => Admin.fromMap(data));
  }

  getContinueOrLoginButton() {
    return CustomButton(
      title: store.isLoginScreen ? Titles.PROCEED : Titles.SIGNUP_BTN_CONTINUE,color: AppColors.secondaryBackground,
      onPressed: () {
        if (_formKey.currentState.validate()) {
          hideKeyboard();
          store.onContinueTapped(push,context,adminList);
        }

      },
    );
  }

  getNameWidget() {
    return Container(
      margin: Margins.baseMarginVertical,
//      padding: Margins.baseMarginAll,
      child: TextFormField(
        validator: (String str) {
          return str.isEmpty ? ErrorMessages.EMPTY_NAME : null;
        },
        keyboardType: TextInputType.text,
        onChanged: (text) {
          //store.isContactNumberEmpty = false;
        },
        style: BaseStyles.baseTextStyle,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.homeScreenBackground,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: Radii.k4pxRadius,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: Radii.k4pxRadius,
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: Radii.k4pxRadius,
          ),
          hintText: Hints.NAME,
          hintStyle: BaseStyles.hintTextStyle,
        ),
      ),
    );
  }

  Widget enterContactNumberWidget() {
    return Observer(
        builder: (_) => Column(
              children: <Widget>[
                Container(
                  padding: Margins.baseMarginVertical,
                  //margin: EdgeInsets.only(left: 100.0,right: 100.0,top: 15.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.homeScreenBackground,
                    border: Border.fromBorderSide(store.errorMessage.isNotEmpty
                        ? Borders.errorBorder
                        : Borders.noBorder),
                    borderRadius: Radii.k4pxRadius,
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(left: 10.0),
                          child: _dropDownButtonWidgetItems(),
                        ),
                        flex: 1,
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(left: 10.0),
                          child: TextFormField(
                            //controller: store.phoneNumberController,
                            keyboardType: TextInputType.number,
                            style: BaseStyles.baseTextStyle,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: Hints.PHONE_NUMBER,
                              hintStyle: BaseStyles.hintTextStyle,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(left: 10.0),
                  child: Text(
                    store.errorMessage,
                    style: BaseStyles.errorTextStyle,
                  ),
                ),
              ],
            ));
  }

  Widget _dropDownButtonWidgetItems() {
    return Container(
      child: DropdownButton<String>(
        value: selectedCountryCode,
        isExpanded: true,
        icon: Icon(
          Icons.keyboard_arrow_down,
          color: AppColors.secondaryText,
        ),
        iconSize: 24,
        elevation: 16,
        style: BaseStyles.baseTextStyle,
        hint: Text(
          '+91',
          overflow: TextOverflow.ellipsis,
        ),
        underline: Container(
          decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.transparent))),
        ),
        onChanged: (String newValue) {
          setState(() {
            selectedCountryCode = newValue;
          });
        },
        items: countryCodesList.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Material(
              child: Text(value, style: BaseStyles.baseTextStyle),
              color: Colors.transparent,
            ),
          );
        }).toList(),
      ),
    );
  }

  phoneNumberContainer() {
    return Observer(
        builder: (_) =>Column(
      children: <Widget>[
        Container(
//            decoration: BoxDecoration(
//              color: AppColors.homeScreenBackground,
//              border: Border.fromBorderSide(store.errorMessage.isNotEmpty
//                  ? Borders.errorBorder
//                  : ""),
//              borderRadius: Radii.k4pxRadius,
//            ),
            margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
            //height: 60.0,
//        decoration: BoxDecoration(
//          color: AppColors.primaryElement,
//          border: Border.all(width: 0.2),
//          borderRadius: BorderRadius.all(Radius.circular(6)),
//        ),
            child: Container(
              //color: AppColors.white,
              //height: 50.0,
              //margin: EdgeInsets.only(left: 10.0),
              child: TextField(
                controller: store.phoneNumberController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10),
                  WhitelistingTextInputFormatter.digitsOnly,
                ],
                onChanged: (text) {
                  store.errorMessage ="";
                },
                decoration: InputDecoration(
//          contentPadding: EdgeInsets.zero,
                  filled: true,
//          helperText: label,
                  fillColor: AppColors.primaryBackground,
                  enabledBorder: Borders.outlineInputBorder,
                  focusedBorder: Borders.outlineInputBorder,
                  errorBorder: Borders.outlineErrorInputBorder,
                  focusedErrorBorder: Borders.outlineErrorInputBorder,
                  hintText: "Phone Number",
                  labelText: "Phone Number",
                  enabled: true,
                  //suffixIcon: suffixicon,
                  alignLabelWithHint: true,


                  //floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelStyle: BaseStyles.editLabelTextStyle,
                  hintStyle: BaseStyles.editHintTextStyle,
                ),
              ),
            )),
        Container(
          alignment: Alignment.topLeft,
          margin: EdgeInsets.only(top:5,bottom:5,left: 10.0),
          child: Text(
            store.errorMessage,
            style: BaseStyles.errorTextStyle,
          ),
        ),
      ],
    ));
  }

  loginHeading() {
    return  Column(children: <Widget>[
    Container(child:Text(
      Titles.REMOTE_LOGIN,
        textAlign: TextAlign.left,
        style: BaseStyles.loginHeadingTextStyle,
    )),
      Container(
          margin: EdgeInsets.all(10),
          child:Text(
        Titles.SELECT_REMOTE_ROLE,
        textAlign: TextAlign.left,
        style: BaseStyles.loginSubHeadingTextStyle,
      )),
    ],)
      ;
  }

  roleContainer() {
   return Container(
     margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
      child:
      FormField<String>(
        initialValue: "Enter",
        builder: (FormFieldState<String> state) {
          return InputDecorator(

            decoration: InputDecoration(
//          contentPadding: EdgeInsets.zero,
              filled: true,
//          helperText: label,
              fillColor: AppColors.primaryBackground,
              enabledBorder: Borders.outlineInputBorder,
              focusedBorder: Borders.outlineInputBorder,
              errorBorder: Borders.outlineErrorInputBorder,
              focusedErrorBorder: Borders.outlineErrorInputBorder,
              hintText: "Login as?",
              labelText: "Role",
              enabled: true,

              //floatingLabelBehavior: FloatingLabelBehavior.always,
              labelStyle: BaseStyles.editLabelTextStyle,
              hintStyle: BaseStyles.editHintTextStyle,
            ),



//          InputDecoration(
//              labelStyle: BaseStyles.editLabelTextStyle,
//              errorStyle: TextStyle(color: Colors.redAccent, fontSize: 16.0),
//              hintText: 'Enter QTY',
//              labelText: "QTY",
//              prefixText: "Enter QTY",
//              border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
            isEmpty: store.currentSelectedRole == '',
            child:Observer(
                builder: (_) => DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    hint: Text("Login as?"),
                    value: store.currentSelectedRole,
                    isDense: true,
                    onChanged: (String newValue) {

                      store.roleValueChanged(newValue);

                    },
                    items: store.roleList.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                )),
          );
        },
      ),);
  }


}
