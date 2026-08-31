import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_enterprise_starter/core/init/cache/locale_storage_service.dart';
import 'package:flutter_enterprise_starter/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocaleStorageService.init();
    await LocaleStorageService.instance.clear();
  });

  testWidgets('EnterpriseApp renders Renault Port login screen when startWithHome is false', (WidgetTester tester) async {
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

  testWidgets('EnterpriseApp renders HomeView with dynamic user profile when startWithHome is true', (WidgetTester tester) async {
    await LocaleStorageService.instance.saveUserProfile(
      name: 'Emir',
      surname: 'Bulut',
      email: 'emir@example.com',
    );

    await tester.pumpWidget(const EnterpriseApp(startWithHome: true));
    await tester.pumpAndSettle();

    expect(find.text('Emir Bulut'), findsOneWidget);
    expect(find.text('emir@example.com'), findsOneWidget);
  });
}
