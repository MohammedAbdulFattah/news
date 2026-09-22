import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/core/constants/app_secrets.dart';

final dioProvider = Provider(
  (_) => Dio(
    BaseOptions(
      baseUrl: 'https://newsapi.org',
      headers: {
        'X-Api-Key': AppSecrets.apiKey,
        'Content-Type': 'application/json',
      },
      connectTimeout: const Duration(seconds: 7),
      receiveTimeout: const Duration(seconds: 5),
    ),
  ),
);
