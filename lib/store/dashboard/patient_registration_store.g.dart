// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_registration_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PatientRegistrationStore on PatientRegistrationStoreBase, Store {
  final _$isSelectedPageAtom =
      Atom(name: 'PatientRegistrationStoreBase.isSelectedPage');

  @override
  bool get isSelectedPage {
    _$isSelectedPageAtom.reportRead();
    return super.isSelectedPage;
  }

  @override
  set isSelectedPage(bool value) {
    _$isSelectedPageAtom.reportWrite(value, super.isSelectedPage, () {
      super.isSelectedPage = value;
    });
  }

  final _$editAtom = Atom(name: 'PatientRegistrationStoreBase.edit');

  @override
  bool get edit {
    _$editAtom.reportRead();
    return super.edit;
  }

  @override
  set edit(bool value) {
    _$editAtom.reportWrite(value, super.edit, () {
      super.edit = value;
    });
  }

  final _$isPatientDetailsSavedAtom =
      Atom(name: 'PatientRegistrationStoreBase.isPatientDetailsSaved');

  @override
  bool get isPatientDetailsSaved {
    _$isPatientDetailsSavedAtom.reportRead();
    return super.isPatientDetailsSaved;
  }

  @override
  set isPatientDetailsSaved(bool value) {
    _$isPatientDetailsSavedAtom.reportWrite(value, super.isPatientDetailsSaved,
        () {
      super.isPatientDetailsSaved = value;
    });
  }

  final _$selectedGenderAtom =
      Atom(name: 'PatientRegistrationStoreBase.selectedGender');

  @override
  int get selectedGender {
    _$selectedGenderAtom.reportRead();
    return super.selectedGender;
  }

  @override
  set selectedGender(int value) {
    _$selectedGenderAtom.reportWrite(value, super.selectedGender, () {
      super.selectedGender = value;
    });
  }

  final _$dateOfBirthTextAtom =
      Atom(name: 'PatientRegistrationStoreBase.dateOfBirthText');

  @override
  String get dateOfBirthText {
    _$dateOfBirthTextAtom.reportRead();
    return super.dateOfBirthText;
  }

  @override
  set dateOfBirthText(String value) {
    _$dateOfBirthTextAtom.reportWrite(value, super.dateOfBirthText, () {
      super.dateOfBirthText = value;
    });
  }

  final _$dateAtom = Atom(name: 'PatientRegistrationStoreBase.date');

  @override
  dynamic get date {
    _$dateAtom.reportRead();
    return super.date;
  }

  @override
  set date(dynamic value) {
    _$dateAtom.reportWrite(value, super.date, () {
      super.date = value;
    });
  }

  final _$dateOfBirthAtom =
      Atom(name: 'PatientRegistrationStoreBase.dateOfBirth');

  @override
  Timestamp get dateOfBirth {
    _$dateOfBirthAtom.reportRead();
    return super.dateOfBirth;
  }

  @override
  set dateOfBirth(Timestamp value) {
    _$dateOfBirthAtom.reportWrite(value, super.dateOfBirth, () {
      super.dateOfBirth = value;
    });
  }

  final _$imageAtom = Atom(name: 'PatientRegistrationStoreBase.image');

  @override
  File get image {
    _$imageAtom.reportRead();
    return super.image;
  }

  @override
  set image(File value) {
    _$imageAtom.reportWrite(value, super.image, () {
      super.image = value;
    });
  }

  final _$imageUrlAtom = Atom(name: 'PatientRegistrationStoreBase.imageUrl');

  @override
  String get imageUrl {
    _$imageUrlAtom.reportRead();
    return super.imageUrl;
  }

  @override
  set imageUrl(String value) {
    _$imageUrlAtom.reportWrite(value, super.imageUrl, () {
      super.imageUrl = value;
    });
  }

  final _$cityAtom = Atom(name: 'PatientRegistrationStoreBase.city');

  @override
  String get city {
    _$cityAtom.reportRead();
    return super.city;
  }

  @override
  set city(String value) {
    _$cityAtom.reportWrite(value, super.city, () {
      super.city = value;
    });
  }

  final _$stateAtom = Atom(name: 'PatientRegistrationStoreBase.state');

  @override
  String get state {
    _$stateAtom.reportRead();
    return super.state;
  }

  @override
  set state(String value) {
    _$stateAtom.reportWrite(value, super.state, () {
      super.state = value;
    });
  }

  final _$relationAtom = Atom(name: 'PatientRegistrationStoreBase.relation');

  @override
  String get relation {
    _$relationAtom.reportRead();
    return super.relation;
  }

  @override
  set relation(String value) {
    _$relationAtom.reportWrite(value, super.relation, () {
      super.relation = value;
    });
  }

  final _$pidAtom = Atom(name: 'PatientRegistrationStoreBase.pid');

  @override
  String get pid {
    _$pidAtom.reportRead();
    return super.pid;
  }

  @override
  set pid(String value) {
    _$pidAtom.reportWrite(value, super.pid, () {
      super.pid = value;
    });
  }

  final _$firstNameControllerAtom =
      Atom(name: 'PatientRegistrationStoreBase.firstNameController');

  @override
  TextEditingController get firstNameController {
    _$firstNameControllerAtom.reportRead();
    return super.firstNameController;
  }

  @override
  set firstNameController(TextEditingController value) {
    _$firstNameControllerAtom.reportWrite(value, super.firstNameController, () {
      super.firstNameController = value;
    });
  }

  final _$updatePersonalDataAsyncAction =
      AsyncAction('PatientRegistrationStoreBase.updatePersonalData');

  @override
  Future updatePersonalData(User currentUser, dynamic context, dynamic push) {
    return _$updatePersonalDataAsyncAction
        .run(() => super.updatePersonalData(currentUser, context, push));
  }

  final _$savePersonalDataAsyncAction =
      AsyncAction('PatientRegistrationStoreBase.savePersonalData');

  @override
  Future savePersonalData(User currentUser, dynamic context, dynamic push) {
    return _$savePersonalDataAsyncAction
        .run(() => super.savePersonalData(currentUser, context, push));
  }

  final _$getImageAsyncAction =
      AsyncAction('PatientRegistrationStoreBase.getImage');

  @override
  Future<dynamic> getImage(String uid, BuildContext context) {
    return _$getImageAsyncAction.run(() => super.getImage(uid, context));
  }

  final _$compressImageAsyncAction =
      AsyncAction('PatientRegistrationStoreBase.compressImage');

  @override
  Future<File> compressImage(File file) {
    return _$compressImageAsyncAction.run(() => super.compressImage(file));
  }

  final _$uploadUserImagesAsyncAction =
      AsyncAction('PatientRegistrationStoreBase.uploadUserImages');

  @override
  Future<dynamic> uploadUserImages(
      File imageFile, String userID, dynamic context) {
    return _$uploadUserImagesAsyncAction
        .run(() => super.uploadUserImages(imageFile, userID, context));
  }

  @override
  String toString() {
    return '''
isSelectedPage: ${isSelectedPage},
edit: ${edit},
isPatientDetailsSaved: ${isPatientDetailsSaved},
selectedGender: ${selectedGender},
dateOfBirthText: ${dateOfBirthText},
date: ${date},
dateOfBirth: ${dateOfBirth},
image: ${image},
imageUrl: ${imageUrl},
city: ${city},
state: ${state},
relation: ${relation},
pid: ${pid},
firstNameController: ${firstNameController}
    ''';
  }
}
