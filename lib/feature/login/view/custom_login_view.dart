import 'package:flutter/material.dart';
import '../../../core/base/view/base_view.dart';
import '../view_model/login_view_model.dart';

class CustomLoginView extends StatelessWidget {
  const CustomLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<LoginViewModel>(
      viewModel: LoginViewModel(),
      onModelReady: (model) {
        model.init();
      },
      onPageBuilder: (context, viewModel) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Renault Port'),
            centerTitle: true,
          ),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: Colors.amber.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.shield_outlined,
                          size: 36,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Giriş Yap',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}