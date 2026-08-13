import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../../core/base/view/base_view.dart';
import '../../../core/constants/app_constants.dart';
import '../../../product/theme/theme_view_model.dart';
import '../../../product/widgets/custom_phone_field.dart';
import '../../../product/widgets/custom_primary_button.dart';
import '../view_model/login_view_model.dart';

/// Login Screen following Clean MVVM + MobX architecture
class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeViewModel = ThemeViewModel.instance;

    return BaseView<LoginViewModel>(
      viewModel: LoginViewModel(),
      onModelReady: (model) {
        model.init();
      },
      onPageBuilder: (context, viewModel) {
        final theme = Theme.of(context);

        return Scaffold(
          appBar: AppBar(
            title: Text(AppStrings.appTitle),
            centerTitle: false,
            actions: [
              // Theme Toggle Button (Stateless component observing ThemeViewModel)
              Observer(
                builder: (_) => IconButton(
                  key: const Key('theme_toggle_button'),
                  tooltip: themeViewModel.isDarkMode
                      ? AppStrings.lightMode
                      : AppStrings.darkMode,
                  icon: Icon(
                    themeViewModel.isDarkMode
                        ? Icons.light_mode_rounded
                        : Icons.dark_mode_rounded,
                  ),
                  onPressed: () => themeViewModel.toggleTheme(),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header Component (Stateless)
                      const _LoginHeader(),
                      const SizedBox(height: 32),

                      // Form Container Card
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Custom Phone Field (Stateless)
                              CustomPhoneField(
                                onDigitsChanged: (digits) {
                                  viewModel.setPhoneNumber(digits);
                                },
                              ),
                              const SizedBox(height: 12),

                              // Validation & Info Helper (Observing MobX State)
                              Observer(
                                builder: (_) => _PhoneValidationInfo(
                                  rawDigits: viewModel.rawPhoneNumber,
                                  isValid: viewModel.isPhoneValid,
                                  errorMessage: viewModel.errorMessage,
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Reactive Login Button (Observing isButtonEnabled & isLoading)
                              Observer(
                                builder: (_) => CustomPrimaryButton(
                                  text: viewModel.isLoading
                                      ? AppStrings.loginButtonLoading
                                      : AppStrings.loginButtonText,
                                  isEnabled: viewModel.isButtonEnabled,
                                  isLoading: viewModel.isLoading,
                                  icon: Icons.arrow_forward_rounded,
                                  onPressed: () => viewModel.submitLogin(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Security / Corporate Notice
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.lock_outline_rounded,
                              size: 16,
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                'Uçtan uca şifreli kurumsal iletişim',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Stateless Header Widget
class _LoginHeader extends StatelessWidget {
  const _LoginHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.shield_outlined,
            size: 36,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          AppStrings.loginTitle,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          AppStrings.loginSubtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// Stateless Validation Info Helper
class _PhoneValidationInfo extends StatelessWidget {
  final String rawDigits;
  final bool isValid;
  final String? errorMessage;

  const _PhoneValidationInfo({
    required this.rawDigits,
    required this.isValid,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (errorMessage != null) {
      return Text(
        errorMessage!,
        style: TextStyle(
          fontSize: 12,
          color: theme.colorScheme.error,
          fontWeight: FontWeight.w500,
        ),
      );
    }

    if (rawDigits.isNotEmpty && !isValid) {
      return Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 14,
            color: theme.colorScheme.error,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              rawDigits.startsWith('5')
                  ? 'Kalan hane: ${AppConstants.rawPhoneLength - rawDigits.length}'
                  : 'Numara 5 ile başlamalıdır (5XX)',
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}
