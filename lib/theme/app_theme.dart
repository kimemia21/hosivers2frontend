import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'colors.dart';
import 'text_styles.dart';
import 'spacing.dart';
import 'radius.dart';
import 'shadows.dart';

/// Modern Hospital Management App Theme
/// Implements Material 3 with healthcare-optimized design tokens
class AppTheme {
  AppTheme._(); // Private constructor
  
  // ===== LIGHT THEME =====
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    
    // Color Scheme
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.textOnPrimary,
      primaryContainer: AppColors.primaryContainer,
      onPrimaryContainer: AppColors.primaryDark,
      
      secondary: AppColors.secondary,
      onSecondary: AppColors.white,
      secondaryContainer: AppColors.secondaryContainer,
      onSecondaryContainer: AppColors.secondaryDark,
      
      tertiary: AppColors.info,
      onTertiary: AppColors.white,
      
      error: AppColors.error,
      onError: AppColors.white,
      errorContainer: AppColors.errorContainer,
      onErrorContainer: AppColors.error,
      
      surface: AppColors.surfaceLight,
      onSurface: AppColors.textPrimaryLight,
      surfaceContainerHighest: AppColors.surfaceVariantLight,
      
      outline: AppColors.borderLight,
      outlineVariant: AppColors.dividerLight,
      
