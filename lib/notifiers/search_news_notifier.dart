import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/core/enums/sort_by.dart';
import 'package:news/data/models/news_result.dart';
import 'package:news/providers/news_provider.dart';
import 'package:news/providers/search_news_provider.dart';

class SearchNewsNotifier extends AsyncNotifier<NewsResult> {
  @override
  Future<NewsResult> build() async {
    final query = ref.watch(searchQueryProvider);
    final from = ref.watch(searchFromProvider);
    final to = ref.watch(searchToProvider);
    final sortBy = ref.watch(searchSortByProvider);
    final repo = ref.read(newsRepositoryProvider);

    return repo.getEverything(
      q: query,
      from: from.toIso8601String(),
      to: to.toIso8601String(),
      sortBy: sortBy.value,
    );
  }
}

class SearchQueryNotifier extends Notifier<String> {
  Timer? _debounce;
  static const _debounceDuration = Duration(milliseconds: 400);

  @override
  String build() {
    ref.onDispose(() => _debounce?.cancel());
    return '';
  }

  void set(String query) {
    _debounce?.cancel();

    if (query.isEmpty) {
      state = '';
      return;
    }

    _debounce = Timer(_debounceDuration, () {
      state = query;
    });
  }

  void setImmediate(String query) {
    _debounce?.cancel();
    state = query;
  }
}

class SearchFromNotifier extends Notifier<DateTime> {
  @override
  DateTime build() => DateTime.now().subtract(Duration(days: 7));

  void set(DateTime value) {
    state = value;
  }
}

class SearchToNotifier extends Notifier<DateTime> {
  @override
  DateTime build() => DateTime.now();

  void set(DateTime value) {
    state = value;
  }
}

class SearchSortByNotifier extends Notifier<SortBy> {
  @override
  SortBy build() => SortBy.publishedAt;

  void set(SortBy value) {
    state = value;
  }
}
