import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/core/constants/app_strings.dart';
import 'package:news/core/enums/sort_by.dart';
import 'package:news/core/extensions/context_extension.dart';
import 'package:news/providers/search_news_provider.dart';
import 'package:news/ui/widgets/app_bottom_sheet.dart';
import 'package:news/ui/widgets/filter_menu_chip.dart';
import 'package:news/ui/widgets/selection_card.dart';

class SearchFilters extends ConsumerWidget {
  const SearchFilters({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final from = ref.watch(searchFromProvider);
    final to = ref.watch(searchToProvider);
    final sortBy = ref.watch(searchSortByProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          SortByFilterChip(
            sortBy: sortBy,
            onTapMobile: () => _showSortSheet(context, ref),
            onSelected: ref.read(searchSortByProvider.notifier).set,
          ),
          const SizedBox(width: 8),
          DateRangeFilterChip(
            from: from,
            to: to,
            onTap: () => _showDatePicker(context, ref),
          ),
        ],
      ),
    );
  }

  void _showDatePicker(BuildContext context, WidgetRef ref) async {
    final currentFrom = ref.read(searchFromProvider);
    final currentTo = ref.read(searchToProvider);

    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: currentFrom, end: currentTo),
      builder: !context.isLargeScreen
          ? null
          : (context, child) => Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 600, maxWidth: 550),
                child: child,
              ),
            ),
    );

    if (range == null) return;

    ref.read(searchFromProvider.notifier).set(range.start);
    ref.read(searchToProvider.notifier).set(range.end);
  }

  void _showSortSheet(BuildContext context, WidgetRef ref) {
    AppBottomSheet.show(
      context: context,
      title: AppStrings.sortBy,
      child: const SortBySelectionSheet(),
    );
  }
}

class DateRangeFilterChip extends StatelessWidget {
  final DateTime from;
  final DateTime to;
  final VoidCallback onTap;

  const DateRangeFilterChip({
    super.key,
    required this.from,
    required this.to,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: const Icon(Icons.date_range, size: 18),
      label: Text('${_format(from)} - ${_format(to)}'),
      onPressed: onTap,
    );
  }

  String _format(DateTime date) {
    return '${date.day}/${date.month}';
  }
}

class SortByFilterChip extends StatelessWidget {
  final SortBy sortBy;
  final VoidCallback onTapMobile;
  final ValueChanged<SortBy> onSelected;

  const SortByFilterChip({
    super.key,
    required this.sortBy,
    required this.onTapMobile,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return context.isLargeScreen
        ? FilterMenuChip<SortBy>(
            icon: Icons.sort,
            label: sortBy.title,
            value: sortBy,
            items: SortBy.values
                .map(
                  (sortBy) =>
                      FilterMenuItem(value: sortBy, title: sortBy.title),
                )
                .toList(),
            onSelected: onSelected,
          )
        : ActionChip(
            avatar: const Icon(Icons.sort, size: 18),
            label: Text(sortBy.title),
            onPressed: onTapMobile,
          );
  }
}

class SortBySelectionSheet extends ConsumerWidget {
  const SortBySelectionSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(searchSortByProvider);

    return RadioGroup<SortBy>(
      groupValue: selected,
      onChanged: (value) {
        ref.read(searchSortByProvider.notifier).set(value!);
        Navigator.pop(context);
      },
      child: ListView(
        shrinkWrap: true,
        children: SortBy.values.map((sortBy) {
          return SelectionCard<SortBy>(
            title: sortBy.title,
            subtitle: sortBy.description,
            value: sortBy,
            onTap: () {
              ref.read(searchSortByProvider.notifier).set(sortBy);

              Navigator.pop(context);
            },
          );
        }).toList(),
      ),
    );
  }
}
