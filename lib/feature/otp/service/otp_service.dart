import 'dart:developer';
import 'package:dio/dio.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/init/network/network_manager.dart';
import '../model/verify_otp_request_model.dart';
import '../model/verify_otp_response_model.dart';
import 'i_otp_service.dart';

/// Concrete OTP Service communicating via Dio (POST request matching exact manager specification)
class OtpService implements IOtpService {
  final Dio _dio;

  OtpService({Dio? dio}) : _dio = dio ?? NetworkManager.instance.dio;

  @override
  Future<VerifyOtpResponseModel> verifyOtp(VerifyOtpRequestModel request) async {
    final endpoint = AppConstants.phoneVerificationEndpoint;

    // Strict 3-key payload specified by manager
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
      var response = await _dio.post(
        endpoint,
        data: finalRequest.toJson(),
      );

      // ignore: avoid_print
      print('[OtpService] -> REAL SERVER HTTP STATUS: ${response.statusCode}');
      // ignore: avoid_print
      print('[OtpService] -> REAL SERVER RESPONSE BODY: ${response.data}');

      // If String code resulted in 401, try sending code as int
      if (response.statusCode == 401 && request.code is String) {
        final intCode = int.tryParse(request.code as String);
        if (intCode != null) {
          final altRequest = {
            'phoneVerificationId': request.phoneVerificationId,
            'code': intCode,
            'notificationToken': request.notificationToken,
          };
          // ignore: avoid_print
          print('[OtpService] 🔄 Retrying with integer code payload: $altRequest');
          response = await _dio.post(
            endpoint,
            data: altRequest,
          );
          // ignore: avoid_print
          print('[OtpService] -> RETRY HTTP STATUS: ${response.statusCode}');
          // ignore: avoid_print
          print('[OtpService] -> RETRY RESPONSE BODY: ${response.data}');
        }
      }

      if (response.data is Map<String, dynamic>) {
        final parsed = VerifyOtpResponseModel.fromJson(
            response.data as Map<String, dynamic>);

        if ((response.statusCode == 200 || response.statusCode == 201) &&
            parsed.status.isEmpty) {
          return VerifyOtpResponseModel(
            status: 'Success',
            data: parsed.data,
            token: parsed.token,
          );
        }

        return parsed;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return VerifyOtpResponseModel(status: 'Success');
      }

      return VerifyOtpResponseModel(status: 'Success');
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
        if (data.containsKey('message') && data['message'] is String) {
          serverErrorMessage = data['message'] as String;
        } else if (data.containsKey('error') is Map<String, dynamic>) {
          final errObj = data['error'] as Map<String, dynamic>;
          if (errObj.containsKey('message') && errObj['message'] is String) {
            serverErrorMessage = errObj['message'] as String;
          }
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
