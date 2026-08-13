import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import '../../../core/base/view_model/base_view_model.dart';
import '../../../core/constants/app_constants.dart';
import '../model/login_request_model.dart';
import '../model/login_response_model.dart';
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
    loginResult = null;
  }

  // --- Observables (Değişen State'ler) ---

  /// Sadece saf 10 hane rakam tutar (Örn: 5551234567)
  @observable
  String rawPhoneNumber = '';

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @observable
  LoginResponseModel? loginResult;

  // --- Computed Properties (Türetilmiş Değerler) ---

  /// Türkiye telefon numarası kuralı: 10 hane ve 5 ile başlamalı
  @computed
  bool get isPhoneValid {
    if (rawPhoneNumber.length != AppConstants.rawPhoneLength) {
      return false;
    }
    return rawPhoneNumber.startsWith('5');
  }

  /// Butonun aktif/pasif durumu: Telefon geçerli ve yüklenme durumu yoksa aktif
  @computed
  bool get isButtonEnabled => isPhoneValid && !isLoading;

  // --- Actions (State'i Güncelleyen Fonksiyonlar) ---

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
      final request = LoginRequestModel(rawPhoneNumber: rawPhoneNumber);
      final response = await _loginService.login(request);
      loginResult = response;

      if (response.success && buildContext != null && buildContext!.mounted) {
        ScaffoldMessenger.of(buildContext!).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle_outline, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(child: Text(AppStrings.loginSuccessMessage)),
              ],
            ),
            backgroundColor: const Color(0xFF2EC4B6),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      errorMessage = AppStrings.loginErrorMessage;
    } finally {
      isLoading = false;
    }
  }
}
