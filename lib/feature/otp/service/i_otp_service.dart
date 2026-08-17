import '../model/verify_otp_request_model.dart';
import '../model/verify_otp_response_model.dart';

/// Abstract service contract for OTP Verification operations
abstract class IOtpService {
  Future<VerifyOtpResponseModel> verifyOtp(VerifyOtpRequestModel request);
  Future<bool> resendOtp(String rawPhone);
}
