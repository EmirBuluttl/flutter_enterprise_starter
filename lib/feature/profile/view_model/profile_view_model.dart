import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import '../../../core/base/view_model/base_view_model.dart';
import '../../../core/init/cache/locale_storage_service.dart';
import '../../home/view/home_view.dart';
import '../model/sign_up_request_model.dart';
import '../model/sign_up_response_model.dart';
import '../service/i_profile_service.dart';
import '../service/profile_service.dart';

part 'profile_view_model.g.dart';

class ProfileViewModel = _ProfileViewModelBase with _$ProfileViewModel;

abstract class _ProfileViewModelBase with Store implements BaseViewModel {
  final IProfileService _profileService;
  final String phoneNumber;
  final String phoneVerificationId;

  _ProfileViewModelBase({
    required this.phoneNumber,
    required this.phoneVerificationId,
    IProfileService? profileService,
  }) : _profileService = profileService ?? ProfileService();

  @override
  BuildContext? buildContext;

  @override
  void setContext(BuildContext context) {
    buildContext = context;
  }

  @override
  void init() {
    name = '';
    surname = '';
    email = '';
    isKvkkAccepted = false;
    isCommunicationAccepted = false;
    isLoading = false;
    errorMessage = null;
    signUpResult = null;
  }

  // --- Observables ---

  @observable
  String name = '';

  @observable
  String surname = '';

  @observable
  String email = '';

  @observable
  bool isKvkkAccepted = false;

  @observable
  bool isCommunicationAccepted = false;

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @observable
  SignUpResponseModel? signUpResult;

  // --- Computed Properties ---

  @computed
  bool get isNameValid => name.trim().length >= 2;

  @computed
  bool get isSurnameValid => surname.trim().length >= 2;

  @computed
  bool get isEmailValid {
    if (email.trim().isEmpty) return true; // Opsiyonel
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email.trim());
  }

  @computed
  bool get isButtonEnabled =>
      isNameValid &&
      isSurnameValid &&
      isEmailValid &&
      isKvkkAccepted &&
      !isLoading;

  // --- Actions ---

  @action
  void setName(String value) {
    name = value;
    if (errorMessage != null) errorMessage = null;
  }

  @action
  void setSurname(String value) {
    surname = value;
    if (errorMessage != null) errorMessage = null;
  }

  @action
  void setEmail(String value) {
    email = value;
    if (errorMessage != null) errorMessage = null;
  }

  @action
  void setKvkkAccepted(bool value) {
    isKvkkAccepted = value;
    if (errorMessage != null) errorMessage = null;
  }

  @action
  void setCommunicationAccepted(bool value) {
    isCommunicationAccepted = value;
  }

  @action
  Future<void> submitSignUp() async {
    if (!isButtonEnabled) return;

    isLoading = true;
    errorMessage = null;

    try {
      final request = SignUpRequestModel(
        phoneVerificationId: phoneVerificationId,
        name: name.trim(),
        surname: surname.trim(),
        email: email.trim(),
        notificationToken: '',
        kvkkAgreement: isKvkkAccepted,
        generalCa: isKvkkAccepted,
        smsCa: isCommunicationAccepted,
        emailCa: isCommunicationAccepted,
        phoneCa: isCommunicationAccepted,
      );

      final response = await _profileService.signUp(request);
      signUpResult = response;

      if (response.isSuccess) {
        log('✅ [PROFILE VM] Kayıt Başarılı! Yerel hafızaya kaydediliyor: $phoneNumber');

        final cleanPhone = phoneNumber.trim();
        if (cleanPhone.isNotEmpty) {
          await LocaleStorageService.instance.setUserRegistered(cleanPhone, true);
          await LocaleStorageService.instance.incrementLoginCount(cleanPhone);
        }

        // İsim, Soyisim ve E-posta bilgilerini kaydet
        await LocaleStorageService.instance.saveUserProfile(
          name: name.trim(),
          surname: surname.trim(),
          email: email.trim(),
        );

        if (buildContext != null && buildContext!.mounted) {
          Navigator.pushAndRemoveUntil(
            buildContext!,
            MaterialPageRoute(builder: (context) => const HomeView()),
            (route) => false,
          );
        }
      } else {
        errorMessage = response.message ??
            'Kayıt işlemi gerçekleştirilemedi. Lütfen tekrar deneyiniz.';
      }
    } catch (e) {
      errorMessage =
          'Kayıt sırasında bir hata oluştu. Lütfen bağlantınızı kontrol ediniz.';
    } finally {
      isLoading = false;
    }
  }
}
