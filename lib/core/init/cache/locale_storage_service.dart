import 'package:shared_preferences/shared_preferences.dart';
import 'locale_keys.dart';

/// Merkezi Local Storage Servisi (SharedPreferences Wrapper)
///
/// Singleton olarak çalışır. Uygulama başlangıcında [init()] çağrılarak
/// hazır hale getirilmelidir (main.dart içinde).
///
/// ## Neden Böyle Yapıyoruz?
/// SharedPreferences'ın getInt(), getBool(), setString() gibi onlarca
/// metodunu her yerde ayrı ayrı çağırmak yerine tek bir [save] ve [read]
/// metodu ile generic yapıda tüm tipleri yönetiyoruz.
///
/// ## Kullanım Örnekleri:
/// ```dart
/// // Kaydet
/// await LocaleStorageService.instance.save<String>(
///   key: LocaleKeys.bearerToken,
///   value: 'eyJhbGci...',
/// );
///
/// // Oku
/// final token = LocaleStorageService.instance.read<String>(
///   key: LocaleKeys.bearerToken,
/// );
///
/// // Sil
/// await LocaleStorageService.instance.remove(key: LocaleKeys.bearerToken);
///
/// // Tümünü temizle (çıkış yapınca)
/// await LocaleStorageService.instance.clear();
/// ```
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
  /// SharedPreferences instance'ını hazırlar.
  static Future<void> init() async {
    if (_instance != null) return;
    _instance = LocaleStorageService._();
    _instance!._prefs = await SharedPreferences.getInstance();
  }

  // ---------------------------------------------------------------------------
  // WRITE — Kaydet
  // ---------------------------------------------------------------------------

  /// Verilen [key] ile [value]'yu locale'e kaydeder.
  /// Desteklenen tipler: [String], [bool], [int], [double]
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

  // ---------------------------------------------------------------------------
  // READ — Oku
  // ---------------------------------------------------------------------------

  /// Verilen [key] için kaydedilmiş değeri döndürür.
  /// Değer yoksa [null] döner.
  /// Desteklenen tipler: [String], [bool], [int], [double]
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

  // ---------------------------------------------------------------------------
  // DELETE — Sil
  // ---------------------------------------------------------------------------

  /// Belirtilen [key]'e ait değeri siler.
  Future<void> remove({required String key}) async {
    await _prefs.remove(key);
  }

  /// Tüm kayıtlı değerleri siler. Çıkış yapıldığında kullanılır.
  Future<void> clear() async {
    await _prefs.clear();
  }

  // ---------------------------------------------------------------------------
  // HELPERS — Kısayollar
  // ---------------------------------------------------------------------------

  /// Kayıtlı Bearer Token'ı döndürür. Yoksa [null].
  String? get bearerToken => read<String>(key: LocaleKeys.bearerToken);

  /// Token'ın var olup olmadığını kontrol eder.
  bool get hasToken {
    final token = bearerToken;
    return token != null && token.isNotEmpty;
  }

  /// Token'ı kaydeder.
  Future<void> saveToken(String token) =>
      save<String>(key: LocaleKeys.bearerToken, value: token);

  /// Token'ı siler (çıkış yapılınca).
  Future<void> removeToken() => remove(key: LocaleKeys.bearerToken);
}
