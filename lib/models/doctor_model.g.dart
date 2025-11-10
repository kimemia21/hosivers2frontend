// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Doctor _$DoctorFromJson(Map<String, dynamic> json) => Doctor(
  id: (json['id'] as num).toInt(),
  userId: (json['user_id'] as num).toInt(),
  name: json['name'] as String,
  email: json['email'] as String,
  departmentId: (json['department_id'] as num?)?.toInt(),
  departmentName: json['department_name'] as String?,
  licenseNumber: json['license_number'] as String?,
  specialization: json['specialization'] as String?,
  phone: json['phone'] as String?,
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
);

Map<String, dynamic> _$DoctorToJson(Doctor instance) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'name': instance.name,
  'email': instance.email,
  'department_id': instance.departmentId,
  'department_name': instance.departmentName,
  'license_number': instance.licenseNumber,
  'specialization': instance.specialization,
  'phone': instance.phone,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
};
