import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_enterprise_starter/core/init/cache/locale_storage_service.dart';
import 'package:flutter_enterprise_starter/feature/profile/model/sign_up_request_model.dart';
import 'package:flutter_enterprise_starter/feature/profile/model/sign_up_response_model.dart';
import 'package:flutter_enterprise_starter/feature/profile/service/i_profile_service.dart';
import 'package:flutter_enterprise_starter/feature/profile/view_model/profile_view_model.dart';

class MockProfileService implements IProfileService {
  bool wasCalled = false;
  SignUpRequestModel? lastRequest;

  @override
  Future<SignUpResponseModel> signUp(SignUpRequestModel request) async {
    wasCalled = true;
    lastRequest = request;
    return const SignUpResponseModel(
      status: 'Success',
      data: {'id': 'user_123'},
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ProfileViewModel MobX Tests', () {
    late ProfileViewModel viewModel;
    late MockProfileService mockService;
    const testPhone = '5551234567';
    const testVerificationId = 'guid_verify_999';

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await LocaleStorageService.init();
      await LocaleStorageService.instance.clear();

      mockService = MockProfileService();
      viewModel = ProfileViewModel(
        phoneNumber: testPhone,
        phoneVerificationId: testVerificationId,
        profileService: mockService,
      );
      viewModel.init();
    });

    test('Initial state: button disabled, form empty, not loading', () {
      expect(viewModel.name, isEmpty);
      expect(viewModel.surname, isEmpty);
      expect(viewModel.email, isEmpty);
      expect(viewModel.isKvkkAccepted, isFalse);
      expect(viewModel.isCommunicationAccepted, isFalse);
      expect(viewModel.isButtonEnabled, isFalse);
      expect(viewModel.isLoading, isFalse);
    });

    test('Validation: Name and Surname must be at least 2 characters', () {
      viewModel.setName('A');
      expect(viewModel.isNameValid, isFalse);
      viewModel.setName('Ahmet');
      expect(viewModel.isNameValid, isTrue);

      viewModel.setSurname('Y');
      expect(viewModel.isSurnameValid, isFalse);
      viewModel.setSurname('Yılmaz');
      expect(viewModel.isSurnameValid, isTrue);
    });

    test('Validation: Email is optional but if provided must match format', () {
      viewModel.setEmail('');
      expect(viewModel.isEmailValid, isTrue);

      viewModel.setEmail('invalid-email');
      expect(viewModel.isEmailValid, isFalse);

      viewModel.setEmail('test@renault.com.tr');
      expect(viewModel.isEmailValid, isTrue);
    });

    test('Validation: Button enables ONLY when Name, Surname and KVKK are valid', () {
      viewModel.setName('Ahmet');
      viewModel.setSurname('Yılmaz');
      expect(viewModel.isButtonEnabled, isFalse); // KVKK not checked yet

      viewModel.setKvkkAccepted(true);
      expect(viewModel.isButtonEnabled, isTrue); // Now valid!

      viewModel.setEmail('invalid');
      expect(viewModel.isButtonEnabled, isFalse); // Email broken

      viewModel.setEmail('ahmet@test.com');
      expect(viewModel.isButtonEnabled, isTrue); // Valid again
    });

    test('submitSignUp sends full request payload and saves registration', () async {
      viewModel.setName('Emir');
      viewModel.setSurname('Bulut');
      viewModel.setEmail('emir@example.com');
      viewModel.setKvkkAccepted(true);
      viewModel.setCommunicationAccepted(true);

      expect(viewModel.isButtonEnabled, isTrue);

      await viewModel.submitSignUp();

      expect(viewModel.isLoading, isFalse);
      expect(mockService.wasCalled, isTrue);
      expect(mockService.lastRequest?.phoneVerificationId, testVerificationId);
      expect(mockService.lastRequest?.name, 'Emir');
      expect(mockService.lastRequest?.surname, 'Bulut');
      expect(mockService.lastRequest?.email, 'emir@example.com');
      expect(mockService.lastRequest?.kvkkAgreement, isTrue);
      expect(mockService.lastRequest?.smsCa, isTrue);
      expect(mockService.lastRequest?.emailCa, isTrue);
      expect(mockService.lastRequest?.phoneCa, isTrue);

      // Verify that local storage marked user as registered
      expect(LocaleStorageService.instance.isUserRegistered(testPhone), isTrue);
      expect(LocaleStorageService.instance.getLoginCount(testPhone), 1);

      // Verify profile details saved in local storage
      expect(LocaleStorageService.instance.userName, 'Emir');
      expect(LocaleStorageService.instance.userSurname, 'Bulut');
      expect(LocaleStorageService.instance.userEmail, 'emir@example.com');
      expect(LocaleStorageService.instance.userFullName, 'Emir Bulut');
    });
  });
}
