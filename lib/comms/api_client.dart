import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import '../core/config.dart';
import '../core/constants.dart';
import '../core/exceptions.dart';

/// Global API client for all HTTP requests
class ApiClient {
  late final Dio _dio;
  final FlutterSecureStorage _storage;
  final Logger _logger;
  String? _token;
  
  static ApiClient? _instance;
  
  factory ApiClient() {
    _instance ??= ApiClient._internal();
    return _instance!;
  }
  
  ApiClient._internal()
      : _storage = const FlutterSecureStorage(),
        _logger = Logger() {
    _initializeDio();
  }
  
  void _initializeDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig().apiBaseUrl,
        connectTimeout: AppConstants.connectTimeout,
        receiveTimeout: AppConstants.receiveTimeout,
        sendTimeout: AppConstants.apiTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    
    // Add interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _onRequest,
        onResponse: _onResponse,
        onError: _onError,
      ),
    );
    
    // Add logging interceptor in debug mode
    if (AppConfig().enableLogging) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: false,
        error: true,
        logPrint: (obj) => _logger.d(obj),
      ));
    }
  }
  
  /// Request interceptor - attach token
  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Attach token if available
    if (_token != null) {
      options.headers['Authorization'] = 'Bearer $_token';
    } else {
      // Try to load token from storage
      final storedToken = await _storage.read(key: AppConstants.tokenKey);
      if (storedToken != null) {
        _token = storedToken;
        options.headers['Authorization'] = 'Bearer $_token';
      }
    }
    
    handler.next(options);
  }
  
  /// Response interceptor
  void _onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    handler.next(response);
  }
  
  /// Error interceptor
  Future<void> _onError(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    final exception = _handleError(error);
    handler.reject(
      DioException(
        requestOptions: error.requestOptions,
        error: exception,
        response: error.response,
      ),
    );
  }
  
  /// Handle and convert DioException to AppException
  AppException _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException('Connection timeout. Please check your internet connection.');
        
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = _extractErrorMessage(error.response);
        
        switch (statusCode) {
          case 400:
            return ValidationException(message, statusCode: statusCode);
          case 401:
            _clearToken();
            return AuthException(message, statusCode: statusCode);
          case 403:
            return PermissionException(message, statusCode: statusCode);
          case 404:
            return NotFoundException(message, statusCode: statusCode);
          case 409:
            return ValidationException(message, statusCode: statusCode);
          case 429:
            return NetworkException('Too many requests. Please try again later.', statusCode: statusCode);
          case 500:
          case 502:
          case 503:
            return ServerException('Server error. Please try again later.', statusCode: statusCode);
          default:
            return AppException(message, statusCode: statusCode);
        }
        
      case DioExceptionType.cancel:
        return AppException('Request cancelled');
        
      case DioExceptionType.connectionError:
        return NetworkException('No internet connection. Please check your network.');
        
      default:
        return AppException('An unexpected error occurred: ${error.message}');
    }
  }
  
  /// Extract error message from response
  String _extractErrorMessage(Response? response) {
    try {
      if (response?.data is Map) {
        final data = response!.data as Map<String, dynamic>;
        return data['message'] ?? 'An error occurred';
      }
      return 'An error occurred';
    } catch (e) {
      return 'An error occurred';
    }
  }
  
  /// Set authentication token
  Future<void> setToken(String token) async {
    _token = token;
    await _storage.write(key: AppConstants.tokenKey, value: token);
  }
  
  /// Clear authentication token
  Future<void> _clearToken() async {
    _token = null;
    await _storage.delete(key: AppConstants.tokenKey);
  }
  
  /// Clear all stored data
  Future<void> clearAll() async {
    _token = null;
    await _storage.deleteAll();
  }
  
  /// GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      print("this is in api client $path");
      
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      if (e.error is AppException) {
        throw e.error as AppException;
      }
      throw _handleError(e);
    }
  }
  
  /// POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      if (e.error is AppException) {
        throw e.error as AppException;
      }
      throw _handleError(e);
    }
  }
  
  /// PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      if (e.error is AppException) {
        throw e.error as AppException;
      }
      throw _handleError(e);
    }
  }
  
  /// DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      if (e.error is AppException) {
        throw e.error as AppException;
      }
      throw _handleError(e);
    }
  }
  
  /// PATCH request
  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      if (e.error is AppException) {
        throw e.error as AppException;
      }
      throw _handleError(e);
    }
  }
}
