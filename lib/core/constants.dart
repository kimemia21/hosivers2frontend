/// Application-wide constants
class AppConstants {
  // API Configuration
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:4000/api/v1',
  );
  
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String refreshTokenKey = 'refresh_token';
  
  // Pagination
  static const int defaultPageSize = 10;
  static const int maxPageSize = 100;
  
  // UI Constants
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;
  
  // Cache Duration
  static const Duration cacheDuration = Duration(minutes: 5);
  
  // Inventory Thresholds
  static const int lowStockThreshold = 50;
  static const int expiringDays = 30;
}

/// User roles
enum UserRole {
  admin,
  doctor,
  pharmacist,
  receptionist;
  
  static UserRole fromString(String role) {
    return UserRole.values.firstWhere(
      (e) => e.name == role.toLowerCase(),
      orElse: () => UserRole.receptionist,
    );
  }
}

/// Prescription status
enum PrescriptionStatus {
  active,
  completed,
  cancelled;
  
  static PrescriptionStatus fromString(String status) {
    return PrescriptionStatus.values.firstWhere(
      (e) => e.name == status.toLowerCase(),
      orElse: () => PrescriptionStatus.active,
    );
  }
}

/// Gender options
enum Gender {
  male,
  female,
  other;
  
  static Gender fromString(String gender) {
    return Gender.values.firstWhere(
      (e) => e.name == gender.toLowerCase(),
      orElse: () => Gender.other,
    );
  }
}
