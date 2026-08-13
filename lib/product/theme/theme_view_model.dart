import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'theme_view_model.g.dart';

class ThemeViewModel extends _ThemeViewModelBase with _$ThemeViewModel {
  static ThemeViewModel? _instance;
  static ThemeViewModel get instance => _instance ??= ThemeViewModel._init();

  ThemeViewModel._init();
  factory ThemeViewModel() => instance;
}

abstract class _ThemeViewModelBase with Store {
  @observable
  ThemeMode themeMode = ThemeMode.light;

  @computed
  bool get isDarkMode => themeMode == ThemeMode.dark;

  @action
  void toggleTheme() {
    themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
  }

  @action
  void setTheme(ThemeMode mode) {
    themeMode = mode;
  }
}
