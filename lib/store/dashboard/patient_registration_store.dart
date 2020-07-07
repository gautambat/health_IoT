


import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:remote_care/constants/constants.dart';
import 'package:remote_care/database/firestore/user_dao.dart';
import 'package:remote_care/models/user.dart';
import 'package:remote_care/screens/dashboard/home_screen.dart';
import 'package:remote_care/utils/store_mixin.dart';
import 'package:remote_care/utils/utils.dart';
import 'package:path_provider/path_provider.dart';

import '../../database/firestore/user_dao.dart';

part 'patient_registration_store.g.dart';

class PatientRegistrationStore =  PatientRegistrationStoreBase with _$PatientRegistrationStore;


abstract class PatientRegistrationStoreBase with Store, StoreMixin {

  @observable
  bool isSelectedPage = true;

  @observable
  bool edit = false;

  @observable
  bool isPatientDetailsSaved = false;

  @observable
  int selectedGender = 0;

  @observable
  String dateOfBirthText = '';

  @observable
  var date;

  @observable
  Timestamp dateOfBirth;

  @observable
  File image;

  @observable
  String imageUrl = '';

  @observable
  String city;

  @observable
  String state;

  @observable
  String relation;

  @observable
  String pid = '';

  @observable
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController patientIDController = TextEditingController();
  TextEditingController doctorNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController aadharNumberController = TextEditingController();



  TextEditingController insuranceNameController = TextEditingController();
  TextEditingController membershipController = TextEditingController();
  TextEditingController contactController = TextEditingController();


  TextEditingController emergencyNameController = TextEditingController();
  TextEditingController emergencyPhoneController = TextEditingController();
  TextEditingController relationshipController = TextEditingController();



  @action
  updatePersonalData(User currentUser, context, push) async {
    if(await Utils.instance.isInternetConnected() == true) {
      currentUser
        ..firstName = firstNameController.text
        ..lastName = lastNameController.text
        ..name = firstNameController.text + ' ' + lastNameController.text
        ..imageUrl = imageUrl
        ..updatedOn = Timestamp.now()
        ..weight = num.parse(weightController.text)
        ..height = num.parse(heightController.text)
        ..gender = getSelectedGender(selectedGender);

      if(dateOfBirth != null) {
        currentUser
          ..dob = dateOfBirth
          ..date = dateOfBirthController.text;
      }



      isPatientDetailsSaved = true;
      await UserDao(uid: currentUser.uId).createUser(currentUser).then((value) {
        Provider<User>.value(value: currentUser);
        push(HomeScreen(user: currentUser,));
      });


    }
    else {
      showDlg(ErrorMessages.NO_INTERNET_CONNECTION, context);
    }

  }


  @action
   savePersonalData(User currentUser, context, push) async{
    if(await Utils.instance.isInternetConnected() == true) {
      currentUser
        ..pId = patientIDController.text
        ..isRegistered = true
        ..firstName = firstNameController.text
        ..lastName = lastNameController.text
        ..name = firstNameController.text + ' ' + lastNameController.text
        /*..dob = dateOfBirth
        ..date = dateOfBirthController.text*/
        ..imageUrl = imageUrl
        ..createdOn = Timestamp.now();
//        ..gender = getSelectedGender(selectedGender)
//        ..adharNumber = aadharNumberController.text;

      //..linkedDoctors.add(selectedDoctor.dId);



      /*AddressBean address = AddressBean();
      address
        ..address = addressController.text
        ..city = cityController.text
        ..state = stateController.text
        ..zipCode = zipCodeController.text;

      currentUser.address = address;*/

      var pushToken = await Utils.instance.getPushToken();
      //var deviceId = await Utils.instance.getDeviceId();
      OtherInfoBean otherInfo = OtherInfoBean();

      otherInfo
        ..pushToken = pushToken;
        //..deviceId = deviceId;

      currentUser.otherInfo = otherInfo;
      await UserDao(uid: currentUser.uId).createUser(currentUser).then((value) {
        Provider<User>.value(value: currentUser);
        push(HomeScreen(user: currentUser,));
      });



//    showProgress();

    }
    else {
      showDlg(ErrorMessages.NO_INTERNET_CONNECTION, context);
    }
  }





//  getDoctorIOByName(name){
//    Doctor doctor = doctors.singleWhere((doctor) => doctor.name == name);
//    return doctor;
//  }

  getSelectedGender(index){
    switch (index) {
      case 0:
        return "Male";
        break;
      case 1:
        return "Female";
        break;
      case 2:
        return "Others";
        break;
    }
    return "";
  }

  @action
  Future getImage(String uid, BuildContext context) async {
    if(await Utils.instance.isInternetConnected() == true) {
      image = (await ImagePicker.pickImage(source: ImageSource.gallery));
      if (image != null) {
        showProgress(context);
        //image = await cropImage(image);
        image = await compressImage(image);
        await uploadUserImages(image, uid, context);
      }
    }
    else {
      showDlg(ErrorMessages.NO_INTERNET_CONNECTION, context);
    }

  }

  /*@action
  Future cropImage(File image) async {
    File croppedFile = (await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatioPresets: Platform.isAndroid ? [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ]
            : [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio5x3,
          CropAspectRatioPreset.ratio5x4,
          CropAspectRatioPreset.ratio7x5,
          CropAspectRatioPreset.ratio16x9
        ],

        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.blue[800],
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        )
    )
    );
    return croppedFile;

  }*/

  @action
  Future<File> compressImage(File file) async {
    File temp;
    try {
      Directory appDocDirectory;
      if (Platform.isIOS) {
        appDocDirectory = await getApplicationDocumentsDirectory();
      } else {
        appDocDirectory = await getExternalStorageDirectory();
      }
      String ext = file.path
          .split('.')
          .last;
      String customPath = '/profilePic.$ext';
      String target = appDocDirectory.absolute.path + customPath;
      temp =
      await FlutterImageCompress.compressAndGetFile(file.absolute.path, target, quality: 30);
    } catch(e) {
      //print(e.toString());
    }
    return temp;
  }

  @action
  Future uploadUserImages(File imageFile, String userID, context) async {
    try {
      String fileName = 'users/$userID/profilePic';
      StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
      StorageUploadTask uploadTask = reference.putFile(imageFile);
      StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
      imageUrl = await storageTaskSnapshot.ref.getDownloadURL();
      //print(imageUrl);
      hideProgress(context);
      } catch(e) {
      //print(e.toString());
    }


  }


}