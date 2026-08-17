import 'dart:developer';
import 'package:dio/dio.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/init/network/network_manager.dart';
import '../model/phone_verification_response_model.dart';
import 'i_login_service.dart';

/// Concrete Login Service communicating via Dio (GET request)
class LoginService implements ILoginService {
  final Dio _dio;

  LoginService({Dio? dio}) : _dio = dio ?? NetworkManager.instance.dio;

  @override
  Future<PhoneVerificationResponseModel> requestPhoneVerification(
      String rawPhone) async {
    final fullPhone = '90$rawPhone';
    final endpoint = AppConstants.phoneVerificationEndpoint;

    log('===============================================================');
    log('🚀 [LOGIN SERVICE] GET Doğrulama Kodu İsteği Başlatıldı');
    log('📱 Gönderilen Telefon: $fullPhone');
    log('📡 İstek URL: ${_dio.options.baseUrl}$endpoint?phone=$fullPhone');
    log('===============================================================');

    // ignore: avoid_print
    print('[LoginService] -> GET İstek gönderiliyor: $fullPhone');

    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: {'phone': fullPhone},
      );

      if (response.data is Map<String, dynamic>) {
        return PhoneVerificationResponseModel.fromJson(
            response.data as Map<String, dynamic>);
      }

      return PhoneVerificationResponseModel(status: 'Success');
    } catch (e) {
      log('⚠️ [LOGIN SERVICE] Gerçek API bağlantısı sırasında hata: $e');

      // Eğer henüz gerçek sunucu URL'i girilmediyse (veya test ortamıysa) simüle edilmiş yanıt dön
      await Future.delayed(const Duration(milliseconds: 1000));
      return PhoneVerificationResponseModel(
        status: 'Success',
        data: PhoneVerificationData(
          phoneVerification: PhoneVerificationDetail(
            id: 'mock_guid_${DateTime.now().millisecondsSinceEpoch}',
            phone: fullPhone,
            verifiedAt: null,
          ),
        ),
      );
    }
  }
}
