// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LoginViewModel on _LoginViewModelBase, Store {
  Computed<bool>? _$isPhoneValidComputed;

  @override
  bool get isPhoneValid => (_$isPhoneValidComputed ??= Computed<bool>(
    () => super.isPhoneValid,
    name: '_LoginViewModelBase.isPhoneValid',
  )).value;
  Computed<bool>? _$isButtonEnabledComputed;

  @override
  bool get isButtonEnabled => (_$isButtonEnabledComputed ??= Computed<bool>(
    () => super.isButtonEnabled,
    name: '_LoginViewModelBase.isButtonEnabled',
  )).value;

  late final _$rawPhoneNumberAtom = Atom(
    name: '_LoginViewModelBase.rawPhoneNumber',
    context: context,
  );

  @override
  String get rawPhoneNumber {
    _$rawPhoneNumberAtom.reportRead();
    return super.rawPhoneNumber;
  }

  @override
  set rawPhoneNumber(String value) {
    _$rawPhoneNumberAtom.reportWrite(value, super.rawPhoneNumber, () {
      super.rawPhoneNumber = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: '_LoginViewModelBase.isLoading',
    context: context,
  );

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: '_LoginViewModelBase.errorMessage',
    context: context,
  );

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$loginResultAtom = Atom(
    name: '_LoginViewModelBase.loginResult',
    context: context,
  );

  @override
  LoginResponseModel? get loginResult {
    _$loginResultAtom.reportRead();
    return super.loginResult;
  }

  @override
  set loginResult(LoginResponseModel? value) {
    _$loginResultAtom.reportWrite(value, super.loginResult, () {
      super.loginResult = value;
    });
  }

  late final _$submitLoginAsyncAction = AsyncAction(
    '_LoginViewModelBase.submitLogin',
    context: context,
  );

  @override
  Future<void> submitLogin() {
    return _$submitLoginAsyncAction.run(() => super.submitLogin());
  }

  late final _$_LoginViewModelBaseActionController = ActionController(
    name: '_LoginViewModelBase',
    context: context,
  );

  @override
  void setPhoneNumber(String value) {
    final _$actionInfo = _$_LoginViewModelBaseActionController.startAction(
      name: '_LoginViewModelBase.setPhoneNumber',
    );
    try {
      return super.setPhoneNumber(value);
    } finally {
      _$_LoginViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
rawPhoneNumber: ${rawPhoneNumber},
isLoading: ${isLoading},
errorMessage: ${errorMessage},
loginResult: ${loginResult},
isPhoneValid: ${isPhoneValid},
isButtonEnabled: ${isButtonEnabled}
    ''';
  }
}
