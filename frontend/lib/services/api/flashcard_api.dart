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

  Future<List<Map<String, dynamic>>> getFlashcards() async {
    try {
      final response = await _dio.get('/flashcards/');

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

  Future<Map<String, dynamic>> getFlashcard(int id) async {
    try {
      final response = await _dio.get('/flashcards/$id/');
      final data = response.data;

      if (data is Map<String, dynamic>) {
        return data;
      }

      throw const ApiException(
        message: 'Resposta inesperada do servidor ao buscar o flashcard.',
      );
    } on DioException catch (error) {
      throw ApiException(
        message: _extractErrorMessage(error),
        statusCode: error.response?.statusCode,
      );
    }
  }

  Future<Map<String, dynamic>> updateFlashcard({
    required int id,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await _dio.patch('/flashcards/$id/', data: data);
      final responseData = response.data;

      if (responseData is Map<String, dynamic>) {
        return responseData;
      }

      throw const ApiException(
        message: 'Resposta inesperada do servidor ao atualizar o flashcard.',
      );
    } on DioException catch (error) {
      throw ApiException(
        message: _extractErrorMessage(error),
        statusCode: error.response?.statusCode,
      );
    }
  }

  Future<void> deleteFlashcard({required int id}) async {
    try {
      await _dio.delete('/flashcards/$id/');
    } on DioException catch (error) {
      throw ApiException(
        message: _extractErrorMessage(error),
        statusCode: error.response?.statusCode,
      );
    }
  }

  Future<List<Map<String, dynamic>>> getReviewFlashcards() async {
    try {
      final response = await _dio.get('/review/');
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

  Future<Map<String, dynamic>> reviewFlashcard({
    required int id,
    required num easinessFactor,
  }) async {
    try {
      final response = await _dio.patch(
        '/review/$id/',
        data: {'easiness_factor': easinessFactor},
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        return data;
      }

      throw const ApiException(
        message: 'Resposta inesperada do servidor ao revisar o flashcard.',
      );
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
