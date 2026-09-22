import 'package:flutter/material.dart';
import 'package:news/core/constants/app_strings.dart';
import 'package:news/core/extensions/context_extension.dart';

abstract final class AppDialog {
  static void show({
    required BuildContext context,
    required String title,
    required Widget action,
    String? description,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: context.textTheme.titleLarge),
        content: description == null ? null : Text(description),
        actions: [
          action,
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: Text(AppStrings.cancel),
          ),
        ],
      ),
    );
  }
}
