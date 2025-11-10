import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../comms/services/inventory_service.dart';
import '../models/inventory_model.dart';
import '../core/constants.dart';

/// Inventory service provider
final inventoryServiceProvider = Provider<InventoryService>((ref) => InventoryService());

/// Inventory filter
class InventoryFilter {
  final int page;
  final int limit;
  final String? search;
  final bool? expiringSoon;
  final bool? lowStock;
  
  const InventoryFilter({
    this.page = 1,
    this.limit = AppConstants.defaultPageSize,
    this.search,
    this.expiringSoon,
    this.lowStock,
  });
  
  InventoryFilter copyWith({
    int? page,
    int? limit,
    String? search,
    bool? expiringSoon,
    bool? lowStock,
  }) {
    return InventoryFilter(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      search: search ?? this.search,
      expiringSoon: expiringSoon ?? this.expiringSoon,
      lowStock: lowStock ?? this.lowStock,
    );
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is InventoryFilter &&
        other.page == page &&
        other.limit == limit &&
        other.search == search &&
        other.expiringSoon == expiringSoon &&
        other.lowStock == lowStock;
  }
  
  @override
  int get hashCode => Object.hash(page, limit, search, expiringSoon, lowStock);
}

/// Inventory list provider with pagination
final inventoryProvider = StateNotifierProvider.family<InventoryNotifier, AsyncValue<PaginatedInventory>, InventoryFilter>(
  (ref, filter) => InventoryNotifier(ref.read(inventoryServiceProvider), filter),
);

/// Inventory notifier
class InventoryNotifier extends StateNotifier<AsyncValue<PaginatedInventory>> {
  final InventoryService _inventoryService;
  final InventoryFilter filter;
  
  InventoryNotifier(this._inventoryService, this.filter) : super(const AsyncValue.loading()) {
    loadInventory();
  }
  
  /// Load inventory
  Future<void> loadInventory() async {
    state = const AsyncValue.loading();
    try {
      final result = await _inventoryService.getAllInventory(
        page: filter.page,
        limit: filter.limit,
        search: filter.search,
        expiringSoon: filter.expiringSoon,
        lowStock: filter.lowStock,
      );
      state = AsyncValue.data(result);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
  
  /// Refresh inventory
  Future<void> refresh() async {
    await loadInventory();
  }
}

/// Single inventory item provider
final inventoryItemProvider = FutureProvider.family<InventoryItem, int>((ref, id) async {
  final service = ref.read(inventoryServiceProvider);
  return await service.getInventoryById(id);
});

/// Create inventory action
final createInventoryProvider = Provider<Future<InventoryItem> Function(Map<String, dynamic>)>((ref) {
  return (data) async {
    final service = ref.read(inventoryServiceProvider);
    return await service.createInventory(
      sku: data['sku'],
      name: data['name'],
      description: data['description'],
      batchNumber: data['batch_number'],
      expiryDate: data['expiry_date'],
      unit: data['unit'],
      quantity: data['quantity'],
      location: data['location'],
    );
  };
});

/// Update inventory action
final updateInventoryProvider = Provider<Future<InventoryItem> Function(int, Map<String, dynamic>)>((ref) {
  return (id, updates) async {
    final service = ref.read(inventoryServiceProvider);
    return await service.updateInventory(id, updates);
  };
});

/// Delete inventory action
final deleteInventoryProvider = Provider<Future<void> Function(int)>((ref) {
  return (id) async {
    final service = ref.read(inventoryServiceProvider);
    await service.deleteInventory(id);
  };
});
