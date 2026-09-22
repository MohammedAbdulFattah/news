enum SortBy {
  relevancy('relevancy', 'Most relevant', 'Most relevant to query'),
  popularity('popularity', 'Popularity', 'Popular sources and publishers'),
  publishedAt('publishedAt', 'Newest', 'Newest articles come first');

  const SortBy(this.value, this.title, this.description);

  final String value;
  final String title;

  final String description;

  static SortBy fromValue(String value) {
    return SortBy.values.firstWhere(
      (e) => e.value == value,
      orElse: () => SortBy.relevancy,
    );
  }
}
