import 'package:dio/dio.dart';
import '../../constants/app_constants.dart';
import 'core_interceptor.dart';

/// Singleton Network Manager wrapping Dio client with redirect & SSL support
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
        // Accept 2xx (Success) and 3xx (Redirects)
        return status != null && status < 400;
      },
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    dio = Dio(baseOptions);
    dio.interceptors.add(CoreInterceptor());
  }
}
