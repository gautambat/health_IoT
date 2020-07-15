import 'package:mobx/mobx.dart';
import 'package:remote_care/models/user.dart';
import 'package:remote_care/utils/store_mixin.dart';

part 'admin_dashboard_screen_store.g.dart';

class AdminDashBoardScreenStore =  AdminDashBoardScreenStoreBase with _$AdminDashBoardScreenStore;

abstract class AdminDashBoardScreenStoreBase with Store,StoreMixin{
  @observable
  List<String> searchedPatientList = new List();
  @observable
  bool showMore =false;
  @observable
  bool isInternet =false;
  @observable
  bool isViewed = false;

@action
void onSearchTextChanged(String value, List<User> patientUsers) {
  searchedPatientList = new List();
    if(value.isNotEmpty){
      for(int i=0;i<patientUsers.length;i++) {
        if (patientUsers[i].name.contains(value)) {
          searchedPatientList.add(patientUsers[i].name);
        }
      }
    }
    else
    {
      searchedPatientList =new List();

    }

  }

@action
void clear(){
  searchedPatientList = new List();
}


}