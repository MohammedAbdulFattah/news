import 'package:flutter/material.dart';
import 'package:news/core/constants/app_strings.dart';
import 'package:news/core/theme/app_colors.dart';
import 'package:news/data/models/article.dart';
import 'package:shimmer/shimmer.dart';

class NewsArticleCard extends StatelessWidget {
  final Article article;

  const NewsArticleCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {},
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 120,
              height: 144,
              child: article.urlToImage == null
                  ? const Icon(Icons.image_not_supported)
                  : Image.network(
                      article.urlToImage!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) {
                        return const Icon(Icons.image_not_supported);
                      },
                    ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.source?.name ?? AppStrings.unknownSource,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      article.title ?? AppStrings.noTitle,

                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    if (article.publishedAt != null)
                      Text(
                        _formatDate(article.publishedAt!),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class NewsArticleCardShimmer extends StatelessWidget {
  const NewsArticleCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      clipBehavior: Clip.antiAlias,
      child: Shimmer.fromColors(
        baseColor: AppColors.shimmerBaseColor,
        highlightColor: AppColors.shimmerHighlightColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Container(width: 120, height: 144, color: Colors.white),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: 80, height: 12, color: Colors.white),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      height: 14,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      height: 14,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 6),
                    Container(width: 140, height: 14, color: Colors.white),
                    const SizedBox(height: 10),
                    Container(width: 60, height: 10, color: Colors.white),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
