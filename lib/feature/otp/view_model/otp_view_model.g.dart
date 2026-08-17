// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$OtpViewModel on _OtpViewModelBase, Store {
  Computed<bool>? _$isCodeValidComputed;

  @override
  bool get isCodeValid => (_$isCodeValidComputed ??= Computed<bool>(
    () => super.isCodeValid,
    name: '_OtpViewModelBase.isCodeValid',
  )).value;
  Computed<bool>? _$isVerifyButtonEnabledComputed;

  @override
  bool get isVerifyButtonEnabled =>
      (_$isVerifyButtonEnabledComputed ??= Computed<bool>(
        () => super.isVerifyButtonEnabled,
        name: '_OtpViewModelBase.isVerifyButtonEnabled',
      )).value;
  Computed<bool>? _$canResendComputed;

  @override
  bool get canResend => (_$canResendComputed ??= Computed<bool>(
    () => super.canResend,
    name: '_OtpViewModelBase.canResend',
  )).value;
  Computed<String>? _$formattedCountdownComputed;

  @override
  String get formattedCountdown =>
      (_$formattedCountdownComputed ??= Computed<String>(
        () => super.formattedCountdown,
        name: '_OtpViewModelBase.formattedCountdown',
      )).value;

  late final _$otpCodeAtom = Atom(
    name: '_OtpViewModelBase.otpCode',
    context: context,
  );

  @override
  String get otpCode {
    _$otpCodeAtom.reportRead();
    return super.otpCode;
  }

  @override
  set otpCode(String value) {
    _$otpCodeAtom.reportWrite(value, super.otpCode, () {
      super.otpCode = value;
    });
  }

  late final _$countdownAtom = Atom(
    name: '_OtpViewModelBase.countdown',
    context: context,
  );

  @override
  int get countdown {
    _$countdownAtom.reportRead();
    return super.countdown;
  }

  @override
  set countdown(int value) {
    _$countdownAtom.reportWrite(value, super.countdown, () {
      super.countdown = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: '_OtpViewModelBase.isLoading',
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

  late final _$isResendingAtom = Atom(
    name: '_OtpViewModelBase.isResending',
    context: context,
  );

  @override
  bool get isResending {
    _$isResendingAtom.reportRead();
    return super.isResending;
  }

  @override
  set isResending(bool value) {
    _$isResendingAtom.reportWrite(value, super.isResending, () {
      super.isResending = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: '_OtpViewModelBase.errorMessage',
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

  late final _$verifyResultAtom = Atom(
    name: '_OtpViewModelBase.verifyResult',
    context: context,
  );

  @override
  VerifyOtpResponseModel? get verifyResult {
    _$verifyResultAtom.reportRead();
    return super.verifyResult;
  }

  @override
  set verifyResult(VerifyOtpResponseModel? value) {
    _$verifyResultAtom.reportWrite(value, super.verifyResult, () {
      super.verifyResult = value;
    });
  }

  late final _$resendCodeAsyncAction = AsyncAction(
    '_OtpViewModelBase.resendCode',
    context: context,
  );

  @override
  Future<void> resendCode() {
    return _$resendCodeAsyncAction.run(() => super.resendCode());
  }

  late final _$submitVerifyOtpAsyncAction = AsyncAction(
    '_OtpViewModelBase.submitVerifyOtp',
    context: context,
  );

  @override
  Future<void> submitVerifyOtp() {
    return _$submitVerifyOtpAsyncAction.run(() => super.submitVerifyOtp());
  }

  late final _$_OtpViewModelBaseActionController = ActionController(
    name: '_OtpViewModelBase',
    context: context,
  );

  @override
  void setOtpCode(String value) {
    final _$actionInfo = _$_OtpViewModelBaseActionController.startAction(
      name: '_OtpViewModelBase.setOtpCode',
    );
    try {
      return super.setOtpCode(value);
    } finally {
      _$_OtpViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void startTimer() {
    final _$actionInfo = _$_OtpViewModelBaseActionController.startAction(
      name: '_OtpViewModelBase.startTimer',
    );
    try {
      return super.startTimer();
    } finally {
      _$_OtpViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
otpCode: ${otpCode},
countdown: ${countdown},
isLoading: ${isLoading},
isResending: ${isResending},
errorMessage: ${errorMessage},
verifyResult: ${verifyResult},
isCodeValid: ${isCodeValid},
isVerifyButtonEnabled: ${isVerifyButtonEnabled},
canResend: ${canResend},
formattedCountdown: ${formattedCountdown}
    ''';
  }
}
