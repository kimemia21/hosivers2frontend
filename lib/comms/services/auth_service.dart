import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../api_client.dart';
import '../api_endpoints.dart';
import '../../models/user_model.dart';
import '../../models/api_response.dart';
import '../../core/constants.dart';

/// Authentication service
class AuthService {
  final ApiClient _apiClient;
  
  AuthService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();
  
  /// Login user
  Future<LoginResponse> login(String email, String password) async {
    final response = await _apiClient.post(
      ApiEndpoints.login,
      data: {
        'email': email,
        'password': password,
      },
    );
    
    final apiResponse = ApiResponse.fromJson(
      response.data,
      (json) => LoginResponse.fromJson(json as Map<String, dynamic>),
    );
    
    if (apiResponse.data != null) {
      // Store token and user data
      await _apiClient.setToken(apiResponse.data!.token);
      await _saveUserData(apiResponse.data!.user);
      return apiResponse.data!;
    }
    
    throw Exception('Login failed: ${apiResponse.message}');
  }
  
  /// Register new user (admin only)
  Future<User> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.register,
      data: {
        'name': name,
        'email': email,
        'password': password,
        'role': role,
      },
    );
    
    final apiResponse = ApiResponse.fromJson(
      response.data,
      (json) => User.fromJson(json as Map<String, dynamic>),
    );
    
    if (apiResponse.data != null) {
      return apiResponse.data!;
    }
    
    throw Exception('Registration failed: ${apiResponse.message}');
  }
  
  /// Refresh token
  Future<String> refreshToken(String refreshToken) async {
    final response = await _apiClient.post(
      ApiEndpoints.refresh,
      data: {
        'refreshToken': refreshToken,
      },
    );
    
    final data = response.data['data'] as Map<String, dynamic>;
    final token = data['token'] as String;
    
    await _apiClient.setToken(token);
    return token;
  }
  
  /// Logout user
  Future<void> logout() async {
    await _apiClient.clearAll();
    await _clearUserData();
  }
  
  /// Get current user from storage
  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(AppConstants.userKey);
    
    if (userJson != null) {
      return User.fromJson(json.decode(userJson));
    }
    
    return null;
  }
  
  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(AppConstants.tokenKey);
  }
  
  /// Save user data to local storage
  Future<void> _saveUserData(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.userKey, json.encode(user.toJson()));
  }
  
  /// Clear user data from local storage
  Future<void> _clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.userKey);
  }
}
