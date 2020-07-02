import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

  Future<void> setData(
      {@required String path,
      @required Map<String, dynamic> data,
      bool merge = false,
      bool isAutoDocId = false}) async {
    var reference;
    if (isAutoDocId) {
      reference = Firestore.instance.collection(path).document();
    } else {
      reference = Firestore.instance.document(path);
    }
    //print('$path: $data');
    await reference.setData(data, merge: merge);
  }

  Future<List<T>> getDocumentsInCollection<T>(
      {@required String path,
      Query queryBuilder(Query query),
      @required T builder(Map<String, dynamic> data),
      int sort(T lhs, T rhs)}) async {
    Query query = Firestore.instance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final Future<QuerySnapshot> snapshots = query.getDocuments();
    return snapshots.then((value) {
      final result = value.documents
          .map((snapshot) => builder(snapshot.data))
          .where((value) => value != null)
          .toList();
      if (sort != null) {
        result.sort(sort);
      }
      return result;
    });
    // return Firestore.instance.document(path).get().then((value) => builder(value.data));
  }

  Future<T> getDocument<T>(
      {@required String path,
      @required T builder(Map<String, dynamic> data)}) async {
    return Firestore.instance
        .document(path)
        .get()
        .then((value) => builder(value.data));
  }

  Future<T> getAppointmentDocument<T>(
      {@required
          String path,
      @required
          T builder(Map<String, dynamic> data, String documentID)}) async {
    return Firestore.instance
        .document(path)
        .get()
        .then((value) => builder(value.data, value.documentID));
  }

  Future<void> deleteData({@required String path}) async {
    final reference = Firestore.instance.document(path);
    //print('delete: $path');
    await reference.delete();
  }

  Stream<List<T>> collectionStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentID),
    Query queryBuilder(Query query),
    int sort(T lhs, T rhs),
  }) {
    Query query = Firestore.instance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final Stream<QuerySnapshot> snapshots = query.snapshots();
    return snapshots.map((snapshot) {
      final result = snapshot.documents
          .map((snapshot) => builder(
                snapshot.data,
                snapshot.documentID,
              ))
          .where((value) => value != null)
          .toList();
      if (sort != null) {
        result.sort(sort);
      }
      return result;
    });
  }

  Stream<T> documentStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentID),
  }) {
    final DocumentReference reference = Firestore.instance.document(path);
    final Stream<DocumentSnapshot> snapshots = reference.snapshots();
    return snapshots
        .map((snapshot) => builder(snapshot.data, snapshot.documentID));
  }
}
