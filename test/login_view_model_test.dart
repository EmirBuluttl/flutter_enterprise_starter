import 'package:flutter_test/flutter_test.dart';
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
  group('LoginViewModel MobX Tests', () {
    late LoginViewModel viewModel;
    late MockLoginService mockService;

    setUp(() {
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

      final future = viewModel.submitLogin();
      expect(viewModel.isLoading, isTrue);

      await future;

      expect(viewModel.isLoading, isFalse);
      expect(mockService.wasCalled, isTrue);
      expect(mockService.lastPhone, '5559876543');
      expect(viewModel.verificationResult?.isSuccess, isTrue);
      expect(viewModel.verificationResult?.data?.phoneVerification?.id, 'test_guid_123');
    });
  });
}
