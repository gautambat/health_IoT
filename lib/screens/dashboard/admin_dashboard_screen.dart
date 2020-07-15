
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:remote_care/constants/constants.dart';
import 'package:remote_care/database/firestore/user_dao.dart';
import 'package:remote_care/models/admin.dart';
import 'package:remote_care/models/user.dart';
import 'package:remote_care/screens/authentication/signup_login_screen.dart';
import 'package:remote_care/screens/dashboard/home_screen.dart';
import 'package:remote_care/screens/main/base_state.dart';
import 'package:remote_care/service/firebase_auth_service.dart';
import 'package:remote_care/store/dashboard/admin_dashboard_screen_store.dart';

class AdminDashBoardScreen extends StatefulWidget {
  final Admin userDetails;
  AdminDashBoardScreen({Key key,@required this.userDetails}) : super(key: key);

  @override
  _AdminDashBoardScreenState createState() {
    return _AdminDashBoardScreenState();
  }
}

class _AdminDashBoardScreenState extends BaseState<AdminDashBoardScreen> {
  var searchController =new TextEditingController();
  AdminDashBoardScreenStore store = new AdminDashBoardScreenStore();
  //var length;
  List<User> allUsersList = new List();
  List<User> searchedUserList = new List();
  bool noSearchedPatients = false;
  String uId;
  Admin userDetails;
  bool searched = false;
  var pushToken;
  var deviceId;

  bool noPatients =false;

  var temp;
  bool appointmentEnabled;
  LocalStorage storage = new LocalStorage('cure_squad');

  //bool isApproved=true;



  @override
  void initState() {
    super.initState();
    userDetails = widget.userDetails;
    uId = userDetails.uId;
    appointmentEnabled = storage.getItem('patient_appointment');
  }




  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  getAppBar() {
    return getAppBarWidgets(title:'Admin Dashboard', widgets:<Widget>[
      Container(
        padding: EdgeInsets.only(right: 10),
        child: GestureDetector(
          child: Icon(Icons.power_settings_new, color: AppColors.white,),
          onTap: () {
            FirebaseAuthService().signOut();
            pushAndRemoveUntil(SignUpLoginScreen());
            showToast(message: "logout successful");
          },
        ),
      )
    ],
        leftWidget: null
    );
  }
  @override
  withDefaultMargins() {
    return false;
  }

