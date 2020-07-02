class FirestorePath {
  static String users() => 'users/';
  static String doctors() => 'Doctors/';
  static String appointments() => 'appointments/';
  static String appointment(String uid) => 'appointments/$uid';
  static String addAppointments() => 'appointments';
  static String user(String uid) => 'users/$uid';
  static String admin(uid) => 'admin/$uid';
  static String doctor(String uid) => 'Doctors/$uid';
  static String erx(String uid) => 'users/$uid/erx';
  static String fitness(String uid) => 'users/$uid/fitness';
  static String charts() => 'charts';
  static String patientUser(String uid, String recordId) =>
      'Doctors/$uid/patients/$recordId';
  static String appointmentDoctor(String uid, String recordId) =>
      'Doctors/$uid/appointments/$recordId';
static String appointmenPatient(String uid, String recordId) =>
      'users/$uid/appointments/$recordId';

  static String doctorNotification(String uid, String id) => 'Doctors/$uid/notifications/$id';
  static String userNotification(String uid, String id) => 'users/$uid/notifications/$id';
  static String userReadingAlert(String uid) => 'users/$uid/alertedValue/lastAlert';
  static String doctorNotifications(String uid) => 'Doctors/$uid/notifications/';
  static String userNotifications(String uid) => 'users/$uid/notifications/';
  //lists
  static String diaGnosiLlists() => 'Lists/Diagnosis';
  static String medicationsLists() => 'Lists/Medications';
  static String quantityLists() => 'Lists/Quantity';
  static String cityList() => 'Lists/City';
  static String stateList() => 'Lists/States';
  static String relationshipList() => 'Lists/Relationship';
  static String specialityList() => 'Lists/Specialty';
  static String mediumList() => 'Lists/Medium';
  static String foodList() => 'Lists/Food';
  static String frequencyList() => 'Lists/Frequency';
  static String dosageList() => 'Lists/Dosage';
  static String doctorsNumbersList() => 'Lists/Doctors';

  //reading Values
  static String pulseList() => 'Lists/Pulse';
  static String spo2List() => 'Lists/Spo2';
  static String tempList() => 'Lists/Temp';
  static String bpDiaList() => 'Lists/BpDia';
  static String bpSysList() => 'Lists/BpSys';
  static String glucoseBeforeList() => 'Lists/GlucoseBeforeMeal';
  static String glucoseAfterList() => 'Lists/GlucoseAfterMeal';
  static String weightList() => 'Lists/Weight';

  ///BP Related Firestore Paths
  static String bpRecord(String uid, String recordId) =>
      'users/$uid/bp/$recordId';
  static String bpRecordAutoId(String uid) =>
      'users/$uid/bp/';
  static String bpRecords(String uid) => 'users/$uid/bp';


  ///Common firestore path  here by default by default type would be the collection name
  static String record(String uid, String recordType,String recordId) =>
      'users/$uid/$recordType/$recordId';
  static String recordAutoId(String uid,String recordType) =>
      'users/$uid/$recordType/';
  static String records(String uid,String recordType) => 'users/$uid/$recordType';
  static String patients(String uid,String recordType) => 'Doctors/$uid/$recordType';
  //POMR ques and User Response path
  static String pomrQues() =>"Lists/POMRQues/";
  static String pomrResp(String uid) => "users/$uid/pomr/Response/";
  static String pomrRespset(String uid) => "users/$uid/pomr/Response/";


///Default
//  static String record(String uid, String type,String recordId) =>
//      'users/$uid/records/$recordId';
//  static String recordAutoId(String uid) =>
//      'users/$uid/records/';
//  static String records(String uid) => 'users/$uid/records';
}
