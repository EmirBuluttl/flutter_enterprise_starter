import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_enterprise_starter/core/constants/app_constants.dart';
import 'package:flutter_enterprise_starter/main.dart';
import 'package:flutter_enterprise_starter/product/widgets/custom_primary_button.dart';

void main() {
  testWidgets('EnterpriseApp renders login screen with UI components', (WidgetTester tester) async {
    await tester.pumpWidget(const EnterpriseApp());

    // Verify header and form elements
    expect(find.text(AppStrings.appTitle), findsOneWidget);
    expect(find.text(AppStrings.phoneLabel), findsOneWidget);
    expect(find.byType(CustomPrimaryButton), findsOneWidget);

    // Button should initially be disabled
    final buttonFinder = find.byType(ElevatedButton);
    expect(buttonFinder, findsOneWidget);
    final ElevatedButton elevatedButton = tester.widget(buttonFinder);
    expect(elevatedButton.onPressed, isNull);

    // Enter phone digits into TextField
    final textFieldFinder = find.byType(TextField);
    expect(textFieldFinder, findsOneWidget);

    await tester.enterText(textFieldFinder, '5551234567');
    await tester.pump();

    // Verify theme toggle button works
    final themeToggleFinder = find.byKey(const Key('theme_toggle_button'));
    expect(themeToggleFinder, findsOneWidget);
    await tester.tap(themeToggleFinder);
    await tester.pumpAndSettle();
  });
}
