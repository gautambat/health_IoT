// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signup_login_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SignUpLoginStore on SignUpLoginStoreBase, Store {
  final _$currentSelectedRoleAtom =
      Atom(name: 'SignUpLoginStoreBase.currentSelectedRole');

  @override
  String get currentSelectedRole {
    _$currentSelectedRoleAtom.reportRead();
    return super.currentSelectedRole;
  }

  @override
  set currentSelectedRole(String value) {
    _$currentSelectedRoleAtom.reportWrite(value, super.currentSelectedRole, () {
      super.currentSelectedRole = value;
    });
  }

  final _$isLoginScreenAtom = Atom(name: 'SignUpLoginStoreBase.isLoginScreen');

  @override
  bool get isLoginScreen {
    _$isLoginScreenAtom.reportRead();
    return super.isLoginScreen;
  }

  @override
  set isLoginScreen(bool value) {
    _$isLoginScreenAtom.reportWrite(value, super.isLoginScreen, () {
      super.isLoginScreen = value;
    });
  }

  final _$errorMessageAtom = Atom(name: 'SignUpLoginStoreBase.errorMessage');

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

  final _$isContactNumberEmptyAtom =
      Atom(name: 'SignUpLoginStoreBase.isContactNumberEmpty');

  @override
  bool get isContactNumberEmpty {
    _$isContactNumberEmptyAtom.reportRead();
    return super.isContactNumberEmpty;
  }

  @override
  set isContactNumberEmpty(bool value) {
    _$isContactNumberEmptyAtom.reportWrite(value, super.isContactNumberEmpty,
        () {
      super.isContactNumberEmpty = value;
    });
  }

  final _$onContinueTappedAsyncAction =
      AsyncAction('SignUpLoginStoreBase.onContinueTapped');

  @override
  Future onContinueTapped(
      Function pushScreen, BuildContext context, dynamic adminList) {
    return _$onContinueTappedAsyncAction
        .run(() => super.onContinueTapped(pushScreen, context, adminList));
  }

  final _$SignUpLoginStoreBaseActionController =
      ActionController(name: 'SignUpLoginStoreBase');

  @override
  dynamic roleValueChanged(String newValue) {
    final _$actionInfo = _$SignUpLoginStoreBaseActionController.startAction(
        name: 'SignUpLoginStoreBase.roleValueChanged');
    try {
      return super.roleValueChanged(newValue);
    } finally {
      _$SignUpLoginStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
currentSelectedRole: ${currentSelectedRole},
isLoginScreen: ${isLoginScreen},
errorMessage: ${errorMessage},
isContactNumberEmpty: ${isContactNumberEmpty}
    ''';
  }
}
