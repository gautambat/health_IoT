import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:localstorage/localstorage.dart';
import 'package:remote_care/constants/constants.dart';
import 'package:remote_care/database/firestore/record_dao.dart';
import 'package:remote_care/database/firestore/user_dao.dart';
import 'package:remote_care/models/bp_record.dart';
import 'package:remote_care/models/pulse_record.dart';
import 'package:remote_care/models/spo2_record.dart';
import 'package:remote_care/models/temp_record.dart';
import 'package:remote_care/models/user.dart';
import 'package:remote_care/screens/dashboard/Readings/patient_readings.dart';
import 'package:remote_care/screens/main/base_state.dart';
import 'package:remote_care/store/dashboard/doctor_patient_view_screen_store.dart';
import 'package:remote_care/widgets/default_margin.dart';

class DashboardScreen extends StatefulWidget {
  final User user;

  DashboardScreen({Key key, @required this.user}) : super(key: key);

  @override
  _DashboardScreenState createState() {
    return _DashboardScreenState();
  }
}

class _DashboardScreenState extends BaseState<DashboardScreen> {
  DoctorPatientViewScreenStore store = new DoctorPatientViewScreenStore();

  List<User> userRecords;

  List<BPRecord> bpRecords = new List();
  List<Spo2Record> spo2Records = new List();
  List<PulseRecord> pulseRecords = new List();
  List<TempRecord> tempRecords = new List();
  LocalStorage storage = new LocalStorage('cure_squad');
  User user;
  String differenceInYears="";
  var pushToken,deviceId;
  String result = '';
  //Map<DataType, List<FitData>> results = Map();
  bool permissions;
  bool permissionsLocal;

  //Future<List<Doctor>> doctors;

  var role, roleValue;

  @override
  void initState() {
    super.initState();
    user = widget.user;
    roleValue = storage.getItem('roleValue');
    role = roleValue['role'];
    //doctors = DoctorDao().getDoctors();

    initPatient();
  }

  initPatient() async {
    pushToken = await getPushToken();
    //deviceId = await getDeviceId();
    OtherInfoBean otherInfo = OtherInfoBean();
    otherInfo
      ..pushToken = pushToken
      ..deviceId = deviceId;
    user.otherInfo = otherInfo;
    //log("User Details:bnefore write " + user.toJson().toString());
    await UserDao(uid: user.uId)
        .createUser(user)
        .then((value) => log("Successfully updated"));
  }

  @override
  getDrawer() {
    return getDraw(context: context, user: user);

  }


  @override
  getAppBar() {
    return role == Constants.PATIENT ? getAppBarWidgets(
        title: Titles.DASHBOARD,
        widgets: <Widget>[

        ],
        leftWidget: InkWell(
            onTap: () {
              openDraw();
            },
            child: Icon(Icons.menu, color: AppColors.white,))) :
    AppBar(
        leading: InkWell(
            onTap: () {
              pop();
            },
            child: Icon(Icons.arrow_back, color: AppColors.white,)
        ),
        centerTitle: false,
        elevation: 0.5,
        backgroundColor: AppColors.secondaryBackground,
        title: barTitle(),
        actions: <Widget>[

        ]
    );
  }

  @override
  withDefaultMargins() {
    return false;
  }

