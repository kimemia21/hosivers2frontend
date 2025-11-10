import 'package:flutter/foundation.dart';
import 'constants.dart';

/// Application configuration
class AppConfig {
  static AppConfig? _instance;
  
  factory AppConfig() {
    _instance ??= AppConfig._internal();
    return _instance!;
  }
  
  AppConfig._internal();
  
  // API Base URL - can be configured per environment
  String get apiBaseUrl {
    if (kDebugMode) {
      // Development
      return AppConstants.apiBaseUrl;
    } else {
      // Production - use environment variable or default
      return const String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: 'https://api.hospital.com/api/v1',
      );
    }
  }
  
  // Enable logging in debug mode
  bool get enableLogging => kDebugMode;
  
  // Cache configuration
  bool get enableCaching => true;
  Duration get cacheDuration => AppConstants.cacheDuration;
}
