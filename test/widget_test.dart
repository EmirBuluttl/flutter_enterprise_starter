import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_enterprise_starter/main.dart';
import 'package:flutter_enterprise_starter/product/widgets/renault_logo.dart';

void main() {
  testWidgets('EnterpriseApp renders Renault Port login screen matching store layout', (WidgetTester tester) async {
    await tester.pumpWidget(const EnterpriseApp());

    // Verify logo, label and buttons from screenshot
    expect(find.byType(RenaultLogo), findsOneWidget);
    expect(find.text('Your phone number'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
    expect(find.text('Skip For Now'), findsOneWidget);

    // Verify phone text field is rendered
    final textFieldFinder = find.byType(TextField);
    expect(textFieldFinder, findsOneWidget);

    // Enter valid 10 digits
    await tester.enterText(textFieldFinder, '5551234567');
    await tester.pump();
  });
}