  Widget getBpRow(List<BPRecord> data) {
    List<Widget> widgets = List<Widget>();

    store.getValuesBp(data, widgets);
    Column row = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: widgets),
      ],
    );
    return row;
  }

  Widget getSpo2Row(List<Spo2Record> data) {
    List<Widget> widgets = List<Widget>();

    store.getValuesSpo2(data, widgets);
    Column row = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: widgets),
      ],
    );
    return row;
  }

  Widget getTempRow(List<TempRecord> data) {
    List<Widget> widgets = List<Widget>();

    store.getValuesTemp(data, widgets);
    Column row = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: widgets),
      ],
    );
    return row;
  }

  Widget getPulseRow(List<PulseRecord> data) {
    List<Widget> widgets = List<Widget>();

    store.getValuesPulse(data, widgets);

    Column row = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: widgets),
      ],
    );
    return row;
  }

  getHeader(title) {
    return Container(
      margin: EdgeInsets.only(left: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            title,
            textAlign: TextAlign.left,
            style: BaseStyles.baseTextStyle,
          ),
        ],
      ),
    );
  }

  barTitle() {
    store.dobYears(user);

    return Container(child:Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[

        Flexible(
          flex: 2,
          child: user.imageUrl != null &&
              user.imageUrl.isNotEmpty ? CircleAvatar(
              backgroundImage: NetworkImage(user.imageUrl)

          ) : Container(
            height: 35,
            width: 35,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue[100]
            ),
            child: Icon(Icons.person, color: AppColors.iconColor,),
          ),
        ),

        Expanded(flex: 7,child:Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(top:5.0,left: 5,right: 5,bottom: 3),
                child: Text(
                    user.name!=null?user.name:"-",
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      color: AppColors.white,//Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      height: 1.625,
                    )
                )),


            Row(children: <Widget>[
              Container(
                  margin: EdgeInsets.only(left:5.0,bottom: 3.0,right: 5.0),
                  child: Text(

                      (user.gender!=null?user.gender[0]:"-")+"/"+store.differenceInYears,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style:  TextStyle(
                        color: AppColors.white,//Color.fromARGB(255, 255, 255, 255),
                        fontWeight: FontWeight.w500,
                        fontSize: 10,
                        height: 1.625,
                      )
                  )),
              Icon(Icons.brightness_1, color: Colors.white, size: 5),
              Container(
                margin: EdgeInsets.only(
                    left: 5.0, bottom: 5.0, right: 5.0),
                child: Text(
                    user.weight != null ? '${user.weight} kg' : '- kg',
                    textAlign: TextAlign.left,
                    style:  TextStyle(
                      color: AppColors.white,//Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.w500,
                      fontSize: 10,
                      height: 1.625,
                    )
                ),
              ),
              Icon(Icons.brightness_1, color: Colors.white, size: 5),
              Container(
                margin: EdgeInsets.only(
                    left: 5.0, bottom: 5.0, right: 5.0),
                child: Text(
                    user.height != null ? '${user.height} cm' : '- cm',
                    textAlign: TextAlign.left,
                    style:  TextStyle(
                      color: AppColors.white,//Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.w500,
                      fontSize: 10,
                      height: 1.625,
                    )
                ),
              ),


            ],)

            ,
          ],))


      ],));
  }

  bool loading = false;

  @override
  getPageContainer() {
//    user = Provider.of<User>(context,listen: false);
    userRecords = [user];
    userDOB();
    // please use the below streams to build the UI after the snaspshot data
    return loading ? Center(child: CircularProgressIndicator(),) : DoubleBackToCloseApp(
        snackBar: const SnackBar(
          content: Text('Tap back again to leave'),
        ),
        child: DefaultMargin(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: SingleChildScrollView(
              physics: ScrollPhysics(),

              child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              role == Constants.PATIENT ? patientDetailsLayout(userRecords) : Container(),
              Flexible(
                fit: FlexFit.loose,
                child: Container(
                  width: double.infinity,
                  padding: Margins.baseMarginVertical,
                  color: Colors.white,
                  child: StreamBuilder(
                      stream: RecordDao(uid: user.uId).collectionStreamBP(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          bpRecords = snapshot.data;

//                            return bpRecordContainer(bpRecords);

                        }
                        return bpRecordContainer(bpRecords);
                      }),
                ),
              ),
              Container(color: AppColors.white, child: Divider()),
              Flexible(
                fit: FlexFit.loose,
                child: Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: Margins.baseMarginVertical,
                  child: StreamBuilder(
                      stream: RecordDao(uid: user.uId).collectionStreamSpo2(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          spo2Records = snapshot.data;
                          // return spo2RecordContainer(spo2Records);

                        }
                        return spo2RecordContainer(spo2Records);
                      }),
                ),
              ),
              Container(color: AppColors.white, child: Divider()),
              Flexible(
                fit: FlexFit.loose,
                child: Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: Margins.baseMarginVertical,
                  child: StreamBuilder(
                      stream: RecordDao(uid: user.uId).collectionStreamTemp(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          tempRecords = snapshot.data;

//                            return tempRecordContainer(tempRecords);

                        }
                        return tempRecordContainer(tempRecords);
                      }),
                ),
              ),
              Container(color: AppColors.white, child: Divider()),
              Flexible(
                fit: FlexFit.loose,
                child: Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: EdgeInsets.only(bottom: 20, top: 8),
                  //margin: EdgeInsets.only(bottom: 10),
                  child: StreamBuilder(
                      stream: RecordDao(uid: user.uId).collectionStreamPulse(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          pulseRecords = snapshot.data;
                        }
                        return pulseRecordContainer(pulseRecords);
                      }),
                ),
              ),


            ],
          )),
        ));
  }

  patientDetailsLayout(List<User> userRecords) {
    return Container(
        padding: EdgeInsets.only(right: 10),
        color: AppColors.ternaryBackground,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
                flex: 9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(
                            top: 5.0, left: 10, right: 5, bottom: 3),
                        child: Text(
                            userRecords.length > 0
                                ? userRecords[0].name != null
                                    ? userRecords[0].name
                                    : "-"
                                : "-",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: AppColors.white,
                              //Color.fromARGB(255, 255, 255, 255),
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              height: 1.625,
                            ))),
                    Row(
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.only(
                                left: 10.0, bottom: 5.0, right: 5.0),
                            child: Text(
                                userRecords.length > 0
                                    ? userRecords[0].gender != null
                                        ? userRecords[0].gender[0] +
                                            '/$differenceInYears'
                                        : "-"
                                    : "-",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: AppColors.white,
                                  //Color.fromARGB(255, 255, 255, 255),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  height: 1.625,
                                ))),
                        Icon(Icons.brightness_1, color: Colors.white, size: 5),
                        Container(
                          margin: EdgeInsets.only(
                              left: 5.0, bottom: 5.0, right: 5.0),
                          child: Text(
                            userRecords.length > 0 && userRecords[0].weight != null ? '${userRecords[0].weight} kg' : '- kg',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: AppColors.white,
                              //Color.fromARGB(255, 255, 255, 255),
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                              height: 1.625,
                            )
                          ),
                        ),
                        Icon(Icons.brightness_1, color: Colors.white, size: 5),
                        Container(
                          margin: EdgeInsets.only(
                              left: 5.0, bottom: 5.0, right: 5.0),
                          child: Text(
                              userRecords.length > 0 && userRecords[0].height != null ? '${userRecords[0].height} cm' : '- cm',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: AppColors.white,
                                //Color.fromARGB(255, 255, 255, 255),
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                height: 1.625,
                              )
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
            Flexible(
              flex: 1,
              child: userRecords.length > 0 && userRecords[0].imageUrl != null &&
                  userRecords[0].imageUrl.isNotEmpty ? CircleAvatar(
                backgroundImage: NetworkImage(userRecords[0].imageUrl)

              ) : Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue[100]
                ),
                child: Icon(Icons.person, color: AppColors.iconColor,),
              ),
            ),
          ],
        ));
  }


  void recordImageClicked(
      {@required int clickedValue}) {
    push(PatientReadingValuesScreen(
      user: user,
      clickedValue: clickedValue,
      bpRecords: bpRecords,
      spo2Records: spo2Records,
      pulseRecords: pulseRecords,
      tempRecords: tempRecords,
    ));
  }

  void userDOB() {
    if (userRecords[0].dob != null) {
      final DateTime dobTimeStamp = DateTime.fromMillisecondsSinceEpoch(
          userRecords[0].dob.millisecondsSinceEpoch);

      //String birthdayString = Jiffy.unix(userRecords[0].dob.millisecondsSinceEpoch).format('dd/MM•HH.mm');
      var presntTime = Timestamp.now();
      final DateTime timeStampNow = DateTime.fromMillisecondsSinceEpoch(
          presntTime.millisecondsSinceEpoch);

      Duration dur = timeStampNow.difference(dobTimeStamp);
      differenceInYears = (dur.inDays / 365).floor().toString();
      log(differenceInYears);
      log(differenceInYears + "Date of birth");
    }
  }

  bpRecordContainer(List<BPRecord> bpRecords) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(flex: 2, child: getHeader("Bp")),
        Expanded(flex: 7.toInt(), child: getBpRow(bpRecords)),
        // Expanded(flex:0.3.toInt(),child:VerticalDivider()),
        role == Constants.PATIENT ? Expanded(
            flex: 1,
            child: GestureDetector(
                onTap: () {
                  recordImageClicked(clickedValue: 0);
                },
                child: Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Icon(Icons.add_circle_outline, color: AppColors.activeIconColor,)
                ))) : Expanded(flex: 0, child: Container(),)
      ],
    );
  }

  spo2RecordContainer(List<Spo2Record> spo2Records) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(flex: 2, child: getHeader("Spo2")),
        Expanded(flex: 7, child: getSpo2Row(spo2Records)),
        role == Constants.PATIENT ? Expanded(
            flex: 1,
            child: GestureDetector(
                onTap: () {
                  recordImageClicked(clickedValue: 1);
                },
                child: Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Icon(Icons.add_circle_outline, color: AppColors.activeIconColor,)
                ))) : Expanded(flex: 0, child: Container(),)
      ],
    );
  }

  tempRecordContainer(List<TempRecord> tempRecords) {
    return Row(
      children: <Widget>[
        Expanded(flex: 2, child: getHeader("Temp")),
        Expanded(flex: 7, child: getTempRow(tempRecords)),
        role == Constants.PATIENT ? Expanded(
            flex: 1,
            child: GestureDetector(
                onTap: () {
                  recordImageClicked(clickedValue: 2);
                },
                child: Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Icon(Icons.add_circle_outline, color: AppColors.activeIconColor,)
                ))) : Expanded(flex: 0, child: Container(),)
      ],
    );
  }

  pulseRecordContainer(List<PulseRecord> pulseRecords) {
    return Row(
      children: <Widget>[
        Expanded(flex: 2, child: getHeader("Pulse")),
        Expanded(flex: 7, child: getPulseRow(pulseRecords)),
        role == Constants.PATIENT ? Expanded(
            flex: 1,
            child: GestureDetector(
                onTap: () {
                  recordImageClicked(clickedValue: 3);
                },
                child: Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Icon(Icons.add_circle_outline, color: AppColors.activeIconColor,)
                ))) : Expanded(flex: 0, child: Container(),)
      ],
    );
  }


}
