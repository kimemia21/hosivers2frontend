import 'package:json_annotation/json_annotation.dart';
import 'patient_model.dart';

part 'audit_log_model.g.dart';

@JsonSerializable()
class AuditLog {
  final int id;
  @JsonKey(name: 'user_id')
  final int? userId;
  @JsonKey(name: 'user_name')
  final String? userName;
  final String action;
  @JsonKey(name: 'object_type')
  final String? objectType;
  @JsonKey(name: 'object_id')
  final int? objectId;
  final Map<String, dynamic>? changes;
  @JsonKey(name: 'created_at')
  final String createdAt;
  
  AuditLog({
    required this.id,
    this.userId,
    this.userName,
    required this.action,
    this.objectType,
    this.objectId,
    this.changes,
    required this.createdAt,
  });
  
  factory AuditLog.fromJson(Map<String, dynamic> json) =>
      _$AuditLogFromJson(json);
  
  Map<String, dynamic> toJson() => _$AuditLogToJson(this);
}

@JsonSerializable()
class PaginatedAuditLogs {
  final List<AuditLog> logs;
  final Pagination pagination;
  
  PaginatedAuditLogs({
    required this.logs,
    required this.pagination,
  });
  
  factory PaginatedAuditLogs.fromJson(Map<String, dynamic> json) =>
      _$PaginatedAuditLogsFromJson(json);
  
  Map<String, dynamic> toJson() => _$PaginatedAuditLogsToJson(this);
}
