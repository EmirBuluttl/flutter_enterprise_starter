import 'dart:developer';
import 'package:dio/dio.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/init/cache/locale_storage_service.dart';
import '../../../core/init/network/network_manager.dart';
import '../model/sign_up_request_model.dart';
import '../model/sign_up_response_model.dart';
import 'i_profile_service.dart';

/// Concrete Profile / Sign-Up Service communicating via Dio
class ProfileService implements IProfileService {
  final Dio _dio;

  ProfileService({Dio? dio}) : _dio = dio ?? NetworkManager.instance.dio;

  @override
  Future<SignUpResponseModel> signUp(SignUpRequestModel request) async {
    final endpoint = AppConstants.signUpEndpoint;
    final token = LocaleStorageService.instance.bearerToken;

    log('===============================================================');
    log('🚀 [PROFILE SERVICE] POST Kayıt Ol (Sign-Up)');
    log('📡 İstek URL: ${_dio.options.baseUrl}$endpoint');
    log('🔑 Bearer Token: ${token != null ? "${token.substring(0, token.length.clamp(0, 15))}..." : "YOK"}');
    log('📦 Payload: ${request.toJson()}');
    log('===============================================================');

    // ignore: avoid_print
    print('---------------------------------------------------------------');
    // ignore: avoid_print
    print('[ProfileService] -> POST İSTEK GÖNDERİLİYOR: ${_dio.options.baseUrl}$endpoint');
    // ignore: avoid_print
    print('[ProfileService] -> REQUEST HEADERS: {Authorization: Bearer $token, ...}');
    // ignore: avoid_print
    print('[ProfileService] -> REQUEST PAYLOAD: ${request.toJson()}');

    try {
      final response = await _dio.post(
        endpoint,
        data: request.toJson(),
        options: Options(
          headers: {
            if (token != null && token.isNotEmpty)
              'Authorization': 'Bearer $token',
          },
        ),
      );

      // ignore: avoid_print
      print('[ProfileService] -> REAL SERVER HTTP STATUS: ${response.statusCode}');
      // ignore: avoid_print
      print('[ProfileService] -> REAL SERVER RESPONSE HEADERS: ${response.headers}');
      // ignore: avoid_print
      print('[ProfileService] -> REAL SERVER RESPONSE BODY: ${response.data}');

      // Sadece 200 ve 201 başarılı kabul edilir
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data is Map<String, dynamic>) {
          final parsed = SignUpResponseModel.fromJson(
            response.data as Map<String, dynamic>,
          );
          if (parsed.status.isEmpty) {
            return SignUpResponseModel(status: 'Success', data: parsed.data);
          }
          return parsed;
        }
        return const SignUpResponseModel(status: 'Success');
      }

      // 200/201 dışındaki durumlar hata
      String serverError =
          'Kayıt işlemi gerçekleştirilemedi. Lütfen bilgilerinizi kontrol ediniz.';
      if (response.data is Map<String, dynamic>) {
        final map = response.data as Map<String, dynamic>;
        if (map['error'] is Map<String, dynamic> &&
            map['error']['message'] != null) {
          serverError = map['error']['message'] as String;
        } else if (map['message'] is String) {
          serverError = map['message'] as String;
        }
      }

      return SignUpResponseModel(status: 'Fail', message: serverError);
    } on DioException catch (e) {
      log('❌ [PROFILE SERVICE] Backend Hata Yanıtı (HTTP ${e.response?.statusCode}): ${e.response?.data}');

      // ignore: avoid_print
      print('[ProfileService] -> ERROR HTTP STATUS: ${e.response?.statusCode}');
      // ignore: avoid_print
      print('[ProfileService] -> ERROR RESPONSE HEADERS: ${e.response?.headers}');
      // ignore: avoid_print
      print('[ProfileService] -> ERROR RESPONSE DATA: ${e.response?.data}');

      String serverErrorMessage =
          'Kayıt işlemi sırasında bir hata oluştu. Lütfen tekrar deneyiniz.';

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

      return SignUpResponseModel(status: 'Fail', message: serverErrorMessage);
    } catch (e) {
      log('⚠️ [PROFILE SERVICE] Genel Sistem Hatası: $e');
      return const SignUpResponseModel(
        status: 'Fail',
        message: 'Kayıt sırasında beklenmeyen bir hata oluştu.',
      );
    }
  }
}
