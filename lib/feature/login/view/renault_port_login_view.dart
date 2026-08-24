import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../../core/base/view/base_view.dart';
import '../../../product/widgets/custom_phone_field.dart';
import '../view_model/login_view_model.dart';


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
        final theme = Theme.of(context);

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: theme.scaffoldBackgroundColor,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: theme.colorScheme.onSurface,
              ),
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
                  const SizedBox(height: 32),

                  
                  Text(
                    'Your phone number',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),

                  
                  CustomPhoneField(
                    onDigitsChanged: (digits) {
                      viewModel.setPhoneNumber(digits);
                    },
                  ),
                  const SizedBox(height: 12),

                  
                  Observer(
                    builder: (_) {
                      if (viewModel.errorMessage != null) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            viewModel.errorMessage!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.error,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),

                  const SizedBox(height: 28),

                  
                  Observer(
                    builder: (_) {
                      final isEnabled = viewModel.isButtonEnabled;
                      final isLoading = viewModel.isLoading;

                      return SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isEnabled
                                ? theme.colorScheme.primary
                                : theme.disabledColor.withValues(alpha: 0.12),
                            foregroundColor: isEnabled
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.onSurface.withValues(alpha: 0.38),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: isEnabled && !isLoading
                              ? () => viewModel.submitLogin()
                              : null,
                          child: isLoading
                              ? SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      theme.colorScheme.onPrimary,
                                    ),
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

                  
                  Center(
                    child: TextButton(
                      onPressed: () {
                        
                      },
                      child: Text(
                        'Skip For Now',
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
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
