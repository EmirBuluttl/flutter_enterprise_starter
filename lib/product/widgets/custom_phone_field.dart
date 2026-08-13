import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../core/constants/app_constants.dart';

/// Stateless custom phone text field with Turkey phone mask (+90 (5XX) XXX XX XX)
class CustomPhoneField extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String> onDigitsChanged;
  final String? errorText;
  final FocusNode? focusNode;

  CustomPhoneField({
    super.key,
    this.controller,
    required this.onDigitsChanged,
    this.errorText,
    this.focusNode,
  });

  // Mask definition for Turkey phone format: +90 (###) ### ## ##
  final MaskTextInputFormatter _phoneFormatter = MaskTextInputFormatter(
    mask: '+90 (###) ### ## ##',
    filter: {'#': RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.phoneLabel,
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.done,
          inputFormatters: [
            LengthLimitingTextInputFormatter(19), // Max characters of +90 (###) ### ## ##
            _phoneFormatter,
          ],
          onChanged: (text) {
            // Extract only the raw 10 digits (e.g., 5551234567) without formatting symbols
            final unmaskedText = _phoneFormatter.getUnmaskedText();
            onDigitsChanged(unmaskedText);
          },
          decoration: InputDecoration(
            hintText: AppStrings.phoneHint,
            prefixIcon: Icon(
              Icons.phone_iphone_rounded,
              color: theme.colorScheme.primary,
            ),
            errorText: errorText,
          ),
        ),
      ],
    );
  }
}
