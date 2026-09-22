import 'package:flutter/material.dart';
import 'package:news/core/extensions/context_extension.dart';

class FilterMenuChip<T> extends StatelessWidget {
  final String label;
  final IconData icon;
  final T value;
  final List<FilterMenuItem<T>> items;
  final ValueChanged<T> onSelected;

  const FilterMenuChip({
    super.key,
    required this.label,
    required this.icon,
    required this.value,
    required this.items,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      alignmentOffset: Offset(0, 8),
      style: MenuStyle(
        maximumSize: WidgetStatePropertyAll(Size.fromHeight(300)),
      ),
      builder: (context, controller, child) {
        return ActionChip(
          avatar: Icon(icon, size: 18),
          label: Text(label),
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
        );
      },
      menuChildren: [
        for (final item in items)
          MenuItemButton(
            leadingIcon: item.value == value
                ? Icon(
                    Icons.radio_button_checked_outlined,
                    color: context.colorScheme.primary,
                  )
                : const Icon(Icons.radio_button_off_outlined),
            onPressed: () => onSelected(item.value),
            child: Padding(
              padding: const EdgeInsetsDirectional.only(end: 12.0),
              child: Text(item.title),
            ),
          ),
      ],
    );
  }
}

class FilterMenuItem<T> {
  final T value;
  final String title;

  const FilterMenuItem({required this.value, required this.title});
}
