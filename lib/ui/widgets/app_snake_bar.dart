import 'package:flutter/material.dart';
import 'package:news/core/extensions/context_extension.dart';

abstract final class AppSnakeBar {
  static void show({
    required BuildContext context,
    required String message,
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isError
            ? context.colorScheme.error
            : context.colorScheme.primary,
        content: Text(
          message,
          style: TextStyle(
            fontSize: 16,
            color: isError
                ? context.colorScheme.onError
                : context.colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}
