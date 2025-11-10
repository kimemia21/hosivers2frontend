import 'package:flutter/material.dart';

/// Consistent spacing system following 8px grid
/// Access via AppSpacing or Theme.of(context).extension<AppSpacing>()
class AppSpacing extends ThemeExtension<AppSpacing> {
  // Base unit - 8px grid system
  static const double baseUnit = 8.0;
  
  // Spacing scale
  static const double xs = baseUnit * 0.5; // 4px
  static const double sm = baseUnit; // 8px
  static const double md = baseUnit * 2; // 16px
  static const double lg = baseUnit * 3; // 24px
  static const double xl = baseUnit * 4; // 32px
  static const double xxl = baseUnit * 5; // 40px
  static const double xxxl = baseUnit * 6; // 48px
  
  // Component-specific spacing
  static const double cardPadding = md;
  static const double screenPadding = md;
  static const double screenPaddingLarge = lg;
  static const double sectionSpacing = lg;
  static const double itemSpacing = md;
  static const double listItemSpacing = sm;
  
  // Layout spacing
  static const double gridSpacing = md;
  static const double columnSpacing = md;
  static const double rowSpacing = sm;
  
  // Responsive padding
  static EdgeInsets screenPaddingResponsive(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200) {
      return const EdgeInsets.all(xxxl);
    } else if (width >= 900) {
      return const EdgeInsets.all(xl);
    } else if (width >= 600) {
      return const EdgeInsets.all(lg);
    }
    return const EdgeInsets.all(md);
  }
  
  static EdgeInsets cardPaddingResponsive(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200) {
      return const EdgeInsets.all(lg);
    } else if (width >= 900) {
      return const EdgeInsets.all(md);
    }
    return const EdgeInsets.all(md);
  }

  const AppSpacing();

  @override
  ThemeExtension<AppSpacing> copyWith() => this;

  @override
  ThemeExtension<AppSpacing> lerp(ThemeExtension<AppSpacing>? other, double t) {
    return this;
  }
}

/// Spacing helper widgets
class VSpace extends StatelessWidget {
  final double height;
  
  const VSpace(this.height, {super.key});
  
  const VSpace.xs({super.key}) : height = AppSpacing.xs;
  const VSpace.sm({super.key}) : height = AppSpacing.sm;
  const VSpace.md({super.key}) : height = AppSpacing.md;
  const VSpace.lg({super.key}) : height = AppSpacing.lg;
  const VSpace.xl({super.key}) : height = AppSpacing.xl;
  const VSpace.xxl({super.key}) : height = AppSpacing.xxl;
  
  @override
  Widget build(BuildContext context) => SizedBox(height: height);
}

class HSpace extends StatelessWidget {
  final double width;
  
  const HSpace(this.width, {super.key});
  
  const HSpace.xs({super.key}) : width = AppSpacing.xs;
  const HSpace.sm({super.key}) : width = AppSpacing.sm;
  const HSpace.md({super.key}) : width = AppSpacing.md;
  const HSpace.lg({super.key}) : width = AppSpacing.lg;
  const HSpace.xl({super.key}) : width = AppSpacing.xl;
  const HSpace.xxl({super.key}) : width = AppSpacing.xxl;
  
  @override
  Widget build(BuildContext context) => SizedBox(width: width);
}
