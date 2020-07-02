

import 'package:flutter/cupertino.dart';
import 'package:remote_care/models/user.dart';

import '../../service/firestore_path.dart';
import '../../service/firestore_service.dart';


/// each dao is responsible for the operations that can be done on the feature
class UserDao {
  final _service = FirestoreService.instance;
  final String uid;

  UserDao( {this.uid} ); //: assert(uid != null);

  Future<void> createUser(User user) async {
    _service.setData(path: FirestorePath.user(uid), data: user.toJson(),merge: true);
  }

  Future<User> user({@required String uid} ) =>
      _service.getDocument(
        path: FirestorePath.user(uid),
        builder: (data) => User.fromMap(data),
      );

  /*Future<List<User>> getUserByMobile( mobileNumber ) async {
    return _service.getDocumentsInCollection(
        path: FirestorePath.users(),
        queryBuilder: ( query ) =>
            query.where('mobile', isEqualTo: mobileNumber),
        builder: ( data ) => User.fromMap(data));
  }*/

  Stream<List<User>> collectionStremUsers() => _service.collectionStream(
      path: 'users',
      builder: (data, documentId) => User.fromMap(data)
  );

  //use this instead of getUserByUid();
  Future<User> getUser() async {
    return _service.getDocument(path: FirestorePath.user(uid), builder: (data) => User.fromMap(data));
  }
  Future<List<User>> getUserByUid( uid ) async {
    return _service.getDocumentsInCollection(
        path: FirestorePath.users(),
        queryBuilder: ( query ) =>
            query.where('uid', isEqualTo: uid),
        builder: ( data ) => User.fromMap(data));
  }
  Future<List<User>> getUsers() async {
    return _service.getDocumentsInCollection(
        path: FirestorePath.users(),
        builder: (data) => User.fromMap(data));
  }



}

