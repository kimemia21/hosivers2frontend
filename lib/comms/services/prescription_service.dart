import '../api_client.dart';
import '../api_endpoints.dart';
import '../../models/prescription_model.dart';
import '../../models/api_response.dart';
import '../../core/constants.dart';

/// Prescription service for CRUD operations
class PrescriptionService {
  final ApiClient _apiClient;
  
  PrescriptionService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();
  
  /// Get all prescriptions with pagination and filters
  Future<PaginatedPrescriptions> getAllPrescriptions({
    int page = 1,
    int limit = AppConstants.defaultPageSize,
    String? status,
    int? patientId,
    int? doctorId,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
    };
    
    if (status != null) queryParams['status'] = status;
    if (patientId != null) queryParams['patient_id'] = patientId;
    if (doctorId != null) queryParams['doctor_id'] = doctorId;
    
    final response = await _apiClient.get(
      ApiEndpoints.prescriptions,
      queryParameters: queryParams,
    );
    
    // The API returns: {status, data: [prescriptions...], pagination: {...}}
    // We need to restructure it to match PaginatedPrescriptions model
    final responseData = response.data as Map<String, dynamic>;
    final prescriptionsData = {
      'prescriptions': responseData['data'],
      'pagination': responseData['pagination'],
    };
    
    return PaginatedPrescriptions.fromJson(prescriptionsData);
  }
  
  /// Get prescription by ID
  Future<Prescription> getPrescriptionById(int id) async {
    final response = await _apiClient.get(ApiEndpoints.prescription(id));
    
    final apiResponse = ApiResponse.fromJson(
      response.data,
      (json) => Prescription.fromJson(json as Map<String, dynamic>),
    );
    
    return apiResponse.data!;
  }
  
  /// Create new prescription
  Future<Prescription> createPrescription({
    required int patientId,
    required int doctorId,
    String? notes,
    String status = 'active',
    required List<Map<String, dynamic>> items,
  }) async {
    final data = <String, dynamic>{
      'patient_id': patientId,
      'doctor_id': doctorId,
      'status': status,
      'items': items,
    };
    
    if (notes != null) data['notes'] = notes;
    
    final response = await _apiClient.post(
      ApiEndpoints.prescriptions,
      data: data,
    );
    
    final apiResponse = ApiResponse.fromJson(
      response.data,
      (json) => Prescription.fromJson(json as Map<String, dynamic>),
    );
    
    return apiResponse.data!;
  }
  
  /// Update prescription
  Future<Prescription> updatePrescription(int id, Map<String, dynamic> updates) async {
    final response = await _apiClient.put(
      ApiEndpoints.prescription(id),
      data: updates,
    );
    
    final apiResponse = ApiResponse.fromJson(
      response.data,
      (json) => Prescription.fromJson(json as Map<String, dynamic>),
    );
    
    return apiResponse.data!;
  }
  
  /// Delete prescription
  Future<void> deletePrescription(int id) async {
    await _apiClient.delete(ApiEndpoints.prescription(id));
  }
}
