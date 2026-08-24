import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

/// Stateless custom phone text field with Turkey phone mask (+90 (5XX) XXX XX XX)
class CustomPhoneField extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String> onDigitsChanged;
  final String? errorText;
  final FocusNode? focusNode;
  final String? labelText;

  CustomPhoneField({
    super.key,
    this.controller,
    required this.onDigitsChanged,
    this.errorText,
    this.focusNode,
    this.labelText,
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
        if (labelText != null) ...[
          Text(
            labelText!,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.done,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
          inputFormatters: [
            LengthLimitingTextInputFormatter(19),
            _phoneFormatter,
          ],
          onChanged: (text) {
            final unmaskedText = _phoneFormatter.getUnmaskedText();
            onDigitsChanged(unmaskedText);
          },
          decoration: InputDecoration(
            hintText: '0xxx xxx xxxx',
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
            isDense: true,
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: theme.colorScheme.primary, width: 2.0),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: theme.colorScheme.primary.withValues(alpha: 0.8),
                width: 1.8,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: theme.colorScheme.primary, width: 2.2),
            ),
            errorText: errorText,
          ),
        ),
      ],
    );
  }
}
