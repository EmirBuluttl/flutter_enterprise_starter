import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'core/constants/app_constants.dart';
import 'core/init/theme/app_theme.dart';
import 'feature/login/view/renault_port_login_view.dart';
import 'product/theme/theme_view_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const EnterpriseApp());
}

/// Root Application Widget observing Theme state
class EnterpriseApp extends StatelessWidget {
  const EnterpriseApp({super.key});

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
        home: const RenaultPortLoginView(),
      ),
    );
  }
}
