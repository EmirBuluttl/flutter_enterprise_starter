import 'dart:developer';
import 'package:dio/dio.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/init/cache/locale_storage_service.dart';
import '../../../core/init/network/network_manager.dart';
import '../model/verify_otp_request_model.dart';
import '../model/verify_otp_response_model.dart';
import 'i_otp_service.dart';

/// Concrete OTP Service — Strict Backend Verification + Token Storage
///
/// ## Token Akışı:
/// 1. POST /verifications/phone → Sunucu 200 döner
/// 2. Response Header'ından `Authorization: Bearer eyJ...` alınır
/// 3. [LocaleStorageService] üzerinden locale'e kaydedilir
/// 4. Bir sonraki açılışta [main.dart] token'ı okuyarak direkt yönlendirir
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
      phone: request.phone,
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
    print('[OtpService] -> POST İSTEK GÖNDERİLİYOR: ${_dio.options.baseUrl}$endpoint');
    // ignore: avoid_print
    print('[OtpService] -> REQUEST HEADERS: ${_dio.options.headers}');
    // ignore: avoid_print
    print('[OtpService] -> REQUEST PAYLOAD BODY: ${finalRequest.toJson()}');

    try {
      final response = await _dio.post(
        endpoint,
        data: finalRequest.toJson(),
      );

      // ignore: avoid_print
      print('[OtpService] -> REAL SERVER HTTP STATUS: ${response.statusCode}');
      // ignore: avoid_print
      print('[OtpService] -> REAL SERVER RESPONSE HEADERS: ${response.headers}');
      // ignore: avoid_print
      print('[OtpService] -> REAL SERVER RESPONSE BODY: ${response.data}');

      // Sadece 200 ve 201 başarılı kabul edilir
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data is Map<String, dynamic>) {
          final parsed = VerifyOtpResponseModel.fromJson(
            response.data as Map<String, dynamic>,
          );

          // -------------------------------------------------------------------
          // BEARER TOKEN — Header'dan al ve locale'e kaydet
          // -------------------------------------------------------------------
          // Sunucu, Authorization header'ında "Bearer eyJhbGci..." formatında
          // token gönderir. Biz sadece "eyJhbGci..." kısmını kaydediyoruz.
          final authHeader = response.headers.value('authorization') ??
              response.headers.value('Authorization');

          if (authHeader != null && authHeader.isNotEmpty) {
            // "Bearer " önekini kaldırarak sadece token değerini al
            final rawToken = authHeader.startsWith('Bearer ')
                ? authHeader.substring(7)
                : authHeader;

            final phone = finalRequest.phone;
            if (phone != null && phone.isNotEmpty) {
              await LocaleStorageService.instance.saveTokenForPhone(phone, rawToken);
            } else {
              await LocaleStorageService.instance.saveToken(rawToken);
            }

            log('✅ [OTP SERVICE] Bearer Token locale\'e kaydedildi.');
            // ignore: avoid_print
            print('[OtpService] -> ✅ TOKEN KAYDEDILDI: ${rawToken.substring(0, rawToken.length.clamp(0, 20))}...');
          } else {
            log('⚠️ [OTP SERVICE] Authorization header bulunamadı, token kaydedilmedi.');
            // ignore: avoid_print
            print('[OtpService] -> ⚠️ AUTHORIZATION HEADER YOK');
          }

          if (parsed.status.isEmpty) {
            return VerifyOtpResponseModel(
              status: 'Success',
              otpData: parsed.otpData,
            );
          }
          return parsed;
        }
        return VerifyOtpResponseModel(status: 'Success');
      }

      // 200/201 dışındaki her durum başarısızlıktır
      String serverError =
          'Girdiğiniz doğrulama kodu hatalıdır. Lütfen tekrar deneyiniz.';
      if (response.data is Map<String, dynamic>) {
        final map = response.data as Map<String, dynamic>;
        if (map['error'] is Map<String, dynamic> &&
            map['error']['message'] != null) {
          serverError = map['error']['message'] as String;
        } else if (map['message'] is String) {
          serverError = map['message'] as String;
        }
      }

      return VerifyOtpResponseModel(status: 'Fail', message: serverError);
    } on DioException catch (e) {
      log('❌ [OTP SERVICE] Backend Hata Yanıtı (HTTP ${e.response?.statusCode}): ${e.response?.data}');

      // ignore: avoid_print
      print('[OtpService] -> ERROR HTTP STATUS: ${e.response?.statusCode}');
      // ignore: avoid_print
      print('[OtpService] -> ERROR RESPONSE HEADERS: ${e.response?.headers}');
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

      return VerifyOtpResponseModel(status: 'Fail', message: serverErrorMessage);
    } catch (e) {
      log('⚠️ [OTP SERVICE] Genel Sistem Hatası: $e');
      return VerifyOtpResponseModel(
        status: 'Fail',
        message: 'Doğrulama sırasında bir hata oluştu. Lütfen tekrar deneyiniz.',
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
