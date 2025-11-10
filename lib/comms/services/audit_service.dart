import '../api_client.dart';
import '../api_endpoints.dart';
import '../../models/audit_log_model.dart';
import '../../models/api_response.dart';

/// Audit service for viewing audit logs
class AuditService {
  final ApiClient _apiClient;
  
  AuditService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();
  
  /// Get audit logs with pagination and filters
  Future<PaginatedAuditLogs> getAuditLogs({
    int page = 1,
    int limit = 50,
    int? userId,
    String? action,
    String? objectType,
    String? startDate,
    String? endDate,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
    };
    
    if (userId != null) queryParams['user_id'] = userId;
    if (action != null) queryParams['action'] = action;
    if (objectType != null) queryParams['object_type'] = objectType;
    if (startDate != null) queryParams['start_date'] = startDate;
    if (endDate != null) queryParams['end_date'] = endDate;
    
    final response = await _apiClient.get(
      ApiEndpoints.auditLogs,
      queryParameters: queryParams,
    );
    
    // The API returns: {status, data: [logs...], pagination: {...}}
    // We need to restructure it to match PaginatedAuditLogs model
    final responseData = response.data as Map<String, dynamic>;
    final auditLogsData = {
      'logs': responseData['data'],
      'pagination': responseData['pagination'],
    };
    
    return PaginatedAuditLogs.fromJson(auditLogsData);
  }
}
