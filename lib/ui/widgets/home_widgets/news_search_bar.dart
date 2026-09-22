import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/core/constants/app_strings.dart';
import 'package:news/providers/search_news_provider.dart';

class NewsSearchBar extends ConsumerStatefulWidget {
  const NewsSearchBar({super.key});

  @override
  ConsumerState<NewsSearchBar> createState() => _NewsSearchBarState();
}

class _NewsSearchBarState extends ConsumerState<NewsSearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: ref.read(searchQueryProvider));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: ref.read(searchQueryProvider.notifier).set,
      onSubmitted: ref.read(searchQueryProvider.notifier).setImmediate,
      textInputAction: .search,
      decoration: InputDecoration(
        hintText: AppStrings.searchNews,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: BorderSide.none,
        ),
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _controller.text.isEmpty
            ? null
            : IconButton(
                onPressed: () {
                  _controller.clear();
                  ref.read(searchQueryProvider.notifier).set('');
                  setState(() {});
                },
                icon: const Icon(Icons.clear),
              ),
      ),
    );
  }
}
