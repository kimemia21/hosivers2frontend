import 'package:json_annotation/json_annotation.dart';

part 'doctor_model.g.dart';

@JsonSerializable()
class Doctor {
  final int id;
  @JsonKey(name: 'user_id')
  final int userId;
  final String name;
  final String email;
  @JsonKey(name: 'department_id')
  final int? departmentId;
  @JsonKey(name: 'department_name')
  final String? departmentName;
  @JsonKey(name: 'license_number')
  final String? licenseNumber;
  final String? specialization;
  final String? phone;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  
  Doctor({
    required this.id,
    required this.userId,
    required this.name,
    required this.email,
    this.departmentId,
    this.departmentName,
    this.licenseNumber,
    this.specialization,
    this.phone,
    this.createdAt,
    this.updatedAt,
  });
  
  factory Doctor.fromJson(Map<String, dynamic> json) =>
      _$DoctorFromJson(json);
  
  Map<String, dynamic> toJson() => _$DoctorToJson(this);
  
  Doctor copyWith({
    int? id,
    int? userId,
    String? name,
    String? email,
    int? departmentId,
    String? departmentName,
    String? licenseNumber,
    String? specialization,
    String? phone,
    String? createdAt,
    String? updatedAt,
  }) {
    return Doctor(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      departmentId: departmentId ?? this.departmentId,
      departmentName: departmentName ?? this.departmentName,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      specialization: specialization ?? this.specialization,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
