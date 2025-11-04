import 'package:dio/dio.dart';

import 'api_provider.dart';

export 'api_provider.dart' show ApiException;

class ChatApi {
  ChatApi(this._dio);

  final Dio _dio;

  Future<Map<String, dynamic>> sendMessage(String userMessage) async {
    try {
      final response = await _dio.post(
        '/chat/',
        data: {'user_message': userMessage},
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        return data;
      }

      throw const ApiException(
        message: 'Resposta inesperada do servidor ao enviar a mensagem.',
      );
    } on DioException catch (error) {
      throw ApiException(
        message: _extractErrorMessage(error),
        statusCode: error.response?.statusCode,
      );
    }
  }

  Future<List<Map<String, dynamic>>> fetchMessages() async {
    try {
      final response = await _dio.get('/chat/');
      final data = response.data;

      if (data is List) {
        return data.whereType<Map<String, dynamic>>().toList();
      }
      if (data is Map<String, dynamic>) {
        return [data];
      }

      return const [];
    } on DioException catch (error) {
      throw ApiException(
        message: _extractErrorMessage(error),
        statusCode: error.response?.statusCode,
      );
    }
  }

  String _extractErrorMessage(DioException error) {
    final response = error.response;
    final data = response?.data;

    if (data is Map<String, dynamic>) {
      final detail = data['detail'];
      if (detail is String && detail.isNotEmpty) {
        return detail;
      }

      final firstValue = data.values.firstWhere(
        (value) => value != null,
        orElse: () => null,
      );

      if (firstValue is String && firstValue.isNotEmpty) {
        return firstValue;
      }
      if (firstValue is List && firstValue.isNotEmpty) {
        final item = firstValue.first;
        if (item is String && item.isNotEmpty) {
          return item;
        }
      }
    }

    if (data is List && data.isNotEmpty) {
      final first = data.first;
      if (first is String && first.isNotEmpty) {
        return first;
      }
    }

    return error.message ?? 'Erro ao se comunicar com o servidor.';
  }
}

final chatApi = ChatApi(ApiProvider.instance.dio);
