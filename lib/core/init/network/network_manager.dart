import 'dart:developer';
import 'package:dio/dio.dart';
import '../../constants/app_constants.dart';
import 'core_interceptor.dart';

/// Singleton Network Manager wrapping Dio client with official Renault MAIS headers & session support
class NetworkManager {
  static NetworkManager? _instance;
  static NetworkManager get instance => _instance ??= NetworkManager._init();

  late final Dio dio;

  NetworkManager._init() {
    final baseOptions = BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: AppConstants.connectTimeout,
      receiveTimeout: AppConstants.receiveTimeout,
      followRedirects: true,
      maxRedirects: 5,
      validateStatus: (status) {
        return status != null && status < 500;
      },
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'brand': AppConstants.renaultBrandId,
        'app-version': AppConstants.appVersion,
        'x-lang': 'tr',
        'device-os': 'android',
        'device-model': 'sdk_gphone16k_x86_64',
        'device-os-version': '16',
        'device-id': 'renault_port_device_test_01',
      },
    );

    dio = Dio(baseOptions);
    dio.interceptors.add(CoreInterceptor());
    dio.interceptors.add(_AzureSessionCookieInterceptor());
  }
}

/// Custom Interceptor to persist Azure App Service session cookies (ARRAffinity) across requests
class _AzureSessionCookieInterceptor extends Interceptor {
  String? _savedCookies;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_savedCookies != null && _savedCookies!.isNotEmpty) {
      options.headers['Cookie'] = _savedCookies;
      log('🍪 [SESSION INTERCEPTOR] Attach Cookie to Request: $_savedCookies');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final setCookieHeader = response.headers['set-cookie'];
    if (setCookieHeader != null && setCookieHeader.isNotEmpty) {
      final parsedCookies = setCookieHeader
          .map((cookieStr) => cookieStr.split(';').first.trim())
          .join('; ');
      _savedCookies = parsedCookies;
      log('🍪 [SESSION INTERCEPTOR] Saved Session Cookie: $_savedCookies');
    }
    handler.next(response);
  }
}
