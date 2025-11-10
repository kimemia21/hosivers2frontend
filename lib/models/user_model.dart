import 'package:json_annotation/json_annotation.dart';
import '../core/constants.dart';

part 'user_model.g.dart';

@JsonSerializable()
class User {
  final int id;
  final String name;
  final String email;
  final String role;
  
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });
  
  UserRole get userRole => UserRole.fromString(role);
  
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  
  Map<String, dynamic> toJson() => _$UserToJson(this);
  
  User copyWith({
    int? id,
    String? name,
    String? email,
    String? role,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
    );
  }
}

@JsonSerializable()
class LoginResponse {
  final String token;
  final User user;
  
  LoginResponse({
    required this.token,
    required this.user,
  });
  
  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
  
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
