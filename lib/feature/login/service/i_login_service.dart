import '../model/phone_verification_response_model.dart';

/// Abstract service contract for Login & Phone Verification operations
abstract class ILoginService {
  Future<PhoneVerificationResponseModel> requestPhoneVerification(String rawPhone);
}