      shadow: AppColors.shadowLight,
      scrim: AppColors.overlay,
    ),
    
    scaffoldBackgroundColor: AppColors.backgroundLight,
    
    // App Bar Theme - Clean and modern
    appBarTheme: AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 2,
      centerTitle: false,
      backgroundColor: AppColors.surfaceLight,
      foregroundColor: AppColors.textPrimaryLight,
      surfaceTintColor: AppColors.primary,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      titleTextStyle: AppTextStyles.titleLarge.copyWith(
        color: AppColors.textPrimaryLight,
      ),
      iconTheme: const IconThemeData(
        color: AppColors.textPrimaryLight,
        size: 24,
      ),
    ),
    
    // Card Theme - Modern with subtle elevation
    cardTheme: CardThemeData(
      elevation: 0,
      color: AppColors.surfaceLight,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.card,
        side: BorderSide(
          color: AppColors.borderLight,
          width: 0.5,
        ),
      ),
      margin: EdgeInsets.zero,
    ),
    
    // Input Decoration Theme - Clean and accessible
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceLight,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      border: OutlineInputBorder(
        borderRadius: AppRadius.input,
        borderSide: const BorderSide(color: AppColors.borderLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.input,
        borderSide: const BorderSide(color: AppColors.borderLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppRadius.input,
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppRadius.input,
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: AppRadius.input,
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.input,
        borderSide: BorderSide(color: AppColors.grey300),
      ),
      labelStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textSecondaryLight,
      ),
      hintStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.grey400,
      ),
      errorStyle: AppTextStyles.bodySmall.copyWith(
        color: AppColors.error,
      ),
    ),
    
    // Button Themes - Modern, bold design
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shadowColor: Colors.transparent,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        disabledBackgroundColor: AppColors.grey300,
        disabledForegroundColor: AppColors.textDisabledLight,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md + 2,
        ),
        minimumSize: const Size(64, 52),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.button,
        ),
        textStyle: AppTextStyles.labelLarge.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    ),
    
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        elevation: 0,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md + 2,
        ),
        minimumSize: const Size(64, 52),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.button,
        ),
        textStyle: AppTextStyles.labelLarge.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    ),
    
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary, width: 1.5),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md + 2,
        ),
        minimumSize: const Size(64, 52),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.button,
        ),
        textStyle: AppTextStyles.labelLarge.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    ),
    
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        minimumSize: const Size(48, 40),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.button,
        ),
        textStyle: AppTextStyles.labelLarge,
      ),
    ),
    
    // Floating Action Button - Modern with larger radius
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      elevation: 0,
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      extendedPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
    ),
    
    // Chip Theme
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surfaceVariantLight,
      selectedColor: AppColors.primaryContainer,
      disabledColor: AppColors.grey200,
      deleteIconColor: AppColors.textSecondaryLight,
      labelStyle: AppTextStyles.labelMedium,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.chip,
      ),
    ),
    
    // Dialog Theme - Modern with softer appearance
    dialogTheme: DialogThemeData(
      elevation: 0,
      backgroundColor: AppColors.surfaceLight,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.dialog,
        side: BorderSide(
          color: AppColors.borderLight,
          width: 0.5,
        ),
      ),
      titleTextStyle: AppTextStyles.headlineSmall.copyWith(
        color: AppColors.textPrimaryLight,
        fontWeight: FontWeight.w700,
      ),
      contentTextStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textSecondaryLight,
        height: 1.6,
      ),
    ),
    
    // Bottom Sheet Theme
    bottomSheetTheme: BottomSheetThemeData(
      elevation: 8,
      backgroundColor: AppColors.surfaceLight,
      surfaceTintColor: AppColors.primary,
      shape: const RoundedRectangleBorder(
        borderRadius: AppRadius.bottomSheet,
      ),
      modalBackgroundColor: AppColors.surfaceLight,
    ),
    
    // Snackbar Theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.grey900,
      contentTextStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.white,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.radiusSM,
      ),
      behavior: SnackBarBehavior.floating,
    ),
    
    // Icon Theme
    iconTheme: const IconThemeData(
      color: AppColors.textPrimaryLight,
      size: 24,
    ),
    
    // List Tile Theme
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.radiusSM,
      ),
      iconColor: AppColors.textSecondaryLight,
      textColor: AppColors.textPrimaryLight,
    ),
    
    // Divider Theme
    dividerTheme: const DividerThemeData(
      color: AppColors.dividerLight,
      thickness: 1,
      space: 1,
    ),
    
    // Switch Theme
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.white;
        }
        return AppColors.grey400;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        }
        return AppColors.grey300;
      }),
    ),
    
    // Progress Indicator Theme
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primary,
      linearTrackColor: AppColors.primaryContainer,
      circularTrackColor: AppColors.primaryContainer,
    ),
    
    // Typography
    textTheme: TextTheme(
      displayLarge: AppTextStyles.displayLarge.copyWith(color: AppColors.textPrimaryLight),
      displayMedium: AppTextStyles.displayMedium.copyWith(color: AppColors.textPrimaryLight),
      displaySmall: AppTextStyles.displaySmall.copyWith(color: AppColors.textPrimaryLight),
      headlineLarge: AppTextStyles.headlineLarge.copyWith(color: AppColors.textPrimaryLight),
      headlineMedium: AppTextStyles.headlineMedium.copyWith(color: AppColors.textPrimaryLight),
      headlineSmall: AppTextStyles.headlineSmall.copyWith(color: AppColors.textPrimaryLight),
      titleLarge: AppTextStyles.titleLarge.copyWith(color: AppColors.textPrimaryLight),
      titleMedium: AppTextStyles.titleMedium.copyWith(color: AppColors.textPrimaryLight),
      titleSmall: AppTextStyles.titleSmall.copyWith(color: AppColors.textPrimaryLight),
      bodyLarge: AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimaryLight),
      bodyMedium: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimaryLight),
      bodySmall: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondaryLight),
      labelLarge: AppTextStyles.labelLarge.copyWith(color: AppColors.textPrimaryLight),
      labelMedium: AppTextStyles.labelMedium.copyWith(color: AppColors.textSecondaryLight),
      labelSmall: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondaryLight),
    ),
    
    // Extensions
    extensions: const <ThemeExtension<dynamic>>[
      AppSpacing(),
      AppRadius(),
      AppShadows(),
    ],
  );
  
  // ===== DARK THEME =====
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    
    // Color Scheme
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryLight,
      onPrimary: AppColors.textPrimaryDark,
      primaryContainer: AppColors.primaryDark,
      onPrimaryContainer: AppColors.primaryLight,
      
      secondary: AppColors.secondaryLight,
      onSecondary: AppColors.textPrimaryDark,
      secondaryContainer: AppColors.secondaryDark,
      onSecondaryContainer: AppColors.secondaryLight,
      
      tertiary: AppColors.infoLight,
      onTertiary: AppColors.textPrimaryDark,
      
      error: AppColors.errorLight,
      onError: AppColors.textPrimaryDark,
      errorContainer: AppColors.error,
      onErrorContainer: AppColors.errorLight,
      
      surface: AppColors.surfaceDark,
      onSurface: AppColors.textPrimaryDark,
      surfaceContainerHighest: AppColors.surfaceVariantDark,
      
      outline: AppColors.borderDark,
      outlineVariant: AppColors.dividerDark,
      
      shadow: AppColors.shadowDark,
      scrim: AppColors.overlay,
    ),
    
    scaffoldBackgroundColor: AppColors.backgroundDark,
    
    // App Bar Theme
    appBarTheme: AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 2,
      centerTitle: false,
      backgroundColor: AppColors.surfaceDark,
      foregroundColor: AppColors.textPrimaryDark,
      surfaceTintColor: AppColors.primaryLight,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      titleTextStyle: AppTextStyles.titleLarge.copyWith(
        color: AppColors.textPrimaryDark,
      ),
      iconTheme: const IconThemeData(
        color: AppColors.textPrimaryDark,
        size: 24,
      ),
    ),
    
    // Card Theme - Modern with subtle elevation
    cardTheme: CardThemeData(
      elevation: 0,
      color: AppColors.surfaceDark,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.card,
        side: BorderSide(
          color: AppColors.borderDark,
          width: 0.5,
        ),
      ),
      margin: EdgeInsets.zero,
    ),
    
    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceDark,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      border: OutlineInputBorder(
        borderRadius: AppRadius.input,
        borderSide: const BorderSide(color: AppColors.borderDark),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.input,
        borderSide: const BorderSide(color: AppColors.borderDark),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppRadius.input,
        borderSide: const BorderSide(color: AppColors.primaryLight, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppRadius.input,
        borderSide: const BorderSide(color: AppColors.errorLight),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: AppRadius.input,
        borderSide: const BorderSide(color: AppColors.errorLight, width: 2),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.input,
        borderSide: BorderSide(color: AppColors.grey700),
      ),
      labelStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textSecondaryDark,
      ),
      hintStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.grey600,
      ),
      errorStyle: AppTextStyles.bodySmall.copyWith(
        color: AppColors.errorLight,
      ),
    ),
    
    // Button Themes - Modern, bold design
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shadowColor: Colors.transparent,
        backgroundColor: AppColors.primaryLight,
        foregroundColor: AppColors.textPrimaryDark,
        disabledBackgroundColor: AppColors.grey700,
        disabledForegroundColor: AppColors.textDisabledDark,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md + 2,
        ),
        minimumSize: const Size(64, 52),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.button,
        ),
        textStyle: AppTextStyles.labelLarge.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    ),
    
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        elevation: 0,
        backgroundColor: AppColors.primaryLight,
        foregroundColor: AppColors.textPrimaryDark,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md + 2,
        ),
        minimumSize: const Size(64, 52),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.button,
        ),
        textStyle: AppTextStyles.labelLarge.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    ),
    
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryLight,
        side: const BorderSide(color: AppColors.primaryLight, width: 1.5),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md + 2,
        ),
        minimumSize: const Size(64, 52),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.button,
        ),
        textStyle: AppTextStyles.labelLarge.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    ),
    
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryLight,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        minimumSize: const Size(48, 40),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.button,
        ),
        textStyle: AppTextStyles.labelLarge,
      ),
    ),
    
    // Floating Action Button - Modern with larger radius
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      elevation: 0,
      backgroundColor: AppColors.primaryLight,
      foregroundColor: AppColors.textPrimaryDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      extendedPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
    ),
    
    // Chip Theme
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surfaceVariantDark,
      selectedColor: AppColors.primaryDark,
      disabledColor: AppColors.grey800,
      deleteIconColor: AppColors.textSecondaryDark,
      labelStyle: AppTextStyles.labelMedium,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.chip,
      ),
    ),
    
    // Dialog Theme - Modern with softer appearance
    dialogTheme: DialogThemeData(
      elevation: 0,
      backgroundColor: AppColors.surfaceDark,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.dialog,
        side: BorderSide(
          color: AppColors.borderDark,
          width: 0.5,
        ),
      ),
      titleTextStyle: AppTextStyles.headlineSmall.copyWith(
        color: AppColors.textPrimaryDark,
        fontWeight: FontWeight.w700,
      ),
      contentTextStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textSecondaryDark,
        height: 1.6,
      ),
    ),
    
    // Bottom Sheet Theme
    bottomSheetTheme: BottomSheetThemeData(
      elevation: 8,
      backgroundColor: AppColors.surfaceDark,
      surfaceTintColor: AppColors.primaryLight,
      shape: const RoundedRectangleBorder(
        borderRadius: AppRadius.bottomSheet,
      ),
      modalBackgroundColor: AppColors.surfaceDark,
    ),
    
    // Snackbar Theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.grey200,
      contentTextStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textPrimaryLight,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.radiusSM,
      ),
      behavior: SnackBarBehavior.floating,
    ),
    
    // Icon Theme
    iconTheme: const IconThemeData(
      color: AppColors.textPrimaryDark,
      size: 24,
    ),
    
    // List Tile Theme
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.radiusSM,
      ),
      iconColor: AppColors.textSecondaryDark,
      textColor: AppColors.textPrimaryDark,
    ),
    
    // Divider Theme
    dividerTheme: const DividerThemeData(
      color: AppColors.dividerDark,
      thickness: 1,
      space: 1,
    ),
    
    // Switch Theme
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryLight;
        }
        return AppColors.grey600;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryDark;
        }
        return AppColors.grey700;
      }),
    ),
    
    // Progress Indicator Theme
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primaryLight,
      linearTrackColor: AppColors.primaryDark,
      circularTrackColor: AppColors.primaryDark,
    ),
    
    // Typography
    textTheme: TextTheme(
      displayLarge: AppTextStyles.displayLarge.copyWith(color: AppColors.textPrimaryDark),
      displayMedium: AppTextStyles.displayMedium.copyWith(color: AppColors.textPrimaryDark),
      displaySmall: AppTextStyles.displaySmall.copyWith(color: AppColors.textPrimaryDark),
      headlineLarge: AppTextStyles.headlineLarge.copyWith(color: AppColors.textPrimaryDark),
      headlineMedium: AppTextStyles.headlineMedium.copyWith(color: AppColors.textPrimaryDark),
      headlineSmall: AppTextStyles.headlineSmall.copyWith(color: AppColors.textPrimaryDark),
      titleLarge: AppTextStyles.titleLarge.copyWith(color: AppColors.textPrimaryDark),
      titleMedium: AppTextStyles.titleMedium.copyWith(color: AppColors.textPrimaryDark),
      titleSmall: AppTextStyles.titleSmall.copyWith(color: AppColors.textPrimaryDark),
      bodyLarge: AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimaryDark),
      bodyMedium: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimaryDark),
      bodySmall: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondaryDark),
      labelLarge: AppTextStyles.labelLarge.copyWith(color: AppColors.textPrimaryDark),
      labelMedium: AppTextStyles.labelMedium.copyWith(color: AppColors.textSecondaryDark),
      labelSmall: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondaryDark),
    ),
    
    // Extensions
    extensions: const <ThemeExtension<dynamic>>[
      AppSpacing(),
      AppRadius(),
      AppShadows(),
    ],
  );
}
