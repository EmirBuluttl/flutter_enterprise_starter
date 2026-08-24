class AppStrings {
  AppStrings._();

  // App General
  static const String appTitle = 'Renault Port';

  // Login Screen (Renault Port)
  static const String loginTitle = 'Renault Port\'a Hoş Geldiniz';
  static const String loginSubtitle =
      'Giriş yapmak ve aracınızı yönetmek için kayıtlı telefon numaranızı girin.';
  static const String phoneLabel = 'Telefon Numarası';
  static const String phoneHint = '+90 (5XX) XXX XX XX';
  static const String phonePrefix = '+90 ';
  static const String loginButtonText = 'Doğrulama Kodu Gönder';
  static const String loginButtonLoading = 'Kod Gönderiliyor...';

  // OTP Screen
  static const String otpTitle = 'Doğrulama Kodu';
  static const String otpSubtitle =
      'numaralı telefonunuza gönderilen 4 haneli SMS doğrulama kodunu giriniz.';
  static const String otpCodeLabel = 'Doğrulama Kodu';
  static const String otpButtonText = 'Doğrula ve Giriş Yap';
  static const String otpButtonLoading = 'Doğrulanıyor...';
  static const String resendCodeText = 'Kodu Tekrar Gönder';
  static const String resendCountdownText = 'Kalan Süre: ';

  // Home Screen (Renault Port)
  static const String homeTitle = 'Renault Port';
  static const String homeWelcome = 'Hoş Geldiniz';
  static const String homeCarTitle = 'Renault Megane E-Tech';
  static const String homeCarPlate = '34 RNT 2026';
  static const String logoutButtonText = 'Çıkış Yap';

  // Validation Messages
  static const String invalidPhoneError =
      'Lütfen geçerli bir telefon numarası giriniz (5XX XXX XX XX).';
  static const String invalidOtpError = 'Lütfen 4 haneli doğrulama kodunu eksiksiz giriniz.';
  static const String loginSuccessMessage = 'Doğrulama kodu SMS ile gönderildi.';
  static const String otpSuccessMessage = 'Giriş başarılı! Ana sayfaya yönlendiriliyorsunuz...';
  static const String generalErrorMessage =
      'İşlem sırasında bir hata oluştu. Lütfen tekrar deneyin.';

  // Theme
  static const String lightMode = 'Açık Tema';
  static const String darkMode = 'Koyu Tema';
}

class AppConstants {
  AppConstants._();


  static const String baseUrl = 'http://port-api-main-v2-staging.azurewebsites.net';

  static const String phoneVerificationEndpoint = '/api/v1/customers/verifications/phone';

  // Turkey Phone Mask & Formatter (+90 (5XX) XXX XX XX)
  static const String phoneMask = '+90 (###) ### ## ##';
  static const String phoneMaskFilterChar = '#';
  static const int rawPhoneLength = 10; // 5XX XXX XX XX (10 digits)
  static const int otpCodeLength = 4;   // 4 digits

  // OTP Resend Timer Duration (Seconds)
  static const int otpTimerDurationSeconds = 60;

  // Network Timeouts
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
