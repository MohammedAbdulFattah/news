import 'package:flutter/material.dart';

class SelectionCard<T> extends StatelessWidget {
  final String title;
  final String? subtitle;
  final T value;
  final VoidCallback onTap;

  const SelectionCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(title),
      subtitle: subtitle == null ? null : Text(subtitle!),
      leading: Radio<T>(
        value: value,
      ),
    );
  }
}
