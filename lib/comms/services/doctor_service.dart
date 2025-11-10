import '../api_client.dart';
import '../api_endpoints.dart';
import '../../models/doctor_model.dart';
import '../../models/api_response.dart';

/// Doctor service for CRUD operations
class DoctorService {
  final ApiClient _apiClient;
  
  DoctorService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();
  
  /// Get all doctors
  Future<List<Doctor>> getAllDoctors() async {
    final response = await _apiClient.get(ApiEndpoints.doctors);
    
    final apiResponse = ApiResponse.fromJson(
      response.data,
      (json) => (json as List).map((e) => Doctor.fromJson(e as Map<String, dynamic>)).toList(),
    );
    
    return apiResponse.data!;
  }
  
  /// Get doctor by ID
  Future<Doctor> getDoctorById(int id) async {
    final response = await _apiClient.get(ApiEndpoints.doctor(id));
    
    final apiResponse = ApiResponse.fromJson(
      response.data,
      (json) => Doctor.fromJson(json as Map<String, dynamic>),
    );
    
    return apiResponse.data!;
  }
  
  /// Create new doctor
  Future<Doctor> createDoctor({
    required int userId,
    int? departmentId,
    String? licenseNumber,
    String? specialization,
    String? phone,
  }) async {
    final data = <String, dynamic>{
      'user_id': userId,
    };
    
    if (departmentId != null) data['department_id'] = departmentId;
    if (licenseNumber != null) data['license_number'] = licenseNumber;
    if (specialization != null) data['specialization'] = specialization;
    if (phone != null) data['phone'] = phone;
    
    final response = await _apiClient.post(
      ApiEndpoints.doctors,
      data: data,
    );
    
    final apiResponse = ApiResponse.fromJson(
      response.data,
      (json) => Doctor.fromJson(json as Map<String, dynamic>),
    );
    
    return apiResponse.data!;
  }
  
  /// Update doctor
  Future<Doctor> updateDoctor(int id, Map<String, dynamic> updates) async {
    final response = await _apiClient.put(
      ApiEndpoints.doctor(id),
      data: updates,
    );
    
    final apiResponse = ApiResponse.fromJson(
      response.data,
      (json) => Doctor.fromJson(json as Map<String, dynamic>),
    );
    
    return apiResponse.data!;
  }
  
  /// Delete doctor
  Future<void> deleteDoctor(int id) async {
    await _apiClient.delete(ApiEndpoints.doctor(id));
  }
}
