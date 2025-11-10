import '../api_client.dart';
import '../api_endpoints.dart';
import '../../models/patient_model.dart';
import '../../models/api_response.dart';
import '../../core/constants.dart';

/// Patient service for CRUD operations
class PatientService {
  final ApiClient _apiClient;
  
  PatientService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();
  
  /// Get all patients with pagination and filters
  Future<PaginatedPatients> getAllPatients({
    int page = 1,
    int limit = AppConstants.defaultPageSize,
    String? search,
    String? sort = 'id',
    String? order = 'desc',
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
      // 'sort': sort,
      // 'order': order,
    };
    
    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }
    
    final response = await _apiClient.get(
      ApiEndpoints.patients,
     queryParameters: queryParams,
    );
    
    // The API returns: {status, data: [patients...], pagination: {...}}
    // We need to restructure it to match PaginatedPatients model
    final responseData = response.data as Map<String, dynamic>;
    final patientsData = {
      'patients': responseData['data'],
      'pagination': responseData['pagination'],
    };
    
    return PaginatedPatients.fromJson(patientsData);
  }
  
  /// Get patient by ID
  Future<Patient> getPatientById(int id) async {
    final response = await _apiClient.get(ApiEndpoints.patient(id));
    
    final apiResponse = ApiResponse.fromJson(
      response.data,
      (json) => Patient.fromJson(json as Map<String, dynamic>),
    );
    
    return apiResponse.data!;
  }
  
  /// Create new patient
  Future<Patient> createPatient({
    required String firstName,
    required String lastName,
    required String dob,
    required String gender,
    String? nationalId,
    String? phone,
    String? email,
    String? address,
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? allergies,
    String? knownConditions,
  }) async {
    final data = <String, dynamic>{
      'first_name': firstName,
      'last_name': lastName,
      'dob': dob,
      'gender': gender,
    };
    
    if (nationalId != null) data['national_id'] = nationalId;
    if (phone != null) data['phone'] = phone;
    if (email != null) data['email'] = email;
    if (address != null) data['address'] = address;
    if (emergencyContactName != null) data['emergency_contact_name'] = emergencyContactName;
    if (emergencyContactPhone != null) data['emergency_contact_phone'] = emergencyContactPhone;
    if (allergies != null) data['allergies'] = allergies;
    if (knownConditions != null) data['known_conditions'] = knownConditions;
    
    final response = await _apiClient.post(
      ApiEndpoints.patients,
      data: 
//       {
 
//   "first_name": "Grace",
//   "last_name": "Mwangi",
//   "dob": "1995-04-21",
//   "gender": "female",
//   "national_id": "34567891",
//   "phone": "+254712345678",
//   "email": "grace.mwangi@example.com",
//   "address": "Kilimani, Nairobi, Kenya",
//   "emergency_contact_name": "John Mwangi",
//   "emergency_contact_phone": "+254701112233",
//   "allergies": "Penicillin, Dust",
//   "known_conditions": "Asthma",
//   "created_at": "2025-11-09T10:00:00Z",
//   "updated_at": "2025-11-09T10:00:00Z"
// }
data,
    );
    
    final apiResponse = ApiResponse.fromJson(
      response.data,
      (json) => Patient.fromJson(json as Map<String, dynamic>),
    );
    
    return apiResponse.data!;
  }
  
  /// Update patient
  Future<Patient> updatePatient(int id, Map<String, dynamic> updates) async {
    final response = await _apiClient.put(
      ApiEndpoints.patient(id),
      data: updates,
    );
    
    final apiResponse = ApiResponse.fromJson(
      response.data,
      (json) => Patient.fromJson(json as Map<String, dynamic>),
    );
    
    return apiResponse.data!;
  }
  
  /// Delete patient (soft delete)
  Future<void> deletePatient(int id) async {
    await _apiClient.delete(ApiEndpoints.patient(id));
  }
  
  /// Get patient medical records
  Future<Map<String, dynamic>> getPatientRecords(int id) async {
    final response = await _apiClient.get(ApiEndpoints.patientRecords(id));
    
    final apiResponse = ApiResponse.fromJson(
      response.data,
      (json) => json,
    );
    
    return apiResponse.data as Map<String, dynamic>;
  }
}
