
import 'package:flutter/cupertino.dart';
import 'package:remote_care/constants/strings.dart';
import 'package:remote_care/models/bp_record.dart';
import 'package:remote_care/models/pulse_record.dart';
import 'package:remote_care/models/spo2_record.dart';
import 'package:remote_care/models/temp_record.dart';

import '../../service/firestore_path.dart';
import '../../service/firestore_service.dart';


/// Record Dao is responsible for stream of the records to serve
class RecordDao{
  final _service = FirestoreService.instance;
  final String uid;

  RecordDao({@required this.uid}) : assert(uid != null);

  /// Single Document Stream
  ///
  Stream<BPRecord> docStreamBP(String recordId) => _service.documentStream(
    path: FirestorePath.record(uid, recordId,CollectionType.BP),
    builder: (data, documentId) => BPRecord.fromMap(data:data,documentID: documentId),
  );

  Stream<TempRecord> docStreamTemp(String recordId) => _service.documentStream(
    path: FirestorePath.record(uid, recordId,CollectionType.TEMP),
    builder: (data, documentId) => TempRecord.fromMap(data,documentId),
  );
  Stream<PulseRecord> docStreamPulse(String recordId) => _service.documentStream(
    path: FirestorePath.record(uid, recordId,CollectionType.PULSE),
    builder: (data, documentId) => PulseRecord.fromMap(data,documentId),
  );
  Stream<Spo2Record> docStreamSpo2(String recordId) => _service.documentStream(
    path: FirestorePath.record(uid, recordId,CollectionType.SPO2),
    builder: (data, documentId) => Spo2Record.fromMap(data:data,documentID: documentId),
  );



  ///  Collection Stream of individual metric
  ///

  Stream<List<BPRecord>> collectionStreamBP() => _service.collectionStream(
    path: FirestorePath.records(uid,CollectionType.BP),
    builder: (data, documentId) => BPRecord.fromMap(data:data, documentID: documentId),
    sort: (lhs, rhs) => lhs.recordedTime.toDate().isBefore(rhs.recordedTime.toDate())?1:-1,
  );

  Stream<List<TempRecord>> collectionStreamTemp() => _service.collectionStream(
    path: FirestorePath.records(uid,CollectionType.TEMP),
    builder: (data, documentId) => TempRecord.fromMap(data, documentId),
    sort: (lhs, rhs) => lhs.recordedTime.toDate().isBefore(rhs.recordedTime.toDate())?1:-1,
  );

  Stream<List<PulseRecord>> collectionStreamPulse() => _service.collectionStream(
    path: FirestorePath.records(uid,CollectionType.PULSE),
    builder: (data, documentId) => PulseRecord.fromMap(data, documentId),
    sort: (lhs, rhs) => lhs.recordedTime.toDate().isBefore(rhs.recordedTime.toDate())?1:-1,
  );


  Stream<List<Spo2Record>> collectionStreamSpo2() => _service.collectionStream(
    path: FirestorePath.records(uid,CollectionType.SPO2),
    builder: (data, documentId) => Spo2Record.fromMap(data:data, documentID: documentId),
    sort: (lhs, rhs) => lhs.recordedTime.toDate().isBefore(rhs.recordedTime.toDate())?1:-1,
  );



  /// insertion of Document for individual Metric
  ///


  Future<void> addBPRecord(BPRecord content) async{
    _service.setData(path: FirestorePath.records(uid,CollectionType.BP),data:content.toJson(),isAutoDocId: true);
  }
  Future<void> addPulseRecord(PulseRecord content) async{
    _service.setData(path: FirestorePath.records(uid,CollectionType.PULSE),data:content.toJson(),isAutoDocId: true);
  }
  Future<void> addTempRecord(TempRecord content) async{
    _service.setData(path: FirestorePath.records(uid,CollectionType.TEMP),data:content.toJson(),isAutoDocId: true);
  }
  Future<void> addSpo2Record(Spo2Record content) async{
    _service.setData(path: FirestorePath.records(uid,CollectionType.SPO2),data:content.toJson(),isAutoDocId: true);
  }

}

