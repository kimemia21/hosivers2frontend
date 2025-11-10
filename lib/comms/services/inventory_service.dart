import '../api_client.dart';
import '../api_endpoints.dart';
import '../../models/inventory_model.dart';
import '../../models/api_response.dart';
import '../../core/constants.dart';

/// Inventory service for CRUD operations
class InventoryService {
  final ApiClient _apiClient;
  
  InventoryService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();
  
  /// Get all inventory items with pagination and filters
  Future<PaginatedInventory> getAllInventory({
    int page = 1,
    int limit = AppConstants.defaultPageSize,
    String? search,
    bool? expiringSoon,
    bool? lowStock,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
    };
    
    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }
    if (expiringSoon != null) {
      queryParams['expiring_soon'] = expiringSoon;
    }
    if (lowStock != null) {
      queryParams['low_stock'] = lowStock;
    }
    
    final response = await _apiClient.get(
      ApiEndpoints.inventory,
      queryParameters: queryParams,
    );
    
    // The API returns: {status, data: [items...], pagination: {...}}
    // We need to restructure it to match PaginatedInventory model
    final responseData = response.data as Map<String, dynamic>;
    final inventoryData = {
      'inventory': responseData['data'],
      'pagination': responseData['pagination'],
    };
    
    return PaginatedInventory.fromJson(inventoryData);
  }
  
  /// Get inventory item by ID
  Future<InventoryItem> getInventoryById(int id) async {
    final response = await _apiClient.get(ApiEndpoints.inventoryItem(id));
    
    final apiResponse = ApiResponse.fromJson(
      response.data,
      (json) => InventoryItem.fromJson(json as Map<String, dynamic>),
    );
    
    return apiResponse.data!;
  }
  
  /// Create new inventory item
  Future<InventoryItem> createInventory({
    required String sku,
    required String name,
    String? description,
    String? batchNumber,
    String? expiryDate,
    String? unit,
    required int quantity,
    String? location,
  }) async {
    final data = <String, dynamic>{
      'sku': sku,
      'name': name,
      'quantity': quantity,
    };
    
    if (description != null) data['description'] = description;
    if (batchNumber != null) data['batch_number'] = batchNumber;
    if (expiryDate != null) data['expiry_date'] = expiryDate;
    if (unit != null) data['unit'] = unit;
    if (location != null) data['location'] = location;
    
    final response = await _apiClient.post(
      ApiEndpoints.inventory,
      data:
//       {
//   // "id": 1,
//   "sku": "MED12345",
//   "name": "Paracetamol 500mg",
//   "description": "Pain reliever and fever reducer",
//   "batch_number": "B202511",
//   "expiry_date": "2026-05-30",
//   "unit": "tablets",
//   "quantity": "500",
//   "location": "Shelf A-1, Room 3",
//   "created_at": "2025-11-10T12:00:00Z",
//   "updated_at": "2025-11-10T12:00:00Z"
// }
 data,
    );
    
    final apiResponse = ApiResponse.fromJson(
      response.data,
      (json) => InventoryItem.fromJson(json as Map<String, dynamic>),
    );
    
    return apiResponse.data!;
  }
  
  /// Update inventory item
  Future<InventoryItem> updateInventory(int id, Map<String, dynamic> updates) async {
    final response = await _apiClient.put(
      ApiEndpoints.inventoryItem(id),
      data: updates,
    );
    
    final apiResponse = ApiResponse.fromJson(
      response.data,
      (json) => InventoryItem.fromJson(json as Map<String, dynamic>),
    );
    
    return apiResponse.data!;
  }
  
  /// Delete inventory item
  Future<void> deleteInventory(int id) async {
    await _apiClient.delete(ApiEndpoints.inventoryItem(id));
  }
}
