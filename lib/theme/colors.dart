import 'package:flutter/material.dart';

/// Application color palette - Modern Healthcare Design System
/// Based on accessibility standards (WCAG AA) and medical UI best practices
/// Inspired by leading hospital management systems: Epic, Cerner, Meditech
class AppColors {
  AppColors._(); // Private constructor to prevent instantiation
  
  // ===== PRIMARY PALETTE =====
  // Modern healthcare blue - inspired by leading hospital management systems
  // Sophisticated, trustworthy, and calming (similar to Epic's medical blue)
  static const Color primary = Color(0xFF2563EB); // Modern vibrant blue
  static const Color primaryLight = Color(0xFF60A5FA);
  static const Color primaryDark = Color(0xFF1E40AF);
  static const Color primaryContainer = Color(0xFFDEEAFF);
  
  // ===== SECONDARY PALETTE =====
  // Refined teal - modern medical accent with energy (inspired by modern health apps)
  static const Color secondary = Color(0xFF14B8A6);
  static const Color secondaryLight = Color(0xFF5EEAD4);
  static const Color secondaryDark = Color(0xFF0F766E);
  static const Color secondaryContainer = Color(0xFFCCFBF1);
  
  // ===== SEMANTIC COLORS =====
  // Modern semantic colors with better contrast and vibrancy
  static const Color success = Color(0xFF059669); // Modern emerald green
  static const Color successLight = Color(0xFF34D399);
  static const Color successContainer = Color(0xFFD1FAE5);
  
  static const Color warning = Color(0xFFF59E0B); // Vibrant amber
  static const Color warningLight = Color(0xFFFBBF24);
  static const Color warningContainer = Color(0xFFFEF3C7);
  
  static const Color error = Color(0xFFDC2626); // Modern red
  static const Color errorLight = Color(0xFFF87171);
  static const Color errorContainer = Color(0xFFFEE2E2);
  
  static const Color info = Color(0xFF0EA5E9); // Sky blue
  static const Color infoLight = Color(0xFF7DD3FC);
  static const Color infoContainer = Color(0xFFE0F2FE);
  
  // ===== NEUTRAL PALETTE =====
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  
  // Grey scale - 50 to 900
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);
  
  // ===== LIGHT THEME COLORS =====
  // Premium light theme inspired by modern medical UIs
  static const Color backgroundLight = Color(0xFFF8FAFC); // Softer, modern grey-blue
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceVariantLight = Color(0xFFF1F5F9); // Subtle slate variant
  
  static const Color textPrimaryLight = Color(0xFF0F172A); // Deeper slate for better readability
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color textDisabledLight = Color(0xFFCBD5E1);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color dividerLight = Color(0xFFF1F5F9);
  
  // ===== DARK THEME COLORS =====
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color surfaceVariantDark = Color(0xFF2C2C2E);
  
  static const Color textPrimaryDark = Color(0xFFE3E3E3);
  static const Color textSecondaryDark = Color(0xFFB3B3B3);
  static const Color textDisabledDark = Color(0xFF6C6C6C);
  
  static const Color borderDark = Color(0xFF3C3C3E);
  static const Color dividerDark = Color(0xFF2C2C2E);
  
  // ===== SPECIALTY COLORS =====
  // Hospital department colors
  static const Color emergency = Color(0xFFD32F2F);
  static const Color surgery = Color(0xFF7B1FA2);
  static const Color pediatrics = Color(0xFFFBC02D);
  static const Color cardiology = Color(0xFFE64A19);
  static const Color neurology = Color(0xFF5E35B1);
  
  // Status indicators
  static const Color statusActive = Color(0xFF2E7D32);
  static const Color statusInactive = Color(0xFF757575);
  static const Color statusPending = Color(0xFFF57C00);
  static const Color statusCompleted = Color(0xFF1976D2);
  static const Color statusCancelled = Color(0xFFC62828);
  static const Color statusCritical = Color(0xFFD32F2F);
  
  // Dashboard module colors - premium, modern palette inspired by top healthcare UIs
  // Carefully selected for visual hierarchy and distinction
  static const Color modulePatients = Color(0xFF2563EB); // Professional blue
  static const Color moduleDoctors = Color(0xFF14B8A6); // Medical teal
  static const Color moduleInventory = Color(0xFFF97316); // Vibrant orange
  static const Color modulePrescriptions = Color(0xFF8B5CF6); // Modern violet
  static const Color moduleAppointments = Color(0xFF06B6D4); // Cyan
  static const Color moduleBilling = Color(0xFFA855F7); // Purple
  static const Color moduleReports = Color(0xFF10B981); // Emerald green
  static const Color moduleAudit = Color(0xFF6366F1); // Indigo
  
  // Card colors for different entities - modern, cohesive palette
  static const Color doctorCard = Color(0xFF14B8A6);
  static const Color patientCard = Color(0xFF2563EB);
  static const Color inventoryCard = Color(0xFFF97316);
  static const Color prescriptionCard = Color(0xFF8B5CF6);
  
  // Prescription status colors
  static const Color active = Color(0xFF059669);
  static const Color completed = Color(0xFF0EA5E9);
  static const Color cancelled = Color(0xFFDC2626);
  
  // General purpose grey
  static const Color grey = Color(0xFF9E9E9E);
  
  // Text colors (context-aware)
  static const Color textSecondary = Color(0xFF5F6368);
  
  // Overlay and shadow
  static const Color overlay = Color(0x52000000);
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowDark = Color(0x4D000000);
  
  // Chart colors for data visualization - premium, distinguishable palette
  // Optimized for accessibility and visual appeal
  static const List<Color> chartColors = [
    Color(0xFF2563EB), // Professional blue
    Color(0xFF14B8A6), // Medical teal
    Color(0xFF8B5CF6), // Modern violet
    Color(0xFFF97316), // Vibrant orange
    Color(0xFF10B981), // Emerald green
    Color(0xFF06B6D4), // Cyan
    Color(0xFFEF4444), // Modern red
    Color(0xFF6366F1), // Indigo
    Color(0xFFEC4899), // Pink
    Color(0xFFF59E0B), // Amber
  ];
}
