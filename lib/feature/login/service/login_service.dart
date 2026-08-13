import 'dart:developer';
import 'package:dio/dio.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/init/network/network_manager.dart';
import '../model/login_request_model.dart';
import '../model/login_response_model.dart';
import 'i_login_service.dart';

/// Concrete Login Service communicating via Dio
class LoginService implements ILoginService {
  final Dio _dio;

  LoginService({Dio? dio}) : _dio = dio ?? NetworkManager.instance.dio;

  @override
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    // Task Requirement: Service katmanında print/log çıktısı veren login işlemi
    log('===============================================================');
    log('🚀 [SERVICE KATMANI] Login butonuna basıldı!');
    log('📱 Gönderilen Telefon Numarası: ${request.formattedPhoneNumber}');
    log('📡 İstek Adresi: ${_dio.options.baseUrl}${AppConstants.loginEndpoint}');
    log('📦 Request Payload: ${request.toJson()}');
    log('===============================================================');

    // Print to standard console as well for quick terminal verification
    // ignore: avoid_print
    print('[LoginService] -> İstek servise ulaştı: ${request.formattedPhoneNumber}');

    // Simulate enterprise network delay (1.2 seconds)
    await Future.delayed(const Duration(milliseconds: 1200));

    // Simulated successful backend response (In production, replace with: await _dio.post(AppConstants.loginEndpoint, data: request.toJson()))
    return LoginResponseModel(
      success: true,
      message: 'Giriş işlemi başarıyla doğrulandı.',
      token: 'jwt_mock_token_enterprise_${DateTime.now().millisecondsSinceEpoch}',
      userId: 'usr_${request.rawPhoneNumber.hashCode}',
    );
  }
}
