import 'package:firebase_auth/firebase_auth.dart';
import 'package:remote_care/models/user.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User _userFromFirebase(FirebaseUser user) {
    if (user == null) {
      return null;
    }
    return User(
      uId: user.uid,
      mobile: user.phoneNumber
    );
  }

  Stream<User> get onAuthStateChanged {
    return _firebaseAuth.onAuthStateChanged.map(_userFromFirebase);
  }

  Future<User> signInAnonymously() async {
    final AuthResult authResult = await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(authResult.user);
  }

  Future<User> signInWithEmailAndPassword(String email, String password) async {
    final AuthResult authResult = await _firebaseAuth
        .signInWithCredential(EmailAuthProvider.getCredential(
      email: email,
      password: password,
    ));
    return _userFromFirebase(authResult.user);
  }

  Future<User> createUserWithEmailAndPassword(
      String email, String password) async {
    final AuthResult authResult = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<User> currentUser() async {
    final FirebaseUser user = await _firebaseAuth.currentUser();
    return _userFromFirebase(user);
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
  Future sendOTP(String mobileNumber,onCodeSent,onError) async{
    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: mobileNumber,
        timeout: const Duration(seconds: 5),
        verificationCompleted:(phoneAuthCredential) => (){
          //print("Verification Completed: "+phoneAuthCredential.toString());
        },
        verificationFailed: (error) => onError(error),
        codeSent: (verificationId, [forceResendingToken]) => onCodeSent(verificationId,forceResendingToken),
        codeAutoRetrievalTimeout: (verificationId) => onError("Auto Retrieval Timeput"),);
  }
  Future verifyOTP(smsCode,verificationId,onSuccess,onError) async {
    var _authCredential =  PhoneAuthProvider.getCredential(
        verificationId: verificationId, smsCode: smsCode);
    _firebaseAuth.signInWithCredential(_authCredential).then((value){
      this._userFromFirebase(value?.user);
      onSuccess();
    }).catchError((error) => onError(error));
  }

}
