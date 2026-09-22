import 'package:dio/dio.dart';
import 'package:news/core/enums/news_category.dart';
import 'package:news/core/exceptions/api_exception.dart';
import 'package:news/data/models/news_result.dart';

class NewsRepository {
  final Dio _dio;

  NewsRepository({required this._dio});

  Future<NewsResult> getTopHeadlines({
    String? category,
    String? country,
    int? page,
  }) async {
    final queryParameters = <String, dynamic>{};

    if (category != null && category != NewsCategory.all.name) {
      queryParameters['category'] = category;
    }
    if (country != null) queryParameters['country'] = country;
    if (page != null) queryParameters['page'] = page;

    return _makeRequest('/v2/top-headlines', queryParameters);
  }

  Future<NewsResult> getEverything({
    required String q,
    String? from,
    String? to,
    String? sortBy,
  }) async {
    final queryParameters = <String, dynamic>{'q': q};

    if (from != null) queryParameters['from'] = from;
    if (to != null) queryParameters['to'] = to;
    if (sortBy != null) queryParameters['sortBy'] = sortBy;

    return _makeRequest('/v2/everything', queryParameters);
  }

  Future<NewsResult> _makeRequest(
    String path,
    Map<String, dynamic> queryParameters,
  ) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);

      final data = response.data;

      if (data is! Map<String, dynamic>) {
        throw const ApiException('Invalid response from the server.');
      }

      if (data['status'] != 'ok') {
        final code = data['code'] as String?;
        final message = data['message'] as String?;

        throw ApiException(
          message ?? 'An API error occurred.',
          code: code,
          statusCode: response.statusCode,
        );
      }

      return NewsResult.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
