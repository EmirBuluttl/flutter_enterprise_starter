import 'dart:developer';
import 'package:dio/dio.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/init/network/network_manager.dart';
import '../model/verify_otp_request_model.dart';
import '../model/verify_otp_response_model.dart';
import 'i_otp_service.dart';

/// Concrete OTP Service communicating via Dio (POST request with rich diagnostic logging)
class OtpService implements IOtpService {
  final Dio _dio;

  OtpService({Dio? dio}) : _dio = dio ?? NetworkManager.instance.dio;

  @override
  Future<VerifyOtpResponseModel> verifyOtp(VerifyOtpRequestModel request) async {
    // Try both standard endpoint and trailing-slash endpoint if 301 redirect occurs
    String endpoint = AppConstants.phoneVerificationEndpoint;

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
        options: Options(
          followRedirects: false, // Catch 301 to inspect Location header
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      // ignore: avoid_print
      print('[OtpService] -> RESPONSE HTTP STATUS: ${response.statusCode}');

      // If server returned 301/302 Redirect, extract the Location header and retry POST directly on target URL!
      if (response.statusCode == 301 || response.statusCode == 302 || response.statusCode == 307 || response.statusCode == 308) {
        final redirectLocation = response.headers.value('location') ?? '';
        // ignore: avoid_print
        print('[OtpService] ⚠️ 301 REDIRECT DETECTED! Target Location: $redirectLocation');

        if (redirectLocation.isNotEmpty) {
          // Retry POST request directly on the target redirect location
          response = await _dio.post(
            redirectLocation,
            data: finalRequest.toJson(),
          );
          // ignore: avoid_print
          print('[OtpService] -> REDIRECT RETRY HTTP STATUS: ${response.statusCode}');
          // ignore: avoid_print
          print('[OtpService] -> REDIRECT RETRY RESPONSE BODY: ${response.data}');
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
      // ignore: avoid_print
      print('[OtpService] -> ERROR LOCATION HEADER: ${e.response?.headers.value('location')}');

      String serverErrorMessage =
          'Girdiğiniz doğrulama kodu hatalıdır. Lütfen tekrar deneyiniz.';

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
