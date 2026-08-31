import 'package:shared_preferences/shared_preferences.dart';
import 'locale_keys.dart';

/// Merkezi Local Storage Servisi (SharedPreferences Wrapper)
///

class LocaleStorageService {
  LocaleStorageService._();

  static LocaleStorageService? _instance;

  /// Servise erişim noktası. [init()] çağrılmadan kullanılamaz.
  static LocaleStorageService get instance {
    assert(
      _instance != null,
      'LocaleStorageService.init() must be called before accessing instance.',
    );
    return _instance!;
  }

  late final SharedPreferences _prefs;

  /// Uygulamanın başında bir kez çağrılır (main.dart).
  static Future<void> init() async {
    if (_instance != null) return;
    _instance = LocaleStorageService._();
    _instance!._prefs = await SharedPreferences.getInstance();
  }

  // ---------------------------------------------------------------------------
  // GENERIC CRUD (Temel İşlemler)
  // ---------------------------------------------------------------------------

  /// Verilen [key] ile [value]'yu locale'e kaydeder.
  Future<void> save<T>({required String key, required T value}) async {
    if (value is String) {
      await _prefs.setString(key, value);
    } else if (value is bool) {
      await _prefs.setBool(key, value);
    } else if (value is int) {
      await _prefs.setInt(key, value);
    } else if (value is double) {
      await _prefs.setDouble(key, value);
    } else {
      throw UnsupportedError(
        'LocaleStorageService.save<$T> is not supported. '
        'Supported types: String, bool, int, double.',
      );
    }
  }

  /// Verilen [key] için kaydedilmiş değeri döndürür. Yoksa [null].
  T? read<T>({required String key}) {
    if (T == String) return _prefs.getString(key) as T?;
    if (T == bool) return _prefs.getBool(key) as T?;
    if (T == int) return _prefs.getInt(key) as T?;
    if (T == double) return _prefs.getDouble(key) as T?;
    throw UnsupportedError(
      'LocaleStorageService.read<$T> is not supported. '
      'Supported types: String, bool, int, double.',
    );
  }

  /// Belirtilen [key]'e ait değeri siler.
  Future<void> remove({required String key}) async {
    await _prefs.remove(key);
  }

  /// Tüm kayıtlı değerleri siler.
  Future<void> clear() async {
    await _prefs.clear();
  }

  // ---------------------------------------------------------------------------
  // GLOBAL TOKEN & SON NUMARA YÖNETİMİ
  // ---------------------------------------------------------------------------

  /// Aktif Bearer Token
  String? get bearerToken => read<String>(key: LocaleKeys.bearerToken);

  bool get hasToken => bearerToken != null && bearerToken!.isNotEmpty;

  Future<void> saveToken(String token) =>
      save<String>(key: LocaleKeys.bearerToken, value: token);

  Future<void> removeToken() => remove(key: LocaleKeys.bearerToken);

  /// Son kullanılan telefon numarasını kaydeder / getirir
  String? get lastPhoneNumber => read<String>(key: LocaleKeys.lastPhoneNumber);

  Future<void> setLastPhoneNumber(String phone) =>
      save<String>(key: LocaleKeys.lastPhoneNumber, value: phone);

  // ---------------------------------------------------------------------------
  // TELEFON BAZLI KAYIT & 5. GİRİŞ GÜVENLİK SAYACI
  // ---------------------------------------------------------------------------

  /// Kullanıcı bu telefon numarasıyla daha önce profil kaydını tamamladı mı?
  bool isUserRegistered(String phone) {
    return read<bool>(key: LocaleKeys.isRegisteredKey(phone)) ?? false;
  }

  /// Kullanıcının kayıt durumunu günceller
  Future<void> setUserRegistered(String phone, bool isRegistered) async {
    await save<bool>(
      key: LocaleKeys.isRegisteredKey(phone),
      value: isRegistered,
    );
  }

  /// Telefon numarasına ait saklanan token'ı döndürür
  String? getTokenForPhone(String phone) {
    return read<String>(key: LocaleKeys.tokenKey(phone));
  }

  /// Telefon numarasıyla ilişkili token'ı kaydeder
  Future<void> saveTokenForPhone(String phone, String token) async {
    await save<String>(key: LocaleKeys.tokenKey(phone), value: token);
    // Global token'ı da güncelle
    await saveToken(token);
    await setLastPhoneNumber(phone);
  }

  /// Bu telefonla kaç kez hızlı giriş yapıldığını döndürür (varsayılan: 0)
  int getLoginCount(String phone) {
    return read<int>(key: LocaleKeys.loginCountKey(phone)) ?? 0;
  }

  /// Giriş sayacını 1 artırır
  Future<int> incrementLoginCount(String phone) async {
    final current = getLoginCount(phone);
    final next = current + 1;
    await save<int>(key: LocaleKeys.loginCountKey(phone), value: next);
    return next;
  }

  /// 5. giriş sonrası veya yeni SMS sonrası sayacı sıfırlar
  Future<void> resetLoginCount(String phone) async {
    await save<int>(key: LocaleKeys.loginCountKey(phone), value: 0);
  }

  // ---------------------------------------------------------------------------
  // KULLANICI PROFİL BİLGİLERİ (İSİM, SOYİSİM, E-POSTA)
  // ---------------------------------------------------------------------------

  /// Kullanıcının profil bilgilerini SharedPreferences'a kaydeder
  Future<void> saveUserProfile({
    required String name,
    required String surname,
    String? email,
  }) async {
    await save<String>(key: LocaleKeys.userName, value: name);
    await save<String>(key: LocaleKeys.userSurname, value: surname);
    if (email != null && email.isNotEmpty) {
      await save<String>(key: LocaleKeys.userEmail, value: email);
    } else {
      await remove(key: LocaleKeys.userEmail);
    }
  }

  /// Kayıtlı Ad
  String? get userName => read<String>(key: LocaleKeys.userName);

  /// Kayıtlı Soyad
  String? get userSurname => read<String>(key: LocaleKeys.userSurname);

  /// Kayıtlı E-posta
  String? get userEmail => read<String>(key: LocaleKeys.userEmail);

  /// Kayıtlı Ad Soyad (Boşsa varsayılan metin döner)
  String get userFullName {
    final n = userName ?? '';
    final s = userSurname ?? '';
    final full = '$n $s'.trim();
    return full.isNotEmpty ? full : 'Sayın Renault Kullanıcısı';
  }
}
