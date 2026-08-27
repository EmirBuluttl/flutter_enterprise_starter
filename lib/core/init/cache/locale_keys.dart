/// Merkezi Local Storage Key Yönetimi
///
/// Tüm SharedPreferences key'leri burada tanımlanır.
/// Uygulama genelinde hiçbir yerde string key literal yazılmaz,
/// her zaman bu sınıftaki sabitler kullanılır.
///
/// ✅ Doğru Kullanım: LocaleKeys.bearerToken
/// ❌ Yanlış Kullanım: prefs.getString('bearer_token')
class LocaleKeys {
  LocaleKeys._(); // Instantiate edilemesin (sabit sınıf)

  /// OTP doğrulaması sonrası gelen Bearer Token
  static const String bearerToken = 'bearer_token';

  /// Kullanıcının daha önce kayıtlı olup olmadığı bilgisi
  static const String isAlreadyUser = 'is_already_user';
}
