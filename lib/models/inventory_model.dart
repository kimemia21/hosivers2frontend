import 'package:json_annotation/json_annotation.dart';
import 'patient_model.dart';

part 'inventory_model.g.dart';

@JsonSerializable()
class InventoryItem {
  final int id;
  final String sku;
  final String name;
  final String? description;
  @JsonKey(name: 'batch_number')
  final String? batchNumber;
  @JsonKey(name: 'expiry_date')
  final String? expiryDate;
  final String? unit;
  final int quantity;
  final String? location;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  
  InventoryItem({
    required this.id,
    required this.sku,
    required this.name,
    this.description,
    this.batchNumber,
    this.expiryDate,
    this.unit,
    required this.quantity,
    this.location,
    this.createdAt,
    this.updatedAt,
  });
  
  bool get isLowStock => quantity < 50;
  
  bool get isExpiringSoon {
    if (expiryDate == null) return false;
    try {
      final expiry = DateTime.parse(expiryDate!);
      final daysUntilExpiry = expiry.difference(DateTime.now()).inDays;
      return daysUntilExpiry <= 30 && daysUntilExpiry >= 0;
    } catch (e) {
      return false;
    }
  }
  
  bool get isExpired {
    if (expiryDate == null) return false;
    try {
      final expiry = DateTime.parse(expiryDate!);
      return expiry.isBefore(DateTime.now());
    } catch (e) {
      return false;
    }
  }
  
  factory InventoryItem.fromJson(Map<String, dynamic> json) =>
      _$InventoryItemFromJson(json);
  
  Map<String, dynamic> toJson() => _$InventoryItemToJson(this);
  
  InventoryItem copyWith({
    int? id,
    String? sku,
    String? name,
    String? description,
    String? batchNumber,
    String? expiryDate,
    String? unit,
    int? quantity,
    String? location,
    String? createdAt,
    String? updatedAt,
  }) {
    return InventoryItem(
      id: id ?? this.id,
      sku: sku ?? this.sku,
      name: name ?? this.name,
      description: description ?? this.description,
      batchNumber: batchNumber ?? this.batchNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      unit: unit ?? this.unit,
      quantity: quantity ?? this.quantity,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

@JsonSerializable()
class PaginatedInventory {
  final List<InventoryItem> inventory;
  final Pagination pagination;
  
  PaginatedInventory({
    required this.inventory,
    required this.pagination,
  });
  
  factory PaginatedInventory.fromJson(Map<String, dynamic> json) =>
      _$PaginatedInventoryFromJson(json);
  
  Map<String, dynamic> toJson() => _$PaginatedInventoryToJson(this);
}
