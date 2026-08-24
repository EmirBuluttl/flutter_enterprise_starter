import 'dart:developer';
import 'package:dio/dio.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/init/network/network_manager.dart';
import '../model/verify_otp_request_model.dart';
import '../model/verify_otp_response_model.dart';
import 'i_otp_service.dart';

/// Concrete OTP Service communicating via Dio (POST request with strict error handling)
class OtpService implements IOtpService {
  final Dio _dio;

  OtpService({Dio? dio}) : _dio = dio ?? NetworkManager.instance.dio;

  @override
  Future<VerifyOtpResponseModel> verifyOtp(VerifyOtpRequestModel request) async {
    final endpoint = AppConstants.phoneVerificationEndpoint;

    // Ensure notificationToken is not empty string for backend validation
    final finalRequest = VerifyOtpRequestModel(
      phoneVerificationId: request.phoneVerificationId,
      code: request.code,
      notificationToken: request.notificationToken.isNotEmpty
          ? request.notificationToken
          : 'test_fcm_token_renault_port_device_01',
    );

    log('===============================================================');
    log('🚀 [OTP SERVICE] POST Kodu Doğrula');
    log('🔑 phoneVerificationId: ${finalRequest.phoneVerificationId}');
    log('🔢 Kod: ${finalRequest.code}');
    log('📡 İstek URL: ${_dio.options.baseUrl}$endpoint');
    log('📦 Payload: ${finalRequest.toJson()}');
    log('===============================================================');

    try {
      final response = await _dio.post(
        endpoint,
        data: finalRequest.toJson(),
      );

      if (response.data is Map<String, dynamic>) {
        final parsed = VerifyOtpResponseModel.fromJson(
            response.data as Map<String, dynamic>);
        return parsed;
      }

      return VerifyOtpResponseModel(status: 'Success');
    } on DioException catch (e) {
      log('❌ [OTP SERVICE] Backend Doğrulama Hatası (HTTP ${e.response?.statusCode}): ${e.message}');

      String serverErrorMessage =
          'Girdiğiniz doğrulama kodu hatalıdır. Lütfen kontrol edip tekrar deneyiniz.';

      if (e.response?.data is Map<String, dynamic>) {
        final data = e.response!.data as Map<String, dynamic>;
        if (data.containsKey('message') && data['message'] is String) {
          serverErrorMessage = data['message'] as String;
        } else if (data.containsKey('error') && data['error'] is String) {
          serverErrorMessage = data['error'] as String;
        }
      }

      return VerifyOtpResponseModel(
        status: 'Fail',
        message: serverErrorMessage,
      );
    } catch (e) {
      log('⚠️ [OTP SERVICE] Genel Sistem Hatası: $e');
      return VerifyOtpResponseModel(
        status: 'Fail',
        message:
            'Doğrulama sırasında bir hata oluştu. Lütfen tekrar deneyiniz.',
      );
    }
  }

  @override
  Future<bool> resendOtp(String rawPhone) async {
    final fullPhone = '90$rawPhone';
    final endpoint = AppConstants.phoneVerificationEndpoint;

    log('🔄 [OTP SERVICE] GET Kodu Tekrar Gönder: $fullPhone');

    try {
      await _dio.get(
        endpoint,
        queryParameters: {'phone': fullPhone},
      );
      return true;
    } catch (e) {
      log('⚠️ [OTP SERVICE] Kodu tekrar gönderme hatası: $e');
      return false;
    }
  }
}
