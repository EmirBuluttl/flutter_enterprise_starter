import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_enterprise_starter/core/init/cache/locale_storage_service.dart';
import 'package:flutter_enterprise_starter/feature/login/model/phone_verification_response_model.dart';
import 'package:flutter_enterprise_starter/feature/login/service/i_login_service.dart';
import 'package:flutter_enterprise_starter/feature/login/view_model/login_view_model.dart';

class MockLoginService implements ILoginService {
  bool wasCalled = false;
  String? lastPhone;

  @override
  Future<PhoneVerificationResponseModel> requestPhoneVerification(String rawPhone) async {
    wasCalled = true;
    lastPhone = rawPhone;
    return PhoneVerificationResponseModel(
      status: 'Success',
      data: PhoneVerificationData(
        phoneVerification: PhoneVerificationDetail(
          id: 'test_guid_123',
          phone: '90$rawPhone',
          verifiedAt: null,
        ),
      ),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LoginViewModel MobX Tests', () {
    late LoginViewModel viewModel;
    late MockLoginService mockService;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await LocaleStorageService.init();
      await LocaleStorageService.instance.clear();

      mockService = MockLoginService();
      viewModel = LoginViewModel(loginService: mockService);
      viewModel.init();
    });

    test('Initial state: button disabled, phone empty, not loading', () {
      expect(viewModel.rawPhoneNumber, isEmpty);
      expect(viewModel.isPhoneValid, isFalse);
      expect(viewModel.isButtonEnabled, isFalse);
      expect(viewModel.isLoading, isFalse);
    });

    test('Invalid phone number cases', () {
      viewModel.setPhoneNumber('555123');
      expect(viewModel.isPhoneValid, isFalse);
      expect(viewModel.isButtonEnabled, isFalse);

      viewModel.setPhoneNumber('2121234567');
      expect(viewModel.isPhoneValid, isFalse);
      expect(viewModel.isButtonEnabled, isFalse);
    });

    test('Valid phone number enables submit button', () {
      viewModel.setPhoneNumber('5551234567');
      expect(viewModel.isPhoneValid, isTrue);
      expect(viewModel.isButtonEnabled, isTrue);
    });

    test('submitLogin triggers GET verification service and sets verificationResult', () async {
      viewModel.setPhoneNumber('5559876543');
      expect(viewModel.isButtonEnabled, isTrue);

      await viewModel.submitLogin();

      expect(viewModel.isLoading, isFalse);
      expect(mockService.wasCalled, isTrue);
      expect(mockService.lastPhone, '5559876543');
      expect(viewModel.verificationResult?.isSuccess, isTrue);
      expect(viewModel.verificationResult?.data?.phoneVerification?.id, 'test_guid_123');
    });

    test('5th login step-up auth: 1..4 bypasses SMS, 5th triggers SMS and resets counter', () async {
      final testPhone = '5551112233';
      await LocaleStorageService.instance.setUserRegistered(testPhone, true);
      await LocaleStorageService.instance.saveTokenForPhone(testPhone, 'mock_token_abc');
      await LocaleStorageService.instance.saveUserProfile(name: 'Test', surname: 'User');

      // 1st login (count 0 -> 1)
      viewModel.setPhoneNumber(testPhone);
      await viewModel.submitLogin();
      expect(mockService.wasCalled, isFalse);
      expect(LocaleStorageService.instance.getLoginCount(testPhone), 1);

      // 2nd login (count 1 -> 2)
      await viewModel.submitLogin();
      expect(mockService.wasCalled, isFalse);
      expect(LocaleStorageService.instance.getLoginCount(testPhone), 2);

      // 3rd login (count 2 -> 3)
      await viewModel.submitLogin();
      expect(mockService.wasCalled, isFalse);
      expect(LocaleStorageService.instance.getLoginCount(testPhone), 3);

      // 4th login (count 3 -> 4)
      await viewModel.submitLogin();
      expect(mockService.wasCalled, isFalse);
      expect(LocaleStorageService.instance.getLoginCount(testPhone), 4);

      // 5th login -> Triggers SMS verification!
      await viewModel.submitLogin();
      expect(mockService.wasCalled, isTrue);
      expect(LocaleStorageService.instance.getLoginCount(testPhone), 0); // Reset
    });
  });
}
