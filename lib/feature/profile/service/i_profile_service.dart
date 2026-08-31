import '../model/sign_up_request_model.dart';
import '../model/sign_up_response_model.dart';

/// Abstract Profile & Sign-Up Service Interface
abstract class IProfileService {
  /// POST /api/v1/customers/sign-up
  Future<SignUpResponseModel> signUp(SignUpRequestModel request);
}
