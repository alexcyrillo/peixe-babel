import 'package:dio/dio.dart';

import 'api_provider.dart';

export 'api_provider.dart' show ApiException;

class FlashcardApi {
  FlashcardApi(this._dio);

  final Dio _dio;

  Future<List<Map<String, dynamic>>> createFlashcards(
    List<String> words,
  ) async {
    if (words.isEmpty) {
      throw const ApiException(
        message: 'Adicione pelo menos uma palavra antes de enviar.',
      );
    }

    try {
      final results = <Map<String, dynamic>>[];

      for (final word in words) {
        final response = await _dio.post(
          '/flashcards/',
          data: {'word': word, 'translation': ''},
        );

        final data = response.data;
        if (data is Map<String, dynamic>) {
          results.add(data);
        } else if (data is List) {
          results.addAll(data.whereType<Map<String, dynamic>>());
        }
      }

      return results;
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
      if (data['detail'] is String) {
        return data['detail'] as String;
      }

      final firstValue = data.values.firstWhere(
        (value) => value != null,
        orElse: () => null,
      );

      if (firstValue is List && firstValue.isNotEmpty) {
        final firstItem = firstValue.first;
        if (firstItem is String) {
          return firstItem;
        }
      }
      if (firstValue is String) {
        return firstValue;
      }
    }

    if (data is List && data.isNotEmpty && data.first is String) {
      return data.first as String;
    }

    return error.message ?? 'Erro ao se comunicar com o servidor.';
  }
}

final flashcardApi = FlashcardApi(ApiProvider.instance.dio);
