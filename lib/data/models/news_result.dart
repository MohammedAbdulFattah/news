import 'package:news/data/models/article.dart';

class NewsResult {
  final int totalResults;
  final List<Article> articles;

  const NewsResult({required this.totalResults, required this.articles});

  factory NewsResult.fromJson(Map<String, dynamic> json) {
    return NewsResult(
      totalResults: json['totalResults'] as int? ?? 0,
      articles: (json['articles'] as List? ?? [])
          .map((e) => Article.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  NewsResult copyWith({int? totalResults, List<Article>? articles}) {
    return NewsResult(
      totalResults: totalResults ?? this.totalResults,
      articles: articles ?? this.articles,
    );
  }
}
