import 'package:json_annotation/json_annotation.dart';
import '../core/constants.dart';
import 'patient_model.dart';

part 'prescription_model.g.dart';

@JsonSerializable()
class Prescription {
  final int id;
  @JsonKey(name: 'patient_id')
  final int patientId;
  @JsonKey(name: 'patient_name')
  final String? patientName;
  @JsonKey(name: 'doctor_id')
  final int doctorId;
  @JsonKey(name: 'doctor_name')
  final String? doctorName;
  @JsonKey(name: 'issue_date')
  final String issueDate;
  final String? notes;
  final String status;
  @JsonKey(name: 'items_count')
  final int? itemsCount;
  final List<PrescriptionItem>? items;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  
  Prescription({
    required this.id,
    required this.patientId,
    this.patientName,
    required this.doctorId,
    this.doctorName,
    required this.issueDate,
    this.notes,
    required this.status,
    this.itemsCount,
    this.items,
    this.createdAt,
    this.updatedAt,
  });
  
  PrescriptionStatus get statusEnum => PrescriptionStatus.fromString(status);
  
  factory Prescription.fromJson(Map<String, dynamic> json) =>
      _$PrescriptionFromJson(json);
  
  Map<String, dynamic> toJson() => _$PrescriptionToJson(this);
  
  Prescription copyWith({
    int? id,
    int? patientId,
    String? patientName,
    int? doctorId,
    String? doctorName,
    String? issueDate,
    String? notes,
    String? status,
    int? itemsCount,
    List<PrescriptionItem>? items,
    String? createdAt,
    String? updatedAt,
  }) {
    return Prescription(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      doctorId: doctorId ?? this.doctorId,
      doctorName: doctorName ?? this.doctorName,
      issueDate: issueDate ?? this.issueDate,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      itemsCount: itemsCount ?? this.itemsCount,
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

@JsonSerializable()
class PrescriptionItem {
  final int? id;
  @JsonKey(name: 'prescription_id')
  final int? prescriptionId;
  @JsonKey(name: 'inventory_id')
  final int? inventoryId;
  @JsonKey(name: 'med_name')
  final String medName;
  final String? dose;
  final String? frequency;
  final String? route;
  final int? quantity;
  final String? instructions;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  
  PrescriptionItem({
    this.id,
    this.prescriptionId,
    this.inventoryId,
    required this.medName,
    this.dose,
    this.frequency,
    this.route,
    this.quantity,
    this.instructions,
    this.createdAt,
  });
  
  factory PrescriptionItem.fromJson(Map<String, dynamic> json) =>
      _$PrescriptionItemFromJson(json);
  
  Map<String, dynamic> toJson() => _$PrescriptionItemToJson(this);
  
  PrescriptionItem copyWith({
    int? id,
    int? prescriptionId,
    int? inventoryId,
    String? medName,
    String? dose,
    String? frequency,
    String? route,
    int? quantity,
    String? instructions,
    String? createdAt,
  }) {
    return PrescriptionItem(
      id: id ?? this.id,
      prescriptionId: prescriptionId ?? this.prescriptionId,
      inventoryId: inventoryId ?? this.inventoryId,
      medName: medName ?? this.medName,
      dose: dose ?? this.dose,
      frequency: frequency ?? this.frequency,
      route: route ?? this.route,
      quantity: quantity ?? this.quantity,
      instructions: instructions ?? this.instructions,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

@JsonSerializable()
class PaginatedPrescriptions {
  final List<Prescription> prescriptions;
  final Pagination pagination;
  
  PaginatedPrescriptions({
    required this.prescriptions,
    required this.pagination,
  });
  
  factory PaginatedPrescriptions.fromJson(Map<String, dynamic> json) =>
      _$PaginatedPrescriptionsFromJson(json);
  
  Map<String, dynamic> toJson() => _$PaginatedPrescriptionsToJson(this);
}
