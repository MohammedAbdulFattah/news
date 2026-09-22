import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/notifiers/search_news_notifier.dart';

final searchNewsProvider = AsyncNotifierProvider(SearchNewsNotifier.new);
final searchQueryProvider = NotifierProvider(SearchQueryNotifier.new);
final searchFromProvider = NotifierProvider(SearchFromNotifier.new);
final searchToProvider = NotifierProvider(SearchToNotifier.new);
final searchSortByProvider = NotifierProvider(SearchSortByNotifier.new);
