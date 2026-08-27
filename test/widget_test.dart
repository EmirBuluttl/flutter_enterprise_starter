import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_enterprise_starter/main.dart';

void main() {
  testWidgets('EnterpriseApp renders Renault Port login screen bound to AppTheme', (WidgetTester tester) async {
    await tester.pumpWidget(const EnterpriseApp(startWithHome: false));

    // Verify label and buttons
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
