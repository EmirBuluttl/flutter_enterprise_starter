import 'dart:developer';
import 'package:dio/dio.dart';

/// Generic Interceptor for logging, request enrichment, and error standardization
class CoreInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log('══════════════════════ [DIO REQUEST] ══════════════════════');
    log('➡️ URL: ${options.method.toUpperCase()} ${options.baseUrl}${options.path}');
    log('➡️ Headers: ${options.headers}');
    if (options.data != null) {
      log('➡️ Request Body: ${options.data}');
    }
    if (options.queryParameters.isNotEmpty) {
      log('➡️ Query Params: ${options.queryParameters}');
    }
    log('═══════════════════════════════════════════════════════════');

    // Add standard enterprise headers (e.g. Accept, Content-Type, Client-Version)
    options.headers['Accept'] = 'application/json';
    options.headers['Content-Type'] = 'application/json';
    options.headers['X-Client-Platform'] = 'Flutter';

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log('══════════════════════ [DIO RESPONSE] ═════════════════════');
    log('✅ Status: ${response.statusCode} (${response.statusMessage})');
    log('✅ Path: ${response.requestOptions.path}');
    log('✅ Response Data: ${response.data}');
    log('═══════════════════════════════════════════════════════════');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log('══════════════════════ [DIO ERROR] ════════════════════════');
    log('❌ Error Type: ${err.type}');
    log('❌ URL: ${err.requestOptions.uri}');
    log('❌ Message: ${err.message}');
    log('❌ Response: ${err.response?.data}');
    log('═══════════════════════════════════════════════════════════');

    super.onError(err, handler);
  }
}
