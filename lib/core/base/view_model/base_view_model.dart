import 'package:flutter/material.dart';

/// Base interface for all ViewModels
abstract class BaseViewModel {
  BuildContext? buildContext;

  void setContext(BuildContext context) {
    buildContext = context;
  }

  void init();
}
