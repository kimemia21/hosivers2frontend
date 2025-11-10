import '../api_client.dart';
import '../api_endpoints.dart';
import '../../models/department_model.dart';
import '../../models/api_response.dart';

/// Department service for CRUD operations
class DepartmentService {
  final ApiClient _apiClient;
  
  DepartmentService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();
  
  /// Get all departments
  Future<List<Department>> getAllDepartments() async {
    final response = await _apiClient.get(ApiEndpoints.departments);
    
    final apiResponse = ApiResponse.fromJson(
      response.data,
      (json) => (json as List).map((e) => Department.fromJson(e as Map<String, dynamic>)).toList(),
    );
    
    return apiResponse.data!;
  }
  
  /// Get department by ID
  Future<Department> getDepartmentById(int id) async {
    final response = await _apiClient.get(ApiEndpoints.department(id));
    
    final apiResponse = ApiResponse.fromJson(
      response.data,
      (json) => Department.fromJson(json as Map<String, dynamic>),
    );
    
    return apiResponse.data!;
  }
  
  /// Create new department
  Future<Department> createDepartment({
    required String name,
    String? description,
  }) async {
    final data = <String, dynamic>{
      'name': name,
    };
    
    if (description != null) data['description'] = description;
    
    final response = await _apiClient.post(
      ApiEndpoints.departments,
      data: data,
    );
    
    final apiResponse = ApiResponse.fromJson(
      response.data,
      (json) => Department.fromJson(json as Map<String, dynamic>),
    );
    
    return apiResponse.data!;
  }
  
  /// Update department
  Future<Department> updateDepartment(int id, Map<String, dynamic> updates) async {
    final response = await _apiClient.put(
      ApiEndpoints.department(id),
      data: updates,
    );
    
    final apiResponse = ApiResponse.fromJson(
      response.data,
      (json) => Department.fromJson(json as Map<String, dynamic>),
    );
    
    return apiResponse.data!;
  }
  
  /// Delete department
  Future<void> deleteDepartment(int id) async {
    await _apiClient.delete(ApiEndpoints.department(id));
  }
}
