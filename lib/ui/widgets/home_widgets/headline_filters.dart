import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/core/constants/app_maps.dart';
import 'package:news/core/constants/app_strings.dart';
import 'package:news/core/enums/news_category.dart';
import 'package:news/core/extensions/context_extension.dart';
import 'package:news/providers/news_provider.dart';
import 'package:news/ui/widgets/app_bottom_sheet.dart';
import 'package:news/ui/widgets/filter_menu_chip.dart';
import 'package:news/ui/widgets/selection_card.dart';

class HeadlineFilters extends ConsumerWidget {
  const HeadlineFilters({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final country = ref.watch(countryFilterProvider);
    final category = ref.watch(categoryFilterProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          CountryFilterChip(
            country: country,
            onTapMobile: () => _showCountrySheet(context, ref),
            onSelected: ref.read(countryFilterProvider.notifier).set,
          ),
          const SizedBox(width: 8),
          CategoryFilterChip(
            category: category,
            onTapMobile: () => _showCategorySheet(context, ref),
            onSelected: ref.read(categoryFilterProvider.notifier).set,
          ),
        ],
      ),
    );
  }

  void _showCountrySheet(BuildContext context, WidgetRef ref) {
    AppBottomSheet.show(
      context: context,
      title: AppStrings.selectCountry,
      child: const CountrySelectionSheet(),
    );
  }

  void _showCategorySheet(BuildContext context, WidgetRef ref) {
    AppBottomSheet.show(
      context: context,
      title: AppStrings.selectCategory,
      child: const CategorySelectionSheet(),
    );
  }
}

class CountryFilterChip extends StatelessWidget {
  final String? country;
  final VoidCallback onTapMobile;
  final ValueChanged<String> onSelected;

  const CountryFilterChip({
    super.key,
    required this.country,
    required this.onTapMobile,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return context.isLargeScreen
        ? FilterMenuChip<String>(
            icon: Icons.public,
            label: country!,
            value: country!,
            items: AppMaps.countryCodes.keys
                .map(
                  (country) =>
                      FilterMenuItem<String>(value: country, title: country),
                )
                .toList(),
            onSelected: onSelected,
          )
        : ActionChip(
            avatar: const Icon(Icons.public, size: 18),
            label: Text(country ?? AppStrings.country),
            onPressed: onTapMobile,
          );
  }
}

class CategoryFilterChip extends StatelessWidget {
  final NewsCategory category;
  final VoidCallback onTapMobile;
  final ValueChanged<NewsCategory> onSelected;

  const CategoryFilterChip({
    super.key,
    required this.category,
    required this.onTapMobile,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final label = category == NewsCategory.all
        ? AppStrings.category
        : NewsCategory.format(category);

    return context.isLargeScreen
        ? FilterMenuChip<NewsCategory>(
            icon: Icons.category_outlined,
            label: category == NewsCategory.all
                ? AppStrings.category
                : NewsCategory.format(category),
            value: category,
            items: NewsCategory.values
                .map(
                  (category) => FilterMenuItem(
                    value: category,
                    title: NewsCategory.format(category),
                  ),
                )
                .toList(),
            onSelected: onSelected,
          )
        : ActionChip(
            avatar: const Icon(Icons.category_outlined, size: 18),
            label: Text(label),
            onPressed: onTapMobile,
          );
  }
}

class CountrySelectionSheet extends ConsumerWidget {
  const CountrySelectionSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCountry = ref.watch(countryFilterProvider);

    return RadioGroup<String>(
      groupValue: selectedCountry,
      onChanged: (value) {
        ref.read(countryFilterProvider.notifier).set(value!);
        Navigator.pop(context);
      },
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: AppMaps.countryCodes.length,
        itemBuilder: (context, index) {
          final country = AppMaps.countryCodes.keys.elementAt(index);

          return SelectionCard<String>(
            title: country,
            value: country,
            onTap: () {
              ref.read(countryFilterProvider.notifier).set(country);

              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}

class CategorySelectionSheet extends ConsumerWidget {
  const CategorySelectionSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(categoryFilterProvider);

    return RadioGroup(
      groupValue: selectedCategory,
      onChanged: (value) {
        ref.read(categoryFilterProvider.notifier).set(value!);
        Navigator.pop(context);
      },
      child: ListView(
        shrinkWrap: true,
        children: NewsCategory.values.map((category) {
          return SelectionCard<NewsCategory>(
            title: NewsCategory.format(category),
            value: category,
            onTap: () {
              ref.read(categoryFilterProvider.notifier).set(category);
              Navigator.pop(context);
            },
          );
        }).toList(),
      ),
    );
  }
}
