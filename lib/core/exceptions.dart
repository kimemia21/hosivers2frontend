/// Base exception class for the application
class AppException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic error;
  
  AppException(this.message, {this.statusCode, this.error});
  
  @override
  String toString() => message;
}

/// Network-related exceptions
class NetworkException extends AppException {
  NetworkException(super.message, {super.statusCode, super.error});
}

/// Authentication exceptions
class AuthException extends AppException {
  AuthException(super.message, {super.statusCode, super.error});
}

/// Validation exceptions
class ValidationException extends AppException {
  ValidationException(super.message, {super.statusCode, super.error});
}

/// Server exceptions
class ServerException extends AppException {
  ServerException(super.message, {super.statusCode, super.error});
}

/// Not found exceptions
class NotFoundException extends AppException {
  NotFoundException(super.message, {super.statusCode, super.error});
}

/// Permission exceptions
class PermissionException extends AppException {
  PermissionException(super.message, {super.statusCode, super.error});
}

/// Cache exceptions
class CacheException extends AppException {
  CacheException(super.message, {super.error});
}
