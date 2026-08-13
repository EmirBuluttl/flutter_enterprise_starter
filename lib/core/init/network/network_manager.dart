import 'package:dio/dio.dart';
import '../../constants/app_constants.dart';
import 'core_interceptor.dart';

/// Singleton Network Manager wrapping Dio client
class NetworkManager {
  static NetworkManager? _instance;
  static NetworkManager get instance => _instance ??= NetworkManager._init();

  late final Dio dio;

  NetworkManager._init() {
    final baseOptions = BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: AppConstants.connectTimeout,
      receiveTimeout: AppConstants.receiveTimeout,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    dio = Dio(baseOptions);
    dio.interceptors.add(CoreInterceptor());
  }
}
