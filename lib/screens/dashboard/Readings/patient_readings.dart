import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:location/location.dart';
import 'package:remote_care/constants/constants.dart';
import 'package:remote_care/models/bp_record.dart';
import 'package:remote_care/models/pulse_record.dart';
import 'package:remote_care/models/spo2_record.dart';
import 'package:remote_care/models/temp_record.dart';
import 'package:remote_care/models/user.dart';
import 'package:remote_care/screens/main/base_state.dart';
import 'package:remote_care/store/dashboard/patient_readings_store.dart';
import 'package:remote_care/utils/utils.dart';
import 'package:remote_care/widgets/custom_button.dart';

class PatientReadingValuesScreen extends StatefulWidget {
  final User user;
  final int clickedValue;
  final List<BPRecord> bpRecords;
  final List<Spo2Record> spo2Records;
  final List<PulseRecord> pulseRecords;
  final List<TempRecord> tempRecords;

  PatientReadingValuesScreen({this.user,this.clickedValue,
    this.bpRecords,
    this.spo2Records,
    this.pulseRecords,
    this.tempRecords,
  });

  @override
  _PatientReadingValuesScreenState createState() {
    return _PatientReadingValuesScreenState();
  }
}

class _PatientReadingValuesScreenState
    extends BaseState<PatientReadingValuesScreen>
    with SingleTickerProviderStateMixin {

  var inputFormatters = [
    WhitelistingTextInputFormatter(RegexConst.numberRegExp),
  ];
  var tempFormatters = [
    WhitelistingTextInputFormatter(RegexConst.tempRegExp)

  ];
  PatientReadingsStore store = new PatientReadingsStore();





  String uid;
  int clickedValue;
  TabController _tabController;

  int selectedTab;

  String Imei="";
  User user;

  @override
  init() {

    store.typeValues(widget.clickedValue);
    return super.init();
  }
  @override
  void initState(){
    super.initState();
    //store.readingValues();

    store.setUser(widget.user);
//    _tabController = new TabController(vsync: this, length: 5);
//    _tabController.animation.addListener(_setActiveTabIndex);

    uid = widget.user.uId;
    clickedValue = widget.clickedValue;
    selectedTab = clickedValue;

  }

  @override
  getAppBar() {
    return getAppBarWidgets(title: Titles.READINGS, leftWidget: IconButton(
      icon: Icon(Icons.arrow_back, color: Colors.white,),
      onPressed: () {
        pop();
      },
    ),);
  }

  @override
  getPageContainer() {
    return tabContainer();
  }

  @override
  withDefaultMargins() {
    return false;
  }

  pulseTabBarView() {
    return Observer(
        builder: (_) => Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[

                      getTextField(label:Labels.PULSEHINT, controller:store.pulseController, type:TextInputType.phone,formatters:inputFormatters,onChange: (value){
                        store.onPulseChanged();
                      }),
                      Visibility(
                          visible: store.notEmptyFromDeviceSpo2,
                          child:Container(
                            margin: EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              color: AppColors.homeScreenBackground,
                              border: Border.fromBorderSide(
                                  Borders.primaryBorder),
                              borderRadius: Radii.k4pxRadius,
                            ),
                            height: 60.0,
                            child: getTextField(label:Labels.SPO2HINT, controller:store.spo2FromDeviceController, type:TextInputType.number,onChange: (value){
                              store.onSpo2FromDeviceChanged();
                            }),)),




                    ]),
        Flexible(child:Align(
          alignment: Alignment.bottomCenter,
          child:  CustomButton(
                          title: Titles.SAVE,
                          color: !store.notEmptyPulse
                              ? AppColors.accentText
                              : AppColors.secondaryBackground,
                          onPressed: () {
                            store.notEmptyPulse ? store.pulseClicked(uid,context) : "";
                            hideKeyboard();
                          },
                        )

                    )),
              ],
            )

    );
  }

  bpTabBarView() {
    return Observer(
        builder: (_) =>
            Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[

                Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[

                      getTextField(label:Labels.BPSYS, controller:store.bpController, type:TextInputType.number,formatters:inputFormatters,onChange: (value){
                        store.onBpChanged();
                      }),getTextField(label:Labels.BPDIA, controller:store.bpDiaController, type:TextInputType.number,formatters:inputFormatters,onChange: (value){
                        store.onBpChanged();
                      }),
                    ]),
        Flexible(child:Align(
            alignment: Alignment.bottomCenter,
            child: CustomButton(
                          title: Titles.SAVE,
                          color: (!store.emptyBp || !store.empty1Bp)? AppColors.accentText : AppColors
                              .secondaryBackground,
                          onPressed: () {
                            (store.emptyBp &&store.empty1Bp) ? store.bpSaveClicked(uid,context) : "";
                            hideKeyboard();
                          },
                        ))),
              ],
            ));
  }

  spO2TabBarView() {
    return
            Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[

                Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[

                      getTextField(label:Labels.SPO2HINT, controller:store.spo2Controller, type:TextInputType.number,formatters:inputFormatters,onChange: (value){
                        store.spo2Changed();
                      }),


                     Visibility(
                         visible: store.notEmptyFromDevicePulse,
                         child:Container(
                          margin: EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            color: AppColors.homeScreenBackground,
                            border: Border.fromBorderSide(
                                Borders.primaryBorder),
                            borderRadius: Radii.k4pxRadius,
                          ),
                          height: 60.0,
                          child: getTextField(label:Labels.PULSEHINT, controller:store.pulseFromDeviceController, type:TextInputType.number,onChange: (value){
                            store.onPulseFromDeviceChanged();
                          }),)),
                    ]),
        Flexible(child:Align(
            alignment: Alignment.bottomCenter,
            child: Observer(
                          builder: (_) => CustomButton(
                                title: Titles.SAVE,
                                color: !store.emptySpo2 ? AppColors.accentText : AppColors
                                    .secondaryBackground,
                                onPressed: () {
                                  store.emptySpo2 ? store.spo2Clicked(uid,context) : "";
                                  hideKeyboard();
                                },
                        )
    )
    ),
        )],
            );
  }

  tempTabBarView() {
    return Observer(
        builder: (_) =>
            Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
               Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[

                      getTextField(label:Labels.TEMPHINT, controller:store.tempController, type:TextInputType.number,formatters:tempFormatters,onChange: (value){
                        store.tempChanged();
                      })
                    ]),
        Flexible(child:Align(
            alignment: Alignment.bottomCenter,
            child: CustomButton(
                          title: Titles.SAVE,
                          color: !store.emptyTemp
                              ? AppColors.accentText
                              : AppColors.secondaryBackground,
                          onPressed: () {
                            store.emptyTemp ? store.tempClicked(uid,context) : "";
                            hideKeyboard();
                          },
                        ))),
              ],
            ));
  }

  getContentWidgets(){

    return <Widget>[
      bpTabBarView(),
      spO2TabBarView(),
      tempTabBarView(),
      pulseTabBarView(),



    ];
  }


  tabContainer() {
    return Column(children: <Widget>[

      Expanded(
          flex:0.5.toInt(),
          child:InkWell(
          onTap: () async {

            locationEnabled();




          },
          child: Container(
              color: AppColors.secondaryBackground,
              child: Container(
                  margin: EdgeInsets.all(10),
                  child: Row(children: <Widget>[
                    Expanded(flex: 9, child: Text(
                      "Take Reading With device",
                      textAlign: TextAlign.left,
                      style: BaseStyles.appTitleTextStyle,)),
                    Expanded(flex: 1, child:Icon(Icons.keyboard_arrow_right, color: Colors.white)
                    ),
                  ],))
          )
      )
      ),
      Expanded(flex:9.5.toInt(),child:Container(
          color: AppColors.secondaryBackground,
          child: Container(
            //margin: EdgeInsets.only(left: 10, right: 10),
              child:
              Container(

                  color: Colors.blue,
                  width: double.infinity,
                  child: DefaultTabController(
                    initialIndex: clickedValue,
                    length: 4,
                    child: Scaffold(
                        resizeToAvoidBottomInset: false,
                        resizeToAvoidBottomPadding: false,
                        appBar: PreferredSize(
                            preferredSize: Size.fromHeight(50.0),
                            // here the desired height
                            child: Container(
                                color: AppColors.secondaryBackground,
                                child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            topLeft: Radius.circular(10)),
                                        color: Colors.white,
                                        border: Border.all(color: Colors.white, width: 0.1)),
                                    //margin: EdgeInsets.only(left: 10, right: 10),
                                    child:Container(
                                        margin:EdgeInsets.only(left:10,right: 10),
                                        height: 50,
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width,
                                        color: AppColors.appBarColor,
                                        child: AppBar(
                                          backgroundColor: Colors.white,
                                          elevation: 0.0,
                                          bottom: TabBar(
                                            indicatorColor: Colors.blue,
                                            labelColor: Colors.blue,
                                            unselectedLabelColor: AppColors.primaryText,
                                            isScrollable: true,
                                            onTap: (index){
                                              selectedTab = index;
                                            },

                                            tabs: [

                                              Container(
                                                height: 40.0,
                                                child: new Tab(
                                                    child: Container(
                                                      child: Text(
                                                        TabTitle.BP,
                                                        textAlign: TextAlign.left,
                                                      ),
                                                    )),
                                              ),
                                              Container(
                                                height: 40.0,
                                                child: new Tab(
                                                    child: Container(
                                                      child: Text(
                                                        TabTitle.SPO2,
                                                        textAlign: TextAlign.left,
                                                      ),
                                                    )),
                                              ),
                                              Container(
                                                height: 40.0,
                                                child: new Tab(
                                                    child: Container(
                                                      child: Text(
                                                        TabTitle.TEMP,
                                                        textAlign: TextAlign.left,
                                                      ),
                                                    )
                                                ),
                                              ),
                                              Container(
                                                  height: 40.0,
                                                  child: new Tab(
                                                    child: Container(
                                                      child: Text(
                                                        TabTitle.PULSE,
                                                        textAlign: TextAlign.left,),
                                                    ),
                                                  )),

                                            ],
                                          ),
                                          //title: Text('Tabs Demo'),
                                        ))))),
                        body:Observer(
                          builder: (_) => Container(
                              margin:Margins.baseMarginHorizontalScreen,
                              child:TabBarView(
                            physics: NeverScrollableScrollPhysics(),
                            dragStartBehavior: DragStartBehavior.down,
                            // controller: _tabController,

                            children: getContentWidgets(),
                          )),
                        )),
                  ))))
      )],);
  }

  Future<void> locationEnabled() async {
    Location location = new Location();

    bool ss= await location.serviceEnabled();
    bool locationEnable = await location.requestService();
    var loc = await location.requestPermission();
    if(loc == PermissionStatus.granted){
       if(locationEnable)
        store.deviceValuesReading(selectedTab, context);
    }

  }


}
