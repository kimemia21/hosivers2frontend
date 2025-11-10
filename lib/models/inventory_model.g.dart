// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InventoryItem _$InventoryItemFromJson(Map<String, dynamic> json) =>
    InventoryItem(
      id: (json['id'] as num).toInt(),
      sku: json['sku'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      batchNumber: json['batch_number'] as String?,
      expiryDate: json['expiry_date'] as String?,
      unit: json['unit'] as String?,
      quantity: (json['quantity'] as num).toInt(),
      location: json['location'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$InventoryItemToJson(InventoryItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sku': instance.sku,
      'name': instance.name,
      'description': instance.description,
      'batch_number': instance.batchNumber,
      'expiry_date': instance.expiryDate,
      'unit': instance.unit,
      'quantity': instance.quantity,
      'location': instance.location,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

PaginatedInventory _$PaginatedInventoryFromJson(Map<String, dynamic> json) =>
    PaginatedInventory(
      inventory: (json['inventory'] as List<dynamic>)
          .map((e) => InventoryItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: Pagination.fromJson(
        json['pagination'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$PaginatedInventoryToJson(PaginatedInventory instance) =>
    <String, dynamic>{
      'inventory': instance.inventory.map((e) => e.toJson()).toList(),
      'pagination': instance.pagination.toJson(),
    };
