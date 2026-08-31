// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ProfileViewModel on _ProfileViewModelBase, Store {
  Computed<bool>? _$isNameValidComputed;

  @override
  bool get isNameValid => (_$isNameValidComputed ??= Computed<bool>(
    () => super.isNameValid,
    name: '_ProfileViewModelBase.isNameValid',
  )).value;
  Computed<bool>? _$isSurnameValidComputed;

  @override
  bool get isSurnameValid => (_$isSurnameValidComputed ??= Computed<bool>(
    () => super.isSurnameValid,
    name: '_ProfileViewModelBase.isSurnameValid',
  )).value;
  Computed<bool>? _$isEmailValidComputed;

  @override
  bool get isEmailValid => (_$isEmailValidComputed ??= Computed<bool>(
    () => super.isEmailValid,
    name: '_ProfileViewModelBase.isEmailValid',
  )).value;
  Computed<bool>? _$isButtonEnabledComputed;

  @override
  bool get isButtonEnabled => (_$isButtonEnabledComputed ??= Computed<bool>(
    () => super.isButtonEnabled,
    name: '_ProfileViewModelBase.isButtonEnabled',
  )).value;

  late final _$nameAtom = Atom(
    name: '_ProfileViewModelBase.name',
    context: context,
  );

  @override
  String get name {
    _$nameAtom.reportRead();
    return super.name;
  }

  @override
  set name(String value) {
    _$nameAtom.reportWrite(value, super.name, () {
      super.name = value;
    });
  }

  late final _$surnameAtom = Atom(
    name: '_ProfileViewModelBase.surname',
    context: context,
  );

  @override
  String get surname {
    _$surnameAtom.reportRead();
    return super.surname;
  }

  @override
  set surname(String value) {
    _$surnameAtom.reportWrite(value, super.surname, () {
      super.surname = value;
    });
  }

  late final _$emailAtom = Atom(
    name: '_ProfileViewModelBase.email',
    context: context,
  );

  @override
  String get email {
    _$emailAtom.reportRead();
    return super.email;
  }

  @override
  set email(String value) {
    _$emailAtom.reportWrite(value, super.email, () {
      super.email = value;
    });
  }

  late final _$isKvkkAcceptedAtom = Atom(
    name: '_ProfileViewModelBase.isKvkkAccepted',
    context: context,
  );

  @override
  bool get isKvkkAccepted {
    _$isKvkkAcceptedAtom.reportRead();
    return super.isKvkkAccepted;
  }

  @override
  set isKvkkAccepted(bool value) {
    _$isKvkkAcceptedAtom.reportWrite(value, super.isKvkkAccepted, () {
      super.isKvkkAccepted = value;
    });
  }

  late final _$isCommunicationAcceptedAtom = Atom(
    name: '_ProfileViewModelBase.isCommunicationAccepted',
    context: context,
  );

  @override
  bool get isCommunicationAccepted {
    _$isCommunicationAcceptedAtom.reportRead();
    return super.isCommunicationAccepted;
  }

  @override
  set isCommunicationAccepted(bool value) {
    _$isCommunicationAcceptedAtom.reportWrite(
      value,
      super.isCommunicationAccepted,
      () {
        super.isCommunicationAccepted = value;
      },
    );
  }

  late final _$isLoadingAtom = Atom(
    name: '_ProfileViewModelBase.isLoading',
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
    name: '_ProfileViewModelBase.errorMessage',
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

  late final _$signUpResultAtom = Atom(
    name: '_ProfileViewModelBase.signUpResult',
    context: context,
  );

  @override
  SignUpResponseModel? get signUpResult {
    _$signUpResultAtom.reportRead();
    return super.signUpResult;
  }

  @override
  set signUpResult(SignUpResponseModel? value) {
    _$signUpResultAtom.reportWrite(value, super.signUpResult, () {
      super.signUpResult = value;
    });
  }

  late final _$submitSignUpAsyncAction = AsyncAction(
    '_ProfileViewModelBase.submitSignUp',
    context: context,
  );

  @override
  Future<void> submitSignUp() {
    return _$submitSignUpAsyncAction.run(() => super.submitSignUp());
  }

  late final _$_ProfileViewModelBaseActionController = ActionController(
    name: '_ProfileViewModelBase',
    context: context,
  );

  @override
  void setName(String value) {
    final _$actionInfo = _$_ProfileViewModelBaseActionController.startAction(
      name: '_ProfileViewModelBase.setName',
    );
    try {
      return super.setName(value);
    } finally {
      _$_ProfileViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSurname(String value) {
    final _$actionInfo = _$_ProfileViewModelBaseActionController.startAction(
      name: '_ProfileViewModelBase.setSurname',
    );
    try {
      return super.setSurname(value);
    } finally {
      _$_ProfileViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setEmail(String value) {
    final _$actionInfo = _$_ProfileViewModelBaseActionController.startAction(
      name: '_ProfileViewModelBase.setEmail',
    );
    try {
      return super.setEmail(value);
    } finally {
      _$_ProfileViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setKvkkAccepted(bool value) {
    final _$actionInfo = _$_ProfileViewModelBaseActionController.startAction(
      name: '_ProfileViewModelBase.setKvkkAccepted',
    );
    try {
      return super.setKvkkAccepted(value);
    } finally {
      _$_ProfileViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCommunicationAccepted(bool value) {
    final _$actionInfo = _$_ProfileViewModelBaseActionController.startAction(
      name: '_ProfileViewModelBase.setCommunicationAccepted',
    );
    try {
      return super.setCommunicationAccepted(value);
    } finally {
      _$_ProfileViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
name: ${name},
surname: ${surname},
email: ${email},
isKvkkAccepted: ${isKvkkAccepted},
isCommunicationAccepted: ${isCommunicationAccepted},
isLoading: ${isLoading},
errorMessage: ${errorMessage},
signUpResult: ${signUpResult},
isNameValid: ${isNameValid},
isSurnameValid: ${isSurnameValid},
isEmailValid: ${isEmailValid},
isButtonEnabled: ${isButtonEnabled}
    ''';
  }
}
