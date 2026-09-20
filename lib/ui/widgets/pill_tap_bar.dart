import 'package:flutter/material.dart';
import 'package:news/core/extensions/context_extension.dart';

class PillTabBar extends StatelessWidget {
  final TabController controller;
  final List<String> tabs;
  final double height;

  const PillTabBar({
    super.key,
    required this.controller,
    required this.tabs,
    this.height = 56,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: TabBar(
        controller: controller,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular((height - 8) / 2),
        ),
        labelColor: context.colorScheme.primary,
        labelStyle: TextStyle(fontSize: 20, fontWeight: .w500),
        overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
          final baseColor = context.colorScheme.primary;
          if (states.contains(WidgetState.pressed)) {
            return baseColor.withValues(alpha: 0.12);
          }
          if (states.contains(WidgetState.hovered)) {
            return baseColor.withValues(alpha: 0.06);
          }
          if (states.contains(WidgetState.focused)) {
            return baseColor.withValues(alpha: 0.08);
          }
          return Colors.transparent;
        }),
        splashBorderRadius: BorderRadius.circular((height - 8) / 2),
        tabs: tabs.map((title) {
          return Tab(
            child: Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: .w500),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
