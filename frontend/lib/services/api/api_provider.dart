import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Centraliza a configuração do cliente HTTP baseado em Dio.
class ApiProvider {
  static const String _apiBaseUrl = 'http://192.168.1.4:8000/api/v1';

  ApiProvider._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _resolveBaseUrl(),
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        responseType: ResponseType.json,
        contentType: 'application/json',
      ),
    );

    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestBody: true,
          responseBody: true,
          error: true,
          responseHeader: false,
          requestHeader: false,
        ),
      );
    }
  }

  static final ApiProvider _instance = ApiProvider._internal();

  late final Dio _dio;

  static ApiProvider get instance => _instance;

  Dio get dio => _dio;

  String _resolveBaseUrl() {
    return _apiBaseUrl;
  }
}

class ApiException implements Exception {
  const ApiException({required this.message, this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() =>
      'ApiException(statusCode: $statusCode, message: $message)';
}
