// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_verification_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$OTPVerificationStore on OTPVerificationStoreBase, Store {
  final _$errorMessageAtom =
      Atom(name: 'OTPVerificationStoreBase.errorMessage');

  @override
  String get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  final _$verifyOTPAsyncAction =
      AsyncAction('OTPVerificationStoreBase.verifyOTP');

  @override
  Future verifyOTP(dynamic context, dynamic pushScreen, dynamic smsCode,
      dynamic verificationId, dynamic mobileNumber, dynamic name) {
    return _$verifyOTPAsyncAction.run(() => super.verifyOTP(
        context, pushScreen, smsCode, verificationId, mobileNumber, name));
  }

  final _$OTPVerificationStoreBaseActionController =
      ActionController(name: 'OTPVerificationStoreBase');

  @override
  dynamic resendOTP(String mobileNumber, BuildContext context) {
    final _$actionInfo = _$OTPVerificationStoreBaseActionController.startAction(
        name: 'OTPVerificationStoreBase.resendOTP');
    try {
      return super.resendOTP(mobileNumber, context);
    } finally {
      _$OTPVerificationStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
errorMessage: ${errorMessage}
    ''';
  }
}
