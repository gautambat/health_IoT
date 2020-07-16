import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:remote_care/models/user.dart';
import 'package:remote_care/screens/dashboard/dashboard_screen.dart';
import 'package:remote_care/screens/main/base_state.dart';
import 'package:remote_care/widgets/default_margin.dart';

import 'dashboard_screen.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  final User user;
  HomeScreen({Key key,@required this.user}) : super(key: key);

  @override
  _HomeScreenState createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends BaseState<HomeScreen> {

  @override
  getAppBar() => getEmptyAppBar();

  @override
  withDefaultMargins() => false;

  @override
  getDrawer() {
    return super.getDrawer();
  }

  
  @override
  getPageContainer() {
    //final List<Widget> _children = [DashboardScreen(user: widget.user,),POMRScreen() , ERXScreen(), ReportScreen(), AssistanceScreen()];
    //final List<Widget> _children = [DashboardScreen(user: widget.user,), POMRScreen(widget.user,widget.user.uId), ERXScreen(patientUser: widget.user), ReportScreen(user: widget.user), AssistanceScreen(user: widget.user)];
        return DefaultMargin(padding: EdgeInsets.all(0),child: DashboardScreen(user: widget.user,));
  }
}