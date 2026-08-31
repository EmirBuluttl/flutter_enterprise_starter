import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import '../../../core/base/view_model/base_view_model.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/init/cache/locale_storage_service.dart';
import '../../home/view/home_view.dart';
import '../../profile/view/profile_view.dart';
import '../model/verify_otp_request_model.dart';
import '../model/verify_otp_response_model.dart';
import '../service/i_otp_service.dart';
import '../service/otp_service.dart';

part 'otp_view_model.g.dart';

class OtpViewModel = _OtpViewModelBase with _$OtpViewModel;

abstract class _OtpViewModelBase with Store implements BaseViewModel {
  final IOtpService _otpService;
  final String phoneNumber;
  final String phoneVerificationId;

  _OtpViewModelBase({
    required this.phoneNumber,
    required this.phoneVerificationId,
    IOtpService? otpService,
  }) : _otpService = otpService ?? OtpService();

  @override
  BuildContext? buildContext;

  Timer? _timer;

  @override
  void setContext(BuildContext context) {
    buildContext = context;
  }

  @override
  void init() {
    otpCode = '';
    isLoading = false;
    isResending = false;
    errorMessage = null;
    verifyResult = null;
    startTimer();
  }

  void dispose() {
    _timer?.cancel();
  }

  // --- Observables ---

  @observable
  String otpCode = '';

  @observable
  int countdown = AppConstants.otpTimerDurationSeconds;

  @observable
  bool isLoading = false;

  @observable
  bool isResending = false;

  @observable
  String? errorMessage;

  @observable
  VerifyOtpResponseModel? verifyResult;

  // --- Computed Properties ---

  @computed
  bool get isCodeValid => otpCode.length == AppConstants.otpCodeLength;

  @computed
  bool get isVerifyButtonEnabled => isCodeValid && !isLoading;

  @computed
  bool get canResend => countdown == 0 && !isResending;

  @computed
  String get formattedCountdown {
    final minutes = (countdown ~/ 60).toString().padLeft(2, '0');
    final seconds = (countdown % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  // --- Actions ---

  @action
  void setOtpCode(String value) {
    final cleanDigits = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanDigits.length <= AppConstants.otpCodeLength) {
      otpCode = cleanDigits;
    }
    if (errorMessage != null) {
      errorMessage = null;
    }
  }

  @action
  void startTimer() {
    _timer?.cancel();
    countdown = AppConstants.otpTimerDurationSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown > 0) {
        countdown--;
      } else {
        timer.cancel();
      }
    });
  }

  @action
  Future<void> resendCode() async {
    if (!canResend) return;

    isResending = true;
    errorMessage = null;

    try {
      final success = await _otpService.resendOtp(phoneNumber);
      if (success) {
        startTimer();
        if (buildContext != null && buildContext!.mounted) {
          ScaffoldMessenger.of(buildContext!).showSnackBar(
            const SnackBar(
              content: Text('Yeni doğrulama kodu gönderildi.'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } else {
        errorMessage = AppStrings.generalErrorMessage;
      }
    } catch (e) {
      errorMessage = AppStrings.generalErrorMessage;
    } finally {
      isResending = false;
    }
  }

  @action
  Future<void> submitVerifyOtp() async {
    if (!isVerifyButtonEnabled) return;

    isLoading = true;
    errorMessage = null;

    try {
      final request = VerifyOtpRequestModel(
        phoneVerificationId: phoneVerificationId,
        code: otpCode,
        notificationToken: '',
        phone: phoneNumber,
      );

      final response = await _otpService.verifyOtp(request);
      verifyResult = response;

      if (response.isSuccess && buildContext != null && buildContext!.mounted) {
        _timer?.cancel();

        // ------------------------------------------------------------------
        // YÖNLENDIRME & KAYIT KONTROLÜ
        // ------------------------------------------------------------------
        final cleanPhone = phoneNumber.trim();

        // Sunucudan gelen isAlreadyUser true ise VEYA kullanıcı daha önce kayıt olmuşsa
        final isAlreadyUser = (response.otpData?.isAlreadyUser ?? false) ||
            LocaleStorageService.instance.isUserRegistered(cleanPhone);

        if (isAlreadyUser) {
          // Kullanıcı zaten kayıtlı -> Doğrudan HomeView'a yönlendir
          await LocaleStorageService.instance.setUserRegistered(cleanPhone, true);
          await LocaleStorageService.instance.incrementLoginCount(cleanPhone);

          // Cihazda henüz isim kayıtlı değilse profili doldur
          if (LocaleStorageService.instance.userName == null ||
              LocaleStorageService.instance.userName!.isEmpty) {
            await LocaleStorageService.instance.saveUserProfile(
              name: 'Emir',
              surname: 'Bulut',
              email: 'emirb066@gmail.com',
            );
          }

          if (buildContext != null && buildContext!.mounted) {
            Navigator.pushAndRemoveUntil(
              buildContext!,
              MaterialPageRoute(builder: (context) => const HomeView()),
              (route) => false,
            );
          }
        } else {
          // Yeni kullanıcı -> ProfileView'a yönlendir
          if (buildContext != null && buildContext!.mounted) {
            Navigator.pushAndRemoveUntil(
              buildContext!,
              MaterialPageRoute(
                builder: (context) => ProfileView(
                  phoneNumber: cleanPhone,
                  phoneVerificationId: phoneVerificationId,
                ),
              ),
              (route) => false,
            );
          }
        }
      } else {
        // Doğrulama başarısız
        errorMessage = response.message ??
            'Girdiğiniz doğrulama kodu hatalıdır. Lütfen tekrar deneyiniz.';
      }
    } catch (e) {
      errorMessage =
          'Doğrulama sırasında bir hata oluştu. Lütfen bağlantınızı kontrol ediniz.';
    } finally {
      isLoading = false;
    }
  }
}
