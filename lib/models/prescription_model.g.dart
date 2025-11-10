// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prescription_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Prescription _$PrescriptionFromJson(Map<String, dynamic> json) => Prescription(
  id: (json['id'] as num).toInt(),
  patientId: (json['patient_id'] as num).toInt(),
  patientName: json['patient_name'] as String?,
  doctorId: (json['doctor_id'] as num).toInt(),
  doctorName: json['doctor_name'] as String?,
  issueDate: json['issue_date'] as String,
  notes: json['notes'] as String?,
  status: json['status'] as String,
  itemsCount: (json['items_count'] as num?)?.toInt(),
  items: (json['items'] as List<dynamic>?)
      ?.map((e) => PrescriptionItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
);

Map<String, dynamic> _$PrescriptionToJson(Prescription instance) =>
    <String, dynamic>{
      'id': instance.id,
      'patient_id': instance.patientId,
      'patient_name': instance.patientName,
      'doctor_id': instance.doctorId,
      'doctor_name': instance.doctorName,
      'issue_date': instance.issueDate,
      'notes': instance.notes,
      'status': instance.status,
      'items_count': instance.itemsCount,
      'items': instance.items?.map((e) => e.toJson()).toList(),
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

PrescriptionItem _$PrescriptionItemFromJson(Map<String, dynamic> json) =>
    PrescriptionItem(
      id: (json['id'] as num?)?.toInt(),
      prescriptionId: (json['prescription_id'] as num?)?.toInt(),
      inventoryId: (json['inventory_id'] as num?)?.toInt(),
      medName: json['med_name'] as String,
      dose: json['dose'] as String?,
      frequency: json['frequency'] as String?,
      route: json['route'] as String?,
      quantity: (json['quantity'] as num?)?.toInt(),
      instructions: json['instructions'] as String?,
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$PrescriptionItemToJson(PrescriptionItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'prescription_id': instance.prescriptionId,
      'inventory_id': instance.inventoryId,
      'med_name': instance.medName,
      'dose': instance.dose,
      'frequency': instance.frequency,
      'route': instance.route,
      'quantity': instance.quantity,
      'instructions': instance.instructions,
      'created_at': instance.createdAt,
    };

PaginatedPrescriptions _$PaginatedPrescriptionsFromJson(
  Map<String, dynamic> json,
) => PaginatedPrescriptions(
  prescriptions: (json['prescriptions'] as List<dynamic>)
      .map((e) => Prescription.fromJson(e as Map<String, dynamic>))
      .toList(),
  pagination: Pagination.fromJson(json['pagination'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PaginatedPrescriptionsToJson(
  PaginatedPrescriptions instance,
) => <String, dynamic>{
  'prescriptions': instance.prescriptions.map((e) => e.toJson()).toList(),
  'pagination': instance.pagination.toJson(),
};
