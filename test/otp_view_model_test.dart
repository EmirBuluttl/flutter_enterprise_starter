import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_enterprise_starter/feature/otp/model/verify_otp_request_model.dart';
import 'package:flutter_enterprise_starter/feature/otp/model/verify_otp_response_model.dart';
import 'package:flutter_enterprise_starter/feature/otp/service/i_otp_service.dart';
import 'package:flutter_enterprise_starter/feature/otp/view_model/otp_view_model.dart';

class MockOtpService implements IOtpService {
  bool verifyCalled = false;
  bool resendCalled = false;
  VerifyOtpRequestModel? lastRequest;

  @override
  Future<VerifyOtpResponseModel> verifyOtp(VerifyOtpRequestModel request) async {
    verifyCalled = true;
    lastRequest = request;
    return VerifyOtpResponseModel(
      status: 'Success',
      token: 'jwt_mock_token_123',
    );
  }

  @override
  Future<bool> resendOtp(String rawPhone) async {
    resendCalled = true;
    return true;
  }
}

void main() {
  group('OtpViewModel MobX Tests', () {
    late OtpViewModel viewModel;
    late MockOtpService mockService;

    setUp(() {
      mockService = MockOtpService();
      viewModel = OtpViewModel(
        phoneNumber: '5551234567',
        phoneVerificationId: 'test_guid_456',
        otpService: mockService,
      );
      viewModel.init();
    });

    tearDown(() {
      viewModel.dispose();
    });

    test('Initial state: verify button disabled, otp empty, countdown active', () {
      expect(viewModel.otpCode, isEmpty);
      expect(viewModel.isCodeValid, isFalse);
      expect(viewModel.isVerifyButtonEnabled, isFalse);
      expect(viewModel.countdown, 60);
      expect(viewModel.canResend, isFalse);
      expect(viewModel.formattedCountdown, '01:00');
    });

    test('Invalid and incomplete code entries', () {
      viewModel.setOtpCode('12');
      expect(viewModel.isCodeValid, isFalse);
      expect(viewModel.isVerifyButtonEnabled, isFalse);

      viewModel.setOtpCode('123');
      expect(viewModel.isCodeValid, isFalse);
      expect(viewModel.isVerifyButtonEnabled, isFalse);
    });

    test('4-digit code enables verify button', () {
      viewModel.setOtpCode('1234');
      expect(viewModel.isCodeValid, isTrue);
      expect(viewModel.isVerifyButtonEnabled, isTrue);
    });

    test('submitVerifyOtp calls POST service with payload', () async {
      viewModel.setOtpCode('4321');
      expect(viewModel.isVerifyButtonEnabled, isTrue);

      final future = viewModel.submitVerifyOtp();
      expect(viewModel.isLoading, isTrue);

      await future;

      expect(viewModel.isLoading, isFalse);
      expect(mockService.verifyCalled, isTrue);
      expect(mockService.lastRequest?.code, '4321');
      expect(mockService.lastRequest?.phoneVerificationId, 'test_guid_456');
      expect(viewModel.verifyResult?.isSuccess, isTrue);
    });
  });
}
