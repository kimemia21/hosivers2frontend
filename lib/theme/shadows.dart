import 'package:flutter/material.dart';
import 'colors.dart';

/// Elevation and shadow system - Modern, Soft Shadows
/// Inspired by modern design systems (Material 3, Tailwind CSS, Shadcn)
/// Access via AppShadows or Theme.of(context).extension<AppShadows>()
class AppShadows extends ThemeExtension<AppShadows> {
  // Light theme shadows - softer, more natural looking
  static const List<BoxShadow> shadowSM = [
    BoxShadow(
      color: Color(0x0A000000), // 4% opacity
      offset: Offset(0, 1),
      blurRadius: 3,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x0D000000), // 5% opacity
      offset: Offset(0, 1),
      blurRadius: 2,
      spreadRadius: 0,
    ),
  ];
  
  static const List<BoxShadow> shadowMD = [
    BoxShadow(
      color: Color(0x0F000000), // 6% opacity
      offset: Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -1,
    ),
    BoxShadow(
      color: Color(0x0A000000), // 4% opacity
      offset: Offset(0, 2),
      blurRadius: 4,
      spreadRadius: -1,
    ),
  ];
  
  static const List<BoxShadow> shadowLG = [
    BoxShadow(
      color: Color(0x14000000), // 8% opacity
      offset: Offset(0, 10),
      blurRadius: 15,
      spreadRadius: -3,
    ),
    BoxShadow(
      color: Color(0x0A000000), // 4% opacity
      offset: Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -2,
    ),
  ];
  
  static const List<BoxShadow> shadowXL = [
    BoxShadow(
      color: Color(0x19000000), // 10% opacity
      offset: Offset(0, 20),
      blurRadius: 25,
      spreadRadius: -5,
    ),
    BoxShadow(
      color: Color(0x0F000000), // 6% opacity
      offset: Offset(0, 10),
      blurRadius: 10,
      spreadRadius: -5,
    ),
  ];
  
  static const List<BoxShadow> shadow2XL = [
    BoxShadow(
      color: Color(0x28000000), // 16% opacity
      offset: Offset(0, 25),
      blurRadius: 50,
      spreadRadius: -12,
    ),
  ];
  
  // Dark theme shadows - more prominent for dark backgrounds
  static const List<BoxShadow> shadowDarkSM = [
    BoxShadow(
      color: Color(0x33000000), // 20% opacity
      offset: Offset(0, 1),
      blurRadius: 3,
      spreadRadius: 0,
    ),
  ];
  
  static const List<BoxShadow> shadowDarkMD = [
    BoxShadow(
      color: Color(0x3D000000), // 24% opacity
      offset: Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -1,
    ),
    BoxShadow(
      color: Color(0x1F000000), // 12% opacity
      offset: Offset(0, 2),
      blurRadius: 4,
      spreadRadius: -1,
    ),
  ];
  
  static const List<BoxShadow> shadowDarkLG = [
    BoxShadow(
      color: Color(0x52000000), // 32% opacity
      offset: Offset(0, 10),
      blurRadius: 15,
      spreadRadius: -3,
    ),
    BoxShadow(
      color: Color(0x29000000), // 16% opacity
      offset: Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -2,
    ),
  ];

  const AppShadows();

  @override
  ThemeExtension<AppShadows> copyWith() => this;

  @override
  ThemeExtension<AppShadows> lerp(ThemeExtension<AppShadows>? other, double t) {
    return this;
  }
}
