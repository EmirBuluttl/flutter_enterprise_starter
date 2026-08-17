import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import '../../../core/base/view_model/base_view_model.dart';
import '../../../core/constants/app_constants.dart';
import '../../otp/view/otp_view.dart';
import '../model/phone_verification_response_model.dart';
import '../service/i_login_service.dart';
import '../service/login_service.dart';

part 'login_view_model.g.dart';

class LoginViewModel = _LoginViewModelBase with _$LoginViewModel;

abstract class _LoginViewModelBase with Store implements BaseViewModel {
  final ILoginService _loginService;

  _LoginViewModelBase({ILoginService? loginService})
      : _loginService = loginService ?? LoginService();

  @override
  BuildContext? buildContext;

  @override
  void setContext(BuildContext context) {
    buildContext = context;
  }

  @override
  void init() {
    rawPhoneNumber = '';
    isLoading = false;
    errorMessage = null;
    verificationResult = null;
  }

  // --- Observables ---

  @observable
  String rawPhoneNumber = '';

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @observable
  PhoneVerificationResponseModel? verificationResult;

  // --- Computed Properties ---

  @computed
  bool get isPhoneValid {
    if (rawPhoneNumber.length != AppConstants.rawPhoneLength) {
      return false;
    }
    return rawPhoneNumber.startsWith('5');
  }

  @computed
  bool get isButtonEnabled => isPhoneValid && !isLoading;

  // --- Actions ---

  @action
  void setPhoneNumber(String value) {
    rawPhoneNumber = value;
    if (errorMessage != null) {
      errorMessage = null;
    }
  }

  @action
  Future<void> submitLogin() async {
    if (!isButtonEnabled) return;

    isLoading = true;
    errorMessage = null;

    try {
      final response =
          await _loginService.requestPhoneVerification(rawPhoneNumber);
      verificationResult = response;

      if (response.isSuccess && buildContext != null && buildContext!.mounted) {
        final verificationId =
            response.data?.phoneVerification?.id ?? 'mock_guid';

        Navigator.push(
          buildContext!,
          MaterialPageRoute(
            builder: (context) => OtpView(
              phoneNumber: rawPhoneNumber,
              phoneVerificationId: verificationId,
            ),
          ),
        );
      } else {
        errorMessage = AppStrings.generalErrorMessage;
      }
    } catch (e) {
      errorMessage = AppStrings.generalErrorMessage;
    } finally {
      isLoading = false;
    }
  }
}
