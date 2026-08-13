import 'package:flutter/material.dart';
import '../view_model/base_view_model.dart';

/// BaseView lifecycle container for connecting ViewModel to the View layer
class BaseView<T extends BaseViewModel> extends StatefulWidget {
  final T viewModel;
  final Widget Function(BuildContext context, T value) onPageBuilder;
  final void Function(T model)? onModelReady;
  final VoidCallback? onDispose;

  const BaseView({
    super.key,
    required this.viewModel,
    required this.onPageBuilder,
    this.onModelReady,
    this.onDispose,
  });

  @override
  State<BaseView<T>> createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends BaseViewModel> extends State<BaseView<T>> {
  late T model;

  @override
  void initState() {
    super.initState();
    model = widget.viewModel;
    widget.onModelReady?.call(model);
  }

  @override
  void dispose() {
    widget.onDispose?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    model.setContext(context);
    return widget.onPageBuilder(context, model);
  }
}
