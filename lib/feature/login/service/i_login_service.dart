import '../model/login_request_model.dart';
import '../model/login_response_model.dart';

/// Abstract service contract for Login operations
abstract class ILoginService {
  Future<LoginResponseModel> login(LoginRequestModel request);
}