  @override
  getPageContainer() {
    return DoubleBackToCloseApp(
          snackBar: const SnackBar(
            content: Text(Strings.EXIT_BACK),
          ),
          child: Container(
              height:double.infinity,
              child:Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[



                  Expanded(flex:8,child: SingleChildScrollView(
                      physics: ScrollPhysics(),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Stack(children: <Widget>[

                              StreamBuilder(
                                  stream: UserDao().collectionStremUsers(),
                                  builder: (context,snapshot){
                                    if(snapshot.hasData){
;
                                      allUsersList = snapshot.data;
                                      print(allUsersList.toList());
                                      if(allUsersList.length>0)
                                      {

                                        return Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                          searchWidget(),
                                          Stack(children: <Widget>[
                                            !searched ? searchList(allUsersList) :


                                            searchedUserList.length>0?
                                            searchedList():noPatientsContainer()
                                          ],),
                                          Visibility(
                                              visible: (!searched &&!noPatients),
                                              child:Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[])),
                                        ],);
                                      }
                                      else{
                                        return noPatientsContainer();
                                      }


                                    }
                                    return Center(child: CircularProgressIndicator());
                                  }),


                            ]),

                          ])))
                ],))

    );
  }



  searchWidget() {
    return Container(
      child: new Padding(
        padding: const EdgeInsets.only(left:8.0,right: 8,top: 8),
        child: new Card(
          // margin:EdgeInsets.all(0.0),
          child: new ListTile(
            //leading: new Icon(Icons.search),
            title: new TextField(
              controller: searchController,
              decoration: new InputDecoration(
                  hintText: 'Search Patients', border: InputBorder.none),
              onChanged: (value){
                onSearchTextChanged(value);
              },
            ),
            trailing: new IconButton(
              icon: new Icon(Icons.search), onPressed: () {
              searched =false;
              searchController.clear();
              noSearchedPatients =false;
              searchedUserList = new List();
              //store.clear();
              // onSearchTextChanged('');
            },),
          ),
        ),
      ),
    );
  }


  searchedList() {
    return  Container(
        child: new Padding(
            padding: const EdgeInsets.only(top:8,left:8.0,right: 8,bottom: 8),
            child: new Card(
                child:  ListView.builder(

                  scrollDirection: Axis.vertical,
                  shrinkWrap:true,
                  itemCount: searchedUserList.length,
                  itemBuilder: (context, i) {
                    return  GestureDetector(
                        onTap: () {
                          selectedPatient(searchedUserList[i]);
                        },child:searchListItems(i,false,searchedUserList[i],searchedUserList));
                  },
                ))));
  }

  searchList(List<User> patientUsers) {
    return  Container(
      //height: MediaQuery.of(context).size.height,
      //height: 500,
        child: new Padding(
            padding: const EdgeInsets.only(top:0,left:8.0,right: 8,bottom: 0),
            child: new Card(
                child:  ListView.builder(
                  physics: ScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap:true,
                  itemCount: patientUsers.length,
                  itemBuilder: (context, i) {
                    return searchListItems(i,true,patientUsers[i],patientUsers);
                  },
                ))));
  }

  searchListItems(int i, bool searchList, patientUser, patientUsers) {
    return Container(
        child:Column(children: <Widget>[
          Container(
              margin: EdgeInsets.only(left: 10,top: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(flex: 7,child:
                  GestureDetector(
                      onTap: () {
                        selectedPatient(patientUsers[i]);
                      },child:
                  Row(children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: patientUser.imageUrl != null &&
                          patientUser.imageUrl.isNotEmpty ? CircleAvatar(
                          backgroundImage: NetworkImage(patientUser.imageUrl)

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
                    Expanded(flex:9,child: Container(
                        margin: EdgeInsets.only(left:10),
                        child:Text(patientUser.name,style: BaseStyles.baseTextStyle,),))
                  ],))),





                ],)),
          divider(i,searchList),

        ],));

  }


  divider(int i, bool searchList) {
    if(searchList)
      if(i!=allUsersList.length-1) return Divider(
        height: 0,
      );
      else return Container();
    else
    if(i!=searchedUserList.length-1) return Divider(
      height: 0,
    );
    else return Container();
  }

  Future<void> selectedPatient(patientUser) async {


  //if(await Utils.instance.isInternetConnected() ){
    store.showProgress(context);
    User selectedPatientUser;

    log(patientUser.uId);
    selectedPatientUser = await UserDao(uid: patientUser.uId).getUser();
    if(selectedPatientUser!=null)
    {
      store.hideProgress(context);
      push(HomeScreen(user: patientUser, currentIndex: 0,));






    }
    else{
      store.hideProgress(context);
      showToast(message: ErrorMessages.PATIENT_DETAILS_NOT_Found);
    }





  }

  void onSearchTextChanged(String value) {
    searchedUserList = new List();
    if(value.isNotEmpty){
      searched =true;
      for(int i=0;i<allUsersList.length;i++) {
        if (allUsersList[i].name.toLowerCase().contains(value.toLowerCase())) {
          searchedUserList.add(allUsersList[i]);
          noSearchedPatients =false;
        }
      }
      if(searchedUserList.length==0){
        noSearchedPatients =true;
      }
    }
    else
    {
      searched = false;
      noSearchedPatients =false;
      searchedUserList =new List();

    }
    setState(() {});
  }

  noPatientsContainer() {
    return  getEmptyState(errorMessage: ErrorMessages.No_READINGS_SUBTITLE, errorTitle: ErrorMessages.No_READINGS);
  }


}
