/// Merkezi Local Storage Key Yönetimi
///
/// Tüm SharedPreferences key'leri ve dinamik key fonksiyonları burada tanımlanır.
/// Uygulama genelinde hiçbir yerde hardcoded string key literal yazılmaz.
class LocaleKeys {
  LocaleKeys._(); // Sabit sınıf (instantiate edilemez)

  /// Global / Son oturum Bearer Token
  static const String bearerToken = 'bearer_token';

  /// Son giriş yapılan telefon numarası
  static const String lastPhoneNumber = 'last_phone_number';

  /// Telefon bazlı kayıt olma durumu key'i
  static String isRegisteredKey(String phone) => 'is_registered_$phone';

  /// Telefon bazlı giriş sayacı key'i (1..5)
  static String loginCountKey(String phone) => 'login_count_$phone';

  /// Kullanıcı Profil Bilgileri
  static const String userName = 'user_name';
  static const String userSurname = 'user_surname';
  static const String userEmail = 'user_email';

  /// Telefon bazlı token key'i
  static String tokenKey(String phone) => 'token_$phone';
}
