class AppStrings {
  AppStrings._();

  // App General
  static const String appTitle = 'Enterprise Mobil';
  
  // Login Screen
  static const String loginTitle = 'Giriş Yap';
  static const String loginSubtitle = 'Devam etmek için kurumsal telefon numaranızı girin.';
  static const String phoneLabel = 'Telefon Numarası';
  static const String phoneHint = '+90 (5XX) XXX XX XX';
  static const String phonePrefix = '+90 ';
  static const String loginButtonText = 'Giriş Yap';
  static const String loginButtonLoading = 'Giriş Yapılıyor...';
  
  // Validation Messages
  static const String invalidPhoneError = 'Lütfen geçerli bir telefon numarası giriniz (10 hane).';
  static const String loginSuccessMessage = 'Giriş başarılı! Yönlendiriliyorsunuz...';
  static const String loginErrorMessage = 'Giriş sırasında bir hata oluştu. Lütfen tekrar deneyin.';

  // Theme
  static const String lightMode = 'Açık Tema';
  static const String darkMode = 'Koyu Tema';
}

class AppConstants {
  AppConstants._();

  // Turkey Phone Mask & Formatter (+90 (5XX) XXX XX XX)
  static const String phoneMask = '+90 (###) ### ## ##';
  static const String phoneMaskFilterChar = '#';
  static const int rawPhoneLength = 10; // 5XX XXX XX XX (10 digits)
  
  // Base URLs & Endpoints
  static const String baseUrl = 'https://api.enterprise.com.tr/v1';
  static const String loginEndpoint = '/auth/login';
  
  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
