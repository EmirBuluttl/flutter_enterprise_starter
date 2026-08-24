import 'dart:developer';
import 'package:dio/dio.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/init/network/network_manager.dart';
import '../model/verify_otp_request_model.dart';
import '../model/verify_otp_response_model.dart';
import 'i_otp_service.dart';

/// Concrete OTP Service communicating via Dio (Strict Backend Verification)
class OtpService implements IOtpService {
  final Dio _dio;

  OtpService({Dio? dio}) : _dio = dio ?? NetworkManager.instance.dio;

  @override
  Future<VerifyOtpResponseModel> verifyOtp(VerifyOtpRequestModel request) async {
    final endpoint = AppConstants.phoneVerificationEndpoint;

    final finalRequest = VerifyOtpRequestModel(
      phoneVerificationId: request.phoneVerificationId,
      code: request.code,
      notificationToken: request.notificationToken,
    );

    log('===============================================================');
    log('🚀 [OTP SERVICE] POST Kodu Doğrula');
    log('🔑 phoneVerificationId: ${finalRequest.phoneVerificationId}');
    log('🔢 Kod: ${finalRequest.code}');
    log('📡 İstek URL: ${_dio.options.baseUrl}$endpoint');
    log('📦 Payload: ${finalRequest.toJson()}');
    log('===============================================================');

    // ignore: avoid_print
    print('---------------------------------------------------------------');
    // ignore: avoid_print
    print('[OtpService] -> POST İstek Gönderiliyor: ${_dio.options.baseUrl}$endpoint');
    // ignore: avoid_print
    print('Payload: ${finalRequest.toJson()}');

    try {
      final response = await _dio.post(
        endpoint,
        data: finalRequest.toJson(),
      );

      // ignore: avoid_print
      print('[OtpService] -> REAL SERVER HTTP STATUS: ${response.statusCode}');
      // ignore: avoid_print
      print('[OtpService] -> REAL SERVER RESPONSE BODY: ${response.data}');

      // Only treat 200 and 201 as valid success HTTP status
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data is Map<String, dynamic>) {
          final parsed = VerifyOtpResponseModel.fromJson(
              response.data as Map<String, dynamic>);
          
          if (parsed.status.isEmpty) {
            return VerifyOtpResponseModel(
              status: 'Success',
              data: parsed.data,
              token: parsed.token,
            );
          }
          return parsed;
        }
        return VerifyOtpResponseModel(status: 'Success');
      }

      // Any HTTP status other than 200/201 is a failure
      String serverError = 'Girdiğiniz doğrulama kodu hatalıdır. Lütfen tekrar deneyiniz.';
      if (response.data is Map<String, dynamic>) {
        final map = response.data as Map<String, dynamic>;
        if (map['error'] is Map<String, dynamic> && map['error']['message'] != null) {
          serverError = map['error']['message'] as String;
        } else if (map['message'] is String) {
          serverError = map['message'] as String;
        }
      }

      return VerifyOtpResponseModel(
        status: 'Fail',
        message: serverError,
      );
    } on DioException catch (e) {
      log('❌ [OTP SERVICE] Backend Hata Yanıtı (HTTP ${e.response?.statusCode}): ${e.response?.data}');

      // ignore: avoid_print
      print('[OtpService] -> ERROR HTTP STATUS: ${e.response?.statusCode}');
      // ignore: avoid_print
      print('[OtpService] -> ERROR RESPONSE DATA: ${e.response?.data}');

      String serverErrorMessage =
          'Girdiğiniz doğrulama kodu hatalıdır. Lütfen tekrar deneyiniz.';

      if (e.response?.data is Map<String, dynamic>) {
        final data = e.response!.data as Map<String, dynamic>;
        if (data.containsKey('error') && data['error'] is Map<String, dynamic>) {
          final errObj = data['error'] as Map<String, dynamic>;
          if (errObj.containsKey('message') && errObj['message'] is String) {
            serverErrorMessage = errObj['message'] as String;
          }
        } else if (data.containsKey('message') && data['message'] is String) {
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
