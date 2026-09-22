import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/core/constants/app_strings.dart';
import 'package:news/core/extensions/context_extension.dart';
import 'package:news/providers/authentication_provider.dart';
import 'package:news/providers/news_provider.dart';
import 'package:news/providers/search_news_provider.dart';
import 'package:news/ui/screens/authentication_screen.dart';
import 'package:news/ui/widgets/app_dialog.dart';
import 'package:news/ui/widgets/home_widgets/headline_filters.dart';
import 'package:news/ui/widgets/home_widgets/search_filters.dart';
import 'package:news/ui/widgets/home_widgets/news_article_card.dart';
import 'package:news/ui/widgets/home_widgets/news_search_bar.dart';
import 'package:news/ui/widgets/sticky_header_delegate.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;

    if (position.pixels >= position.maxScrollExtent - 300) {
      ref.read(headlinesNewsProvider.notifier).loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoadingMore = ref.watch(newsPaginationProvider);

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        body: SafeArea(
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              buildSliverAppBar(),

              const NewsList(),
              if (isLoadingMore)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                      child: SizedBox.square(
                        dimension: 40,
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  SliverPersistentHeader buildSliverAppBar() {
    return SliverPersistentHeader(
      pinned: context.isLargeScreen,
      floating: !context.isLargeScreen,
      delegate: StickyHeaderDelegate(
        height: 140,
        child: ColoredBox(
          color: context.colorScheme.surface,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(child: NewsSearchBar()),
                    SizedBox(width: 4),
                    buildLogoutButton(),
                  ],
                ),
              ),
              SizedBox(height: 12),
              HomeFilters(),
              SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  IconButton buildLogoutButton() {
    return IconButton(
      onPressed: () {
        AppDialog.show(
          context: context,
          title: AppStrings.areYouSureToLogout,
          action: FilledButton(
            onPressed: () async {
              await ref.read(authenticationProvider.notifier).logout();
              if (!mounted) return;
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => AuthenticationScreen()),
                (_) => false,
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: context.colorScheme.error,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            child: Text(
              AppStrings.logout,
              style: context.textTheme.bodyLarge?.copyWith(
                color: context.colorScheme.onError,
              ),
            ),
          ),
        );
      },
      icon: Icon(Icons.logout, size: 24),
    );
  }
}

class NewsList extends ConsumerWidget {
  const NewsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(searchQueryProvider);

    final news = query.trim().isEmpty
        ? ref.watch(headlinesNewsProvider)
        : ref.watch(searchNewsProvider);

    return news.when(
      loading: () => SliverPadding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        sliver: SliverGrid.builder(
          itemCount: 12,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 600,
            mainAxisExtent: 142,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemBuilder: (_, _) => const NewsArticleCardShimmer(),
        ),
      ),
      error: (error, stackTrace) => HomeError(messageError: error.toString()),
      data: (result) {
        if (result.articles.isEmpty) {
          return NoArticle();
        }

        return SliverPadding(
          padding: EdgeInsetsGeometry.fromSTEB(16, 0, 16, 24),
          sliver: SliverGrid.builder(
            itemCount: result.articles.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 600,
              mainAxisExtent: 142,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemBuilder: (context, index) {
              return NewsArticleCard(article: result.articles[index]);
            },
          ),
        );
      },
    );
  }
}

class NoArticle extends StatelessWidget {
  const NoArticle({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.article_outlined,
              size: 64,
              color: context.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 12),
            Text(
              AppStrings.noArticlesFound,
              textAlign: TextAlign.center,
              style: context.textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class HomeError extends ConsumerWidget {
  const HomeError({super.key, required this.messageError});

  final String messageError;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.cloud_off_outlined,
                size: 64,
                color: Theme.of(context).colorScheme.outline,
              ),
              const SizedBox(height: 16),
              Text(
                AppStrings.unableToLoadNews,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '$messageError\n${AppStrings.pleaseTryAgain}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () {
                  final query = ref.read(searchQueryProvider);
                  if (query.isEmpty) {
                    ref.invalidate(headlinesNewsProvider, asReload: true);
                  } else {
                    ref.invalidate(searchNewsProvider, asReload: true);
                  }
                },
                icon: const Icon(Icons.refresh),
                label: const Text(AppStrings.tryAgain),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeFilters extends ConsumerWidget {
  const HomeFilters({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(searchQueryProvider);

    if (query.trim().isNotEmpty) {
      return const SearchFilters();
    }

    return const HeadlineFilters();
  }
}
