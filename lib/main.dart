import 'dart:async';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localstorage/localstorage.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:remote_care/constants/values.dart';
import 'package:remote_care/models/role.dart';
import 'package:remote_care/models/user.dart';
import 'package:remote_care/screens/authentication/auth_widget.dart';
import 'package:remote_care/service/firebase_auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/authentication/auth_widget_builder.dart';
import 'package:in_app_update/in_app_update.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  // Set `enableInDevMode` to true to see reports while in debug mode
  // This is only to be used for confirming that reports are being
  // submitted as expected. It is not intended to be used for everyday
  // development.
  Crashlytics.instance.enableInDevMode = true;

  // Pass all uncaught errors to Crashlytics.
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  enableLogging();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(

      statusBarColor: AppColors.secondaryBackground,/* set Status bar color in Android devices. */
      statusBarIconBrightness:Brightness.light,
      statusBarBrightness:Brightness.light

//      statusBarIconBrightness: Utils.androidWhiteIcon,/* set Status bar icons color in Android devices.*/
//
//      statusBarBrightness: Utils.iOSWhiteDarkIcon)/* set Status bar icon color in iOS. */
  ));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp
  ]).then((_) async{
    runZoned<Future<void>>(() async {
      runApp(CureSquadApp(authServiceBuilder: (_) => FirebaseAuthService()));
    }, onError: Crashlytics.instance.recordError);
    //runApp(MyApp());
  });
}
enableLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((onData) {
    //print(' ${onData.time} : ${onData.level.name}: ${onData.message}');
  });
}


class CureSquadApp extends StatefulWidget {

  final FirebaseAuthService Function(BuildContext context) authServiceBuilder;

  CureSquadApp({Key key,this.authServiceBuilder}) : super(key: key);

  @override
  _CureSquadAppState createState() {
    return _CureSquadAppState();
  }
}

class _CureSquadAppState extends State<CureSquadApp> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final LocalStorage storage = new LocalStorage('cure_squad');

  String role;

  var roleChecking;

  bool is_doctor = false;

  int updateType;

  @override
  void initState() {
    
    roleValue();
    super.initState();
    //initFirebaseMessaging();
    
  }

checkForRemoteConfigUpdateType(){
  switch(updateType){
    case 0:
    //print("NO update required");
    break;
    case 1:
    InAppUpdate.startFlexibleUpdate().then((value){
        //print("FLEXIBLE UPDATE STARTED");
      }).catchError((e){
        //print("START FLEXIBLE UPDATE ERROR ===>>> $e");
      });
      break;
    case 2:
    InAppUpdate.performImmediateUpdate().catchError((e){
          //print("IMMEDIATE UPDATE ERROR =======>>>> $e");
        }).then((value){
          //print("IMMEDIATE UPDATE COMPLETE ");
        });
        break;
      default:
      //print("Invalid updateType value encountered");
      break;
  }
  
  
}

  savePushToken(token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('pushToken',token);
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAnalytics analytics = FirebaseAnalytics();
    final FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);
    // MultiProvider for top-level services that don't depend on any runtime values (e.g. uid)

    return MultiProvider(
      providers: [
        Provider<FirebaseAnalytics>.value(value: analytics),
        Provider<FirebaseAnalyticsObserver>.value(value: observer),
        Provider<FirebaseAuthService>(
          create: widget.authServiceBuilder,
        ),
//        Provider<Role>(
//          create: (_) => Role(role:"doctor"),
//        ),
      ],
      child: AuthWidgetBuilder(
        builder: (BuildContext context, AsyncSnapshot<User> userSnapshot) {
          return MaterialApp(
//              navigatorObservers: <NavigatorObserver>[observer],
              debugShowCheckedModeBanner: false,
              localizationsDelegates: [
//              const BackButtonTextDelegate(),
              ],
//              home: SignUpLoginScreen(isLogin: true),
//              home: PaymentScreen(),
              home: AuthWidget(userSnapshot: userSnapshot),
              theme: ThemeData(
                pageTransitionsTheme: PageTransitionsTheme(builders: {
                  TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                  TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                }),
                primaryColor: AppColors.primaryBackground,
                // accentColor: Colors.red,
                fontFamily: 'Manrope',
              ),

          );
        },
      ),
    );
  }

  roleValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var role= prefs.getString('role');
    Role value=new Role();
    value.role=role;
    storage.setItem('roleValue', value.toJSONEncodable());

  }
}
