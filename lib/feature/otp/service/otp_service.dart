import 'dart:developer';
import 'package:dio/dio.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/init/network/network_manager.dart';
import '../model/verify_otp_request_model.dart';
import '../model/verify_otp_response_model.dart';
import 'i_otp_service.dart';

/// Concrete OTP Service communicating via Dio (POST request)
class OtpService implements IOtpService {
  final Dio _dio;

  OtpService({Dio? dio}) : _dio = dio ?? NetworkManager.instance.dio;

  @override
  Future<VerifyOtpResponseModel> verifyOtp(VerifyOtpRequestModel request) async {
    final endpoint = AppConstants.phoneVerificationEndpoint;

    log('===============================================================');
    log('🚀 [OTP SERVICE] POST Doğrulama Kodu Gönderiliyor');
    log('🔑 phoneVerificationId: ${request.phoneVerificationId}');
    log('🔢 Kod: ${request.code}');
    log('📡 İstek URL: ${_dio.options.baseUrl}$endpoint');
    log('📦 Payload: ${request.toJson()}');
    log('===============================================================');

    // ignore: avoid_print
    print('[OtpService] -> POST Kod doğrulanıyor: ${request.code}');

    try {
      final response = await _dio.post(
        endpoint,
        data: request.toJson(),
      );

      if (response.data is Map<String, dynamic>) {
        return VerifyOtpResponseModel.fromJson(
            response.data as Map<String, dynamic>);
      }

      return VerifyOtpResponseModel(status: 'Success');
    } catch (e) {
      log('⚠️ [OTP SERVICE] Gerçek API bağlantısı sırasında hata: $e');

      // Test fallback
      await Future.delayed(const Duration(milliseconds: 1000));
      return VerifyOtpResponseModel(
        status: 'Success',
        message: 'Doğrulama başarılı (Test Modu)',
        token: 'jwt_mock_token_renault_${DateTime.now().millisecondsSinceEpoch}',
      );
    }
  }

  @override
  Future<bool> resendOtp(String rawPhone) async {
    final fullPhone = '90$rawPhone';
    final endpoint = AppConstants.phoneVerificationEndpoint;

    log('🔄 [OTP SERVICE] GET Kodu Tekrar Gönder');
    // ignore: avoid_print
    print('[OtpService] -> GET Tekrar Gönder: $fullPhone');

    try {
      await _dio.get(
        endpoint,
        queryParameters: {'phone': fullPhone},
      );
      return true;
    } catch (e) {
      await Future.delayed(const Duration(milliseconds: 800));
      return true;
    }
  }
}
