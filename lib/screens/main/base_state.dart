/*
*  base_state.dart
*  Remote Care - Handover
*
*  Created by Yakub Pasha.
*  Copyright © 2018 Remote Care. All rights reserved.
    */
import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:remote_care/constants/borders.dart';
import 'package:remote_care/constants/colors.dart';
import 'package:remote_care/constants/styles.dart';
import 'package:remote_care/constants/values.dart';
import 'package:remote_care/widgets/base/base_widgets.dart';

import 'common_mixin.dart';


abstract class BaseState<T extends StatefulWidget> extends State<T> with AfterLayoutMixin,CommonMixin,BaseWidgets{
  ///analytics observer to monitor the screen changes
  FirebaseAnalyticsObserver observer;
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  ///abstract method to be override if we want to have any type of api calls or initialization services.
  init(){}

  pageTitle(){
    return Titles.APP_NAME;
  }
  canGoBack()=>false;
  ///method to get the appBar. optional
  getFloatingActionButton(){}
  ///method to get the main container of the page
  getPageContainer();
  //
  getBottomNavigation(){}

  getContext() => this.context;
  /// method to override the background color of the screen
  getBackgroundColor() => AppColors.primaryElement;

  withDefaultMargins() => true;

  getDrawer(){

  }

  openDraw(){
    _drawerKey.currentState.openDrawer();
  }

  ///method which will be called after all the widget bindings.
  @protected
  @override
  void afterFirstLayout(BuildContext context) {
    init();
//    observer = Provider.of<FirebaseAnalyticsObserver>(context,listen: false);
  }
 var context;
  int dum;

  final RefreshController _refreshController = RefreshController();

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      key: _drawerKey,
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: false,
      appBar: getAppBar(),
      bottomNavigationBar:getBottomNavigation(),
      floatingActionButton: getFloatingActionButton(),
      body: SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          //header: CircularProgressIndicator(),
          header: ClassicHeader(),
          //header: Platform.isAndroid ? MaterialClassicHeader() : ClassicHeader(),
          onRefresh: () async {
            await Future.delayed(Duration(seconds: 1));
            setState(() {
              dum = 1;
            });
            _refreshController.refreshCompleted();
          },
          child: SafeArea(child: getRootContainer())
      ),
      drawer: getDrawer(),
    );
  }
  getRootContainer(){
    return Container(
        color: getBackgroundColor(),
        constraints: BoxConstraints.expand(),
        padding: !withDefaultMargins()?EdgeInsets.all(0):Margins.baseMarginAllScreen,
        child:getPageContainer())??Align(alignment:Alignment.center,child:Text("Coming Soon.."));
  }
  getAppBar(){
    return AppBar(
        title: Text(pageTitle(),style: BaseStyles.appTitleTextStyle,),
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: pageTitle().isEmpty?0:0.5,
        backgroundColor: pageTitle().isEmpty?AppColors.secondaryBackground:AppColors.secondaryBackground,
        leading: canGoBack()?IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.white,),
          onPressed: () => Navigator.of(context).pop(),
        ):null);
  }
}