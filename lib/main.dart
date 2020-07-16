import 'dart:async';


import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localstorage/localstorage.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:remote_care/models/role.dart';
import 'package:remote_care/models/user.dart';
import 'package:remote_care/screens/authentication/auth_widget.dart';
import 'package:remote_care/service/firebase_auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants/constants.dart';
import 'screens/authentication/auth_widget_builder.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  Crashlytics.instance.enableInDevMode = true;

  // Pass all uncaught errors to Crashlytics.
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  enableLogging();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(

      statusBarColor: AppColors.secondaryBackground,/* set Status bar color in Android devices. */
      statusBarIconBrightness:Brightness.light,
      statusBarBrightness:Brightness.light

  ));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp
  ]).then((_) async{
    runZoned<Future<void>>(() async {
      runApp(CureSquadApp(authServiceBuilder: (_) => FirebaseAuthService()));
    // ignore: deprecated_member_use
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
  final LocalStorage storage = new LocalStorage('cure_squad');

  String role;

  var roleChecking;

  // ignore: non_constant_identifier_names
  bool is_doctor = false;

  int updateType;

  @override
  void initState() {
    
    roleValue();
    super.initState();
    //initFirebaseMessaging();
    
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
      ],
      child: AuthWidgetBuilder(
        builder: (BuildContext context, AsyncSnapshot<User> userSnapshot) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              localizationsDelegates: [
              ],
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
