import 'package:flutter/material.dart';

abstract final class AppBottomSheet {
  static void show({
    required BuildContext context,
    required Widget child,
    String? title,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null) ...[
                  Text(title, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                ],
                Flexible(child: child),
              ],
            ),
          ),
        );
      },
    );
  }
}
