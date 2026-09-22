import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/data/repositories/news_repository.dart';
import 'package:news/notifiers/headline_news_notifier.dart';
import 'package:news/providers/dio_provider.dart';

final newsRepositoryProvider = Provider(
  (ref) => NewsRepository(dio: ref.read(dioProvider)),
);

final headlinesNewsProvider = AsyncNotifierProvider(HeadlinesNewsNotifier.new);

final categoryFilterProvider = NotifierProvider(CategoryFilterNotifier.new);
final countryFilterProvider = NotifierProvider(CountryFilterNotifier.new);
final newsPaginationProvider = NotifierProvider(NewsPaginationNotifier.new);
