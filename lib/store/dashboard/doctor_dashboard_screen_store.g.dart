// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_dashboard_screen_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$DoctorDashBoardScreenStore on DoctorDashBoardScreenStoreBase, Store {
  final _$searchedPatientListAtom =
      Atom(name: 'DoctorDashBoardScreenStoreBase.searchedPatientList');

  @override
  List<String> get searchedPatientList {
    _$searchedPatientListAtom.reportRead();
    return super.searchedPatientList;
  }

  @override
  set searchedPatientList(List<String> value) {
    _$searchedPatientListAtom.reportWrite(value, super.searchedPatientList, () {
      super.searchedPatientList = value;
    });
  }

  final _$showMoreAtom = Atom(name: 'DoctorDashBoardScreenStoreBase.showMore');

  @override
  bool get showMore {
    _$showMoreAtom.reportRead();
    return super.showMore;
  }

  @override
  set showMore(bool value) {
    _$showMoreAtom.reportWrite(value, super.showMore, () {
      super.showMore = value;
    });
  }

  final _$isInternetAtom =
      Atom(name: 'DoctorDashBoardScreenStoreBase.isInternet');

  @override
  bool get isInternet {
    _$isInternetAtom.reportRead();
    return super.isInternet;
  }

  @override
  set isInternet(bool value) {
    _$isInternetAtom.reportWrite(value, super.isInternet, () {
      super.isInternet = value;
    });
  }

  final _$isViewedAtom = Atom(name: 'DoctorDashBoardScreenStoreBase.isViewed');

  @override
  bool get isViewed {
    _$isViewedAtom.reportRead();
    return super.isViewed;
  }

  @override
  set isViewed(bool value) {
    _$isViewedAtom.reportWrite(value, super.isViewed, () {
      super.isViewed = value;
    });
  }

  final _$DoctorDashBoardScreenStoreBaseActionController =
      ActionController(name: 'DoctorDashBoardScreenStoreBase');

  @override
  void onSearchTextChanged(String value, List<User> patientUsers) {
    final _$actionInfo =
        _$DoctorDashBoardScreenStoreBaseActionController.startAction(
            name: 'DoctorDashBoardScreenStoreBase.onSearchTextChanged');
    try {
      return super.onSearchTextChanged(value, patientUsers);
    } finally {
      _$DoctorDashBoardScreenStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clear() {
    final _$actionInfo = _$DoctorDashBoardScreenStoreBaseActionController
        .startAction(name: 'DoctorDashBoardScreenStoreBase.clear');
    try {
      return super.clear();
    } finally {
      _$DoctorDashBoardScreenStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
searchedPatientList: ${searchedPatientList},
showMore: ${showMore},
isInternet: ${isInternet},
isViewed: ${isViewed}
    ''';
  }
}
