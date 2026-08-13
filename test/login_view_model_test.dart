import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_enterprise_starter/feature/login/model/login_request_model.dart';
import 'package:flutter_enterprise_starter/feature/login/model/login_response_model.dart';
import 'package:flutter_enterprise_starter/feature/login/service/i_login_service.dart';
import 'package:flutter_enterprise_starter/feature/login/view_model/login_view_model.dart';

class MockLoginService implements ILoginService {
  bool wasCalled = false;
  LoginRequestModel? lastRequest;

  @override
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    wasCalled = true;
    lastRequest = request;
    return LoginResponseModel(
      success: true,
      message: 'Test Login Success',
      token: 'test_token',
      userId: 'test_user_id',
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
      // Less than 10 digits
      viewModel.setPhoneNumber('555123');
      expect(viewModel.isPhoneValid, isFalse);
      expect(viewModel.isButtonEnabled, isFalse);

      // 10 digits but does not start with 5
      viewModel.setPhoneNumber('2121234567');
      expect(viewModel.isPhoneValid, isFalse);
      expect(viewModel.isButtonEnabled, isFalse);
    });

    test('Valid phone number enables submit button', () {
      viewModel.setPhoneNumber('5551234567');
      expect(viewModel.isPhoneValid, isTrue);
      expect(viewModel.isButtonEnabled, isTrue);
    });

    test('submitLogin triggers service and sets loginResult', () async {
      viewModel.setPhoneNumber('5559876543');
      expect(viewModel.isButtonEnabled, isTrue);

      final future = viewModel.submitLogin();
      expect(viewModel.isLoading, isTrue);

      await future;

      expect(viewModel.isLoading, isFalse);
      expect(mockService.wasCalled, isTrue);
      expect(mockService.lastRequest?.formattedPhoneNumber, '+905559876543');
      expect(viewModel.loginResult?.success, isTrue);
    });
  });
}
