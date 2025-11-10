import 'package:json_annotation/json_annotation.dart';
import '../core/constants.dart';

part 'patient_model.g.dart';

@JsonSerializable()
class Patient {
  final int id;
  @JsonKey(name: 'first_name')
  final String firstName;
  @JsonKey(name: 'last_name')
  final String lastName;
  final String? dob;
  final String? gender;
  @JsonKey(name: 'national_id')
  final String? nationalId;
  final String? phone;
  final String? email;
  final String? address;
  @JsonKey(name: 'emergency_contact_name')
  final String? emergencyContactName;
  @JsonKey(name: 'emergency_contact_phone')
  final String? emergencyContactPhone;
  final String? allergies;
  @JsonKey(name: 'known_conditions')
  final String? knownConditions;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  
  Patient({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.dob,
    this.gender,
    this.nationalId,
    this.phone,
    this.email,
    this.address,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.allergies,
    this.knownConditions,
    this.createdAt,
    this.updatedAt,
  });
  
  String get fullName => '$firstName $lastName';
  
  Gender? get genderEnum => gender != null ? Gender.fromString(gender!) : null;
  
  factory Patient.fromJson(Map<String, dynamic> json) =>
      _$PatientFromJson(json);
  
  Map<String, dynamic> toJson() => _$PatientToJson(this);
  
  Patient copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? dob,
    String? gender,
    String? nationalId,
    String? phone,
    String? email,
    String? address,
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? allergies,
    String? knownConditions,
    String? createdAt,
    String? updatedAt,
  }) {
    return Patient(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      nationalId: nationalId ?? this.nationalId,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactPhone: emergencyContactPhone ?? this.emergencyContactPhone,
      allergies: allergies ?? this.allergies,
      knownConditions: knownConditions ?? this.knownConditions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

@JsonSerializable()
class PaginatedPatients {
  final List<Patient> patients;
  final Pagination pagination;
  
  PaginatedPatients({
    required this.patients,
    required this.pagination,
  });
  
  factory PaginatedPatients.fromJson(Map<String, dynamic> json) =>
      _$PaginatedPatientsFromJson(json);
  
  Map<String, dynamic> toJson() => _$PaginatedPatientsToJson(this);
}

@JsonSerializable()
class Pagination {
  final int page;
  final int limit;
  final int total;
  final int pages;
  
  Pagination({
    required this.page,
    required this.limit,
    required this.total,
    required this.pages,
  });
  
  factory Pagination.fromJson(Map<String, dynamic> json) =>
      _$PaginationFromJson(json);
  
  Map<String, dynamic> toJson() => _$PaginationToJson(this);
}
