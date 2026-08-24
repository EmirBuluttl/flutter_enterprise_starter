import 'dart:developer';
import 'package:dio/dio.dart';
import '../../constants/app_constants.dart';
import 'core_interceptor.dart';

/// Singleton Network Manager wrapping Dio client with redirect, SSL & Azure Cookie Session support
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
      // Extract cookie strings before semicolon (e.g., ARRAffinity=...; ARRAffinitySameSite=...)
      final parsedCookies = setCookieHeader
          .map((cookieStr) => cookieStr.split(';').first.trim())
          .join('; ');
      _savedCookies = parsedCookies;
      log('🍪 [SESSION INTERCEPTOR] Saved Azure Session Cookie: $_savedCookies');
    }
    handler.next(response);
  }
}
