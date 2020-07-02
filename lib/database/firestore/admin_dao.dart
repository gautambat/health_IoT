import 'package:flutter/cupertino.dart';
import 'package:remote_care/models/admin.dart';

import '../../service/firestore_path.dart';
import '../../service/firestore_service.dart';

class AdminDao {
  final _service = FirestoreService.instance;
  final String uid;

  AdminDao({this.uid});

  Future<Admin> getAdmin() async {
    return _service.getDocument(path: FirestorePath.admin(uid), builder: (data) => Admin.fromMap(data));
  }
}