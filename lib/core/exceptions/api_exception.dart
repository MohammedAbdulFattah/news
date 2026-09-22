import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final String? code;
  final int? statusCode;

  const ApiException(this.message, {this.code, this.statusCode});

  factory ApiException.fromDio(DioException exception) {
    final response = exception.response;

    if (response != null) {
      final statusCode = response.statusCode;
      final data = response.data;

      if (data is Map<String, dynamic>) {
        final code = data['code'] as String?;
        final message = data['message'] as String?;

        return ApiException(
          _getMessage(code: code, fallback: message),
          code: code,
          statusCode: statusCode,
        );
      }

      return ApiException(
        _getStatusCodeMessage(statusCode),
        statusCode: statusCode,
      );
    }

    return ApiException(_getDioErrorMessage(exception));
  }

  static String _getMessage({String? code, String? fallback}) {
    switch (code) {
      case 'apiKeyInvalid':
      case 'apiKeyMissing':
        return 'Your API key is invalid or missing.';

      case 'apiKeyExhausted':
      case 'rateLimited':
        return 'You have exceeded your API rate limit.';

      case 'parametersMissing':
      case 'parameterInvalid':
        return 'Invalid request parameters provided.';

      default:
        return fallback ?? 'An API error occurred.';
    }
  }

  static String _getStatusCodeMessage(int? statusCode) {
    switch (statusCode) {
      case 401:
        return 'Unauthorized request.';

      case 403:
        return 'You do not have permission to access this resource.';

      case 404:
        return 'The requested resource was not found.';

      case 429:
        return 'Too many requests. Please try again later.';

      case 500:
      case 502:
      case 503:
      case 504:
        return 'The server is temporarily unavailable.';

      default:
        return 'An API error occurred.';
    }
  }

  static String _getDioErrorMessage(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timed out. Please try again.';

      case DioExceptionType.connectionError:
        return 'No internet connection. Please check your network.';

      case DioExceptionType.cancel:
        return 'Request was cancelled.';

      case DioExceptionType.badCertificate:
        return 'Could not establish a secure connection.';

      default:
        return 'An unexpected network error occurred.';
    }
  }

  @override
  String toString() => message;
}
