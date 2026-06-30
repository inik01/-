import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class GlowContainer extends StatelessWidget {
  const GlowContainer({
    super.key,
    required this.child,
    this.active = false,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final bool active;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: active ? AppColors.greenPrimary : AppColors.cardBorder,
          width: active ? 2 : 1,
        ),
        boxShadow: active ? AppColors.greenGlow(blur: 16) : null,
      ),
      child: child,
    );
  }
}
