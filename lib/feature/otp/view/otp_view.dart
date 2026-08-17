import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../../core/base/view/base_view.dart';
import '../../../core/constants/app_constants.dart';
import '../../../product/theme/theme_view_model.dart';
import '../../../product/widgets/custom_primary_button.dart';
import '../view_model/otp_view_model.dart';

/// OTP Verification Screen following Clean MVVM + MobX architecture
class OtpView extends StatelessWidget {
  final String phoneNumber;
  final String phoneVerificationId;

  const OtpView({
    super.key,
    required this.phoneNumber,
    required this.phoneVerificationId,
  });

  @override
  Widget build(BuildContext context) {
    final themeViewModel = ThemeViewModel.instance;

    return BaseView<OtpViewModel>(
      viewModel: OtpViewModel(
        phoneNumber: phoneNumber,
        phoneVerificationId: phoneVerificationId,
      ),
      onModelReady: (model) {
        model.init();
      },
      onDispose: () {
        // Handled in BaseView
      },
      onPageBuilder: (context, viewModel) {
        final theme = Theme.of(context);

        return Scaffold(
          appBar: AppBar(
            title: Text(AppStrings.appTitle),
            centerTitle: false,
            actions: [
              Observer(
                builder: (_) => IconButton(
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
                      _OtpHeader(phoneNumber: phoneNumber),
                      const SizedBox(height: 32),

                      // Card Container
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // 4-Digit OTP PIN Input Boxes (Stateless)
                              _OtpPinInput(
                                onCodeChanged: (code) {
                                  viewModel.setOtpCode(code);
                                },
                              ),
                              const SizedBox(height: 20),

                              // Error Message (Observer)
                              Observer(
                                builder: (_) => viewModel.errorMessage != null
                                    ? Padding(
                                        padding: const EdgeInsets.only(bottom: 12),
                                        child: Center(
                                          child: Text(
                                            viewModel.errorMessage!,
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: theme.colorScheme.error,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                              ),

                              // Timer and Resend Row (Observer)
                              Observer(
                                builder: (_) => _ResendTimerSection(
                                  countdownText: viewModel.formattedCountdown,
                                  canResend: viewModel.canResend,
                                  isResending: viewModel.isResending,
                                  onResendPressed: () => viewModel.resendCode(),
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Reactive Verify Button (Observer)
                              Observer(
                                builder: (_) => CustomPrimaryButton(
                                  text: viewModel.isLoading
                                      ? AppStrings.otpButtonLoading
                                      : AppStrings.otpButtonText,
                                  isEnabled: viewModel.isVerifyButtonEnabled,
                                  isLoading: viewModel.isLoading,
                                  icon: Icons.check_circle_outline_rounded,
                                  onPressed: () => viewModel.submitVerifyOtp(),
                                ),
                              ),
                            ],
                          ),
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

/// Stateless OTP Header
class _OtpHeader extends StatelessWidget {
  final String phoneNumber;

  const _OtpHeader({required this.phoneNumber});

  String _formatPhone(String raw) {
    if (raw.length == 10) {
      return '+90 (${raw.substring(0, 3)}) ${raw.substring(3, 6)} ${raw.substring(6, 8)} ${raw.substring(8, 10)}';
    }
    return '+90 $raw';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.sms_outlined,
            size: 36,
            color: theme.brightness == Brightness.dark
                ? theme.colorScheme.primary
                : const Color(0xFFB45309),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          AppStrings.otpTitle,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            children: [
              TextSpan(
                text: _formatPhone(phoneNumber),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: ' ${AppStrings.otpSubtitle}'),
            ],
          ),
        ),
      ],
    );
  }
}

/// Stateless 4-Digit OTP PIN Input Field
class _OtpPinInput extends StatefulWidget {
  final ValueChanged<String> onCodeChanged;

  const _OtpPinInput({required this.onCodeChanged});

  @override
  State<_OtpPinInput> createState() => _OtpPinInputState();
}

class _OtpPinInputState extends State<_OtpPinInput> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      alignment: Alignment.center,
      children: [
        // Hidden transparent text field to capture keyboard input
        Opacity(
          opacity: 0.0,
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            autofocus: true,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(4),
            ],
            onChanged: (text) {
              setState(() {});
              widget.onCodeChanged(text);
            },
          ),
        ),

        // 4 Visual PIN boxes
        GestureDetector(
          onTap: () {
            _focusNode.requestFocus();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(4, (index) {
              final text = _controller.text;
              final digit = index < text.length ? text[index] : '';
              final isFocused = index == text.length && _focusNode.hasFocus;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 58,
                height: 64,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isFocused
                        ? theme.colorScheme.primary
                        : digit.isNotEmpty
                            ? theme.colorScheme.primary.withValues(alpha: 0.6)
                            : theme.colorScheme.onSurface.withValues(alpha: 0.2),
                    width: isFocused ? 2.0 : 1.2,
                  ),
                ),
                child: Center(
                  child: Text(
                    digit,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

/// Stateless Resend Timer Section
class _ResendTimerSection extends StatelessWidget {
  final String countdownText;
  final bool canResend;
  final bool isResending;
  final VoidCallback onResendPressed;

  const _ResendTimerSection({
    required this.countdownText,
    required this.canResend,
    required this.isResending,
    required this.onResendPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (canResend) {
      return Center(
        child: TextButton.icon(
          onPressed: isResending ? null : onResendPressed,
          icon: isResending
              ? const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.refresh_rounded, size: 18),
          label: Text(
            AppStrings.resendCodeText,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
      );
    }

    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer_outlined,
            size: 16,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          const SizedBox(width: 6),
          Text(
            '${AppStrings.resendCountdownText}$countdownText',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
