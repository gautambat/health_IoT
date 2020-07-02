import 'bp_record.dart';

class RecordResponse{
  List<BPRecord> bpRecords = [];
  List<BPRecord> pulseRecords = [];
  List<BPRecord> spo2Records = [];

  RecordResponse(this.bpRecords, this.pulseRecords,
      this.spo2Records);

}