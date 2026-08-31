import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'core/constants/app_constants.dart';
import 'core/init/cache/locale_storage_service.dart';
import 'core/init/theme/app_theme.dart';
import 'feature/home/view/home_view.dart';
import 'feature/login/view/renault_port_login_view.dart';
import 'product/theme/theme_view_model.dart';

/// Uygulama Başlangıcı
///
/// ## Başlangıç Akışı:
/// 1. Flutter binding'leri başlat
/// 2. [LocaleStorageService] başlat (SharedPreferences hazırla)
/// 3. Kayıtlı Bearer Token var mı kontrol et
///    - Varsa  → [HomeView] (tekrar giriş gerekmez)
///    - Yoksa  → [RenaultPortLoginView] (giriş yap)
void main() async {
  // Flutter engine ile Dart kodu arasındaki bağı kur.
  // async işlemler için (SharedPreferences, Firebase vb.) zorunludur.
  WidgetsFlutterBinding.ensureInitialized();

  // LocaleStorageService'i başlat.
  // Bu çağrı SharedPreferences.getInstance()'ı tamamlar ve
  // servisin singleton instance'ını oluşturur.
  await LocaleStorageService.init();

  // Kayıtlı token var mı?
  // Varsa uygulama HomeView'dan başlar, kullanıcıdan tekrar giriş istenmez.
  final hasToken = LocaleStorageService.instance.hasToken;

  runApp(EnterpriseApp(startWithHome: hasToken));
}

/// Root Application Widget
class EnterpriseApp extends StatelessWidget {
  /// true → HomeView'dan başla (token var)
  /// false → LoginView'dan başla (token yok)
  final bool startWithHome;

  const EnterpriseApp({super.key, required this.startWithHome});

  @override
  Widget build(BuildContext context) {
    final themeViewModel = ThemeViewModel.instance;

    return Observer(
      builder: (_) => MaterialApp(
        title: AppStrings.appTitle,
        debugShowCheckedModeBanner: false,
        theme: LightTheme.instance.theme,
        darkTheme: DarkTheme.instance.theme,
        themeMode: themeViewModel.themeMode,
        // Token durumuna göre başlangıç sayfasını belirle
        home: startWithHome
            ? const HomeView()
            : const RenaultPortLoginView(),
      ),
    );
  }
}
