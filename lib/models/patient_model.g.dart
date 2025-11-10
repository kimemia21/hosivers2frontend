// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Patient _$PatientFromJson(Map<String, dynamic> json) => Patient(
  id: (json['id'] as num).toInt(),
  firstName: json['first_name'] as String,
  lastName: json['last_name'] as String,
  dob: json['dob'] as String?,
  gender: json['gender'] as String?,
  nationalId: json['national_id'] as String?,
  phone: json['phone'] as String?,
  email: json['email'] as String?,
  address: json['address'] as String?,
  emergencyContactName: json['emergency_contact_name'] as String?,
  emergencyContactPhone: json['emergency_contact_phone'] as String?,
  allergies: json['allergies'] as String?,
  knownConditions: json['known_conditions'] as String?,
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
);

Map<String, dynamic> _$PatientToJson(Patient instance) => <String, dynamic>{
  'id': instance.id,
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'dob': instance.dob,
  'gender': instance.gender,
  'national_id': instance.nationalId,
  'phone': instance.phone,
  'email': instance.email,
  'address': instance.address,
  'emergency_contact_name': instance.emergencyContactName,
  'emergency_contact_phone': instance.emergencyContactPhone,
  'allergies': instance.allergies,
  'known_conditions': instance.knownConditions,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
};

PaginatedPatients _$PaginatedPatientsFromJson(Map<String, dynamic> json) =>
    PaginatedPatients(
      patients: (json['patients'] as List<dynamic>)
          .map((e) => Patient.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: Pagination.fromJson(
        json['pagination'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$PaginatedPatientsToJson(PaginatedPatients instance) =>
    <String, dynamic>{
      'patients': instance.patients.map((e) => e.toJson()).toList(),
      'pagination': instance.pagination.toJson(),
    };

Pagination _$PaginationFromJson(Map<String, dynamic> json) => Pagination(
  page: (json['page'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
  total: (json['total'] as num).toInt(),
  pages: (json['pages'] as num).toInt(),
);

Map<String, dynamic> _$PaginationToJson(Pagination instance) =>
    <String, dynamic>{
      'page': instance.page,
      'limit': instance.limit,
      'total': instance.total,
      'pages': instance.pages,
    };
