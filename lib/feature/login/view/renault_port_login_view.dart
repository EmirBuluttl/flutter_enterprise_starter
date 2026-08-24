import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../../core/base/view/base_view.dart';
import '../../../product/widgets/custom_phone_field.dart';
import '../../../product/widgets/renault_logo.dart';
import '../view_model/login_view_model.dart';

/// Pixel-Perfect Replica of the Official Renault Port Phone Input Screen
class RenaultPortLoginView extends StatelessWidget {
  const RenaultPortLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<LoginViewModel>(
      viewModel: LoginViewModel(),
      onModelReady: (model) {
        model.init();
      },
      onPageBuilder: (context, viewModel) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 12),

                  // 1. Renault Diamond Emblem (Centered Top)
                  const Center(
                    child: RenaultLogo(size: 80),
                  ),

                  const SizedBox(height: 50),

                  // 2. Label: "Your phone number" (Sky Blue Accent)
                  const Text(
                    'Your phone number',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0099E6), // Renault Sky Blue Accent
                    ),
                  ),
                  const SizedBox(height: 8),

                  // 3. Underline Phone TextField with Formatter
                  CustomPhoneField(
                    onDigitsChanged: (digits) {
                      viewModel.setPhoneNumber(digits);
                    },
                  ),
                  const SizedBox(height: 12),

                  // Error Message Observer
                  Observer(
                    builder: (_) {
                      if (viewModel.errorMessage != null) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            viewModel.errorMessage!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 13,
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),

                  const SizedBox(height: 28),

                  // 4. Main Action Button: "Continue ➔" (Reactive Observer)
                  Observer(
                    builder: (_) {
                      final isEnabled = viewModel.isButtonEnabled;
                      final isLoading = viewModel.isLoading;

                      return SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isEnabled
                                ? const Color(0xFF0099E6)
                                : const Color(0xFFEBECEF),
                            foregroundColor: isEnabled
                                ? Colors.white
                                : const Color(0xFF374151),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: isEnabled && !isLoading
                              ? () => viewModel.submitLogin()
                              : null,
                          child: isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor:
                                        AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Continue',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(Icons.arrow_forward_rounded, size: 20),
                                  ],
                                ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // 5. "Skip For Now" Text Link (Centered Bottom Option)
                  Center(
                    child: TextButton(
                      onPressed: () {
                        // Skip action
                      },
                      child: const Text(
                        'Skip For Now',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
