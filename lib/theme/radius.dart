import 'package:flutter/material.dart';

/// Border radius system for consistent rounded corners
/// Modern, softer corners inspired by contemporary design systems
/// Access via AppRadius or Theme.of(context).extension<AppRadius>()
class AppRadius extends ThemeExtension<AppRadius> {
  // Radius values - slightly larger for more modern feel
  static const double none = 0;
  static const double xs = 4;
  static const double sm = 6;
  static const double md = 10;
  static const double lg = 14;
  static const double xl = 18;
  static const double xxl = 24;
  static const double xxxl = 32;
  static const double full = 9999;
  
  // BorderRadius presets
  static const BorderRadius radiusXS = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius radiusSM = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius radiusMD = BorderRadius.all(Radius.circular(md));
  static const BorderRadius radiusLG = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius radiusXL = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius radiusXXL = BorderRadius.all(Radius.circular(xxl));
  static const BorderRadius radiusFull = BorderRadius.all(Radius.circular(full));
  
  // Component-specific radius - optimized for modern UI
  static const BorderRadius button = radiusLG;
  static const BorderRadius card = radiusXL;
  static const BorderRadius dialog = radiusXXL;
  static const BorderRadius input = radiusLG;
  static const BorderRadius chip = radiusFull;
  static const BorderRadius bottomSheet = BorderRadius.only(
    topLeft: Radius.circular(xxl),
    topRight: Radius.circular(xxl),
  );

  const AppRadius();

  @override
  ThemeExtension<AppRadius> copyWith() => this;

  @override
  ThemeExtension<AppRadius> lerp(ThemeExtension<AppRadius>? other, double t) {
    return this;
  }
}
