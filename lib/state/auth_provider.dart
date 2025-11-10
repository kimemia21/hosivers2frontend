import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../comms/services/auth_service.dart';
import '../models/user_model.dart';
import '../core/exceptions.dart';

/// Auth service provider
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

/// Current user state provider
final currentUserProvider = StateNotifierProvider<CurrentUserNotifier, AsyncValue<User?>>((ref) {
  return CurrentUserNotifier(ref.read(authServiceProvider));
});

/// Current user notifier
class CurrentUserNotifier extends StateNotifier<AsyncValue<User?>> {
  final AuthService _authService;
  
  CurrentUserNotifier(this._authService) : super(const AsyncValue.loading()) {
    _loadUser();
  }
  
  /// Load current user from storage
  Future<void> _loadUser() async {
    try {
      final user = await _authService.getCurrentUser();
      state = AsyncValue.data(user);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
  
  /// Login
  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final response = await _authService.login(email, password);
      state = AsyncValue.data(response.user);
    } on AppException catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }
  
  /// Register new user
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      await _authService.register(
        name: name,
        email: email,
        password: password,
        role: role,
      );
    } on AppException {
      rethrow;
    }
  }
  
  /// Logout
  Future<void> logout() async {
    await _authService.logout();
    state = const AsyncValue.data(null);
  }
  
  /// Refresh user data
  Future<void> refresh() async {
    await _loadUser();
  }
}

/// Check if user is authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  final userState = ref.watch(currentUserProvider);
  return userState.maybeWhen(
    data: (user) => user != null,
    orElse: () => false,
  );
});

/// Get user role
final userRoleProvider = Provider<String?>((ref) {
  final userState = ref.watch(currentUserProvider);
  return userState.maybeWhen(
    data: (user) => user?.role,
    orElse: () => null,
  );
});
