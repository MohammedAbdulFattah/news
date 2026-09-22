import 'dart:async';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/core/constants/app_maps.dart';
import 'package:news/core/enums/news_category.dart';
import 'package:news/data/models/news_result.dart';
import 'package:news/providers/news_provider.dart';

class HeadlinesNewsNotifier extends AsyncNotifier<NewsResult> {
  int _page = 1;

  @override
  Future<NewsResult> build() async {
    _page = 1;

    return await _getNewsResult();
  }

  Future<NewsResult> _getNewsResult() async {
    final country = ref.watch(countryFilterProvider);
    final category = ref.watch(categoryFilterProvider);

    final result = await ref
        .read(newsRepositoryProvider)
        .getTopHeadlines(
          country: AppMaps.countryCodes[country],
          category: category.name,
          page: _page,
        );
    return result;
  }

  Future<void> loadNextPage() async {
    final isLoadingNextPage = ref.read(newsPaginationProvider);
    if (isLoadingNextPage || !hasNextPage) {
      return;
    }
    if (!state.hasValue || (state.value?.articles.isEmpty ?? true)) {
      return;
    }
    final currentArticles = state.value!.articles;

    final nextPage = _page + 1;

    final pagination = ref.read(newsPaginationProvider.notifier);
    try {
      pagination.setLoading(true);
      final newNewsResult = await _getNewsResult();

      _page = nextPage;

      state = AsyncData(
        newNewsResult.copyWith(
          articles: [...currentArticles, ...newNewsResult.articles],
        ),
      );
    } catch (e, stackTrace) {
      debugPrint('$e $stackTrace');
    } finally {
      pagination.setLoading(false);
    }
  }

  bool get hasNextPage {
    final result = state.value;

    if (result == null) return false;

    return result.articles.length < result.totalResults;
  }
}

class CountryFilterNotifier extends Notifier<String?> {
  @override
  String? build() => 'United States';

  void set(String country) {
    state = country;
  }
}

class CategoryFilterNotifier extends Notifier<NewsCategory> {
  @override
  NewsCategory build() => NewsCategory.all;

  void set(NewsCategory category) {
    state = category;
  }
}

class NewsPaginationNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void setLoading(bool value) {
    state = value;
  }
}
