import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import '../../../core/base/view_model/base_view_model.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/init/cache/locale_storage_service.dart';
import '../../home/view/home_view.dart';
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

    final phone = rawPhoneNumber.trim();

    try {
      // -----------------------------------------------------------------------
      // 5. GİRİŞ & TOKEN KONTROLÜ (Step-up Auth)
      // -----------------------------------------------------------------------
      final isRegistered = LocaleStorageService.instance.isUserRegistered(phone);
      final existingToken = LocaleStorageService.instance.getTokenForPhone(phone);
      final currentLoginCount = LocaleStorageService.instance.getLoginCount(phone);

      final hasSavedProfile = LocaleStorageService.instance.userName != null &&
          LocaleStorageService.instance.userName!.isNotEmpty;

      log('🔍 [LOGIN VM] Numara: $phone, Kayıtlı mı: $isRegistered, Profil var mı: $hasSavedProfile, Sayaç: $currentLoginCount');

      // Eğer kullanıcı daha önce kayıt olduysa, geçerli token'ı varsa VE profil bilgisi kayıtlıysa:
      if (isRegistered && existingToken != null && existingToken.isNotEmpty && hasSavedProfile) {
        if (currentLoginCount < 4) {
          // 1., 2., 3., 4. Girişler: SMS sormadan doğrudan HomeView'a al
          final newCount = await LocaleStorageService.instance.incrementLoginCount(phone);
          await LocaleStorageService.instance.saveToken(existingToken);
          await LocaleStorageService.instance.setLastPhoneNumber(phone);

          log('⚡ [LOGIN VM] Hızlı Giriş Yapıldı! (Sayaç: $newCount/5)');

          if (buildContext != null && buildContext!.mounted) {
            Navigator.pushAndRemoveUntil(
              buildContext!,
              MaterialPageRoute(builder: (context) => const HomeView()),
              (route) => false,
            );
          }
          return;
        } else {
          // 5. Giriş: Güvenlik amaçlı SMS doğrulaması zorunlu! Sayacı sıfırla.
          log('🛡️ [LOGIN VM] 5. Giriş Tespit Edildi! Güvenlik için SMS kodu isteniyor.');
          await LocaleStorageService.instance.resetLoginCount(phone);
        }
      }

      // Kayıtsız kullanıcı veya 5. giriş: Normal SMS Doğrulama Akışı
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
