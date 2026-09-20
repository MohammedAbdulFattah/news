import 'package:flutter/material.dart';

class CenteredDivider extends StatelessWidget {
  const CenteredDivider({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: child,
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}
