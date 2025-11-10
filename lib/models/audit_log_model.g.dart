// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_log_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuditLog _$AuditLogFromJson(Map<String, dynamic> json) => AuditLog(
  id: (json['id'] as num).toInt(),
  userId: (json['user_id'] as num?)?.toInt(),
  userName: json['user_name'] as String?,
  action: json['action'] as String,
  objectType: json['object_type'] as String?,
  objectId: (json['object_id'] as num?)?.toInt(),
  changes: json['changes'] as Map<String, dynamic>?,
  createdAt: json['created_at'] as String,
);

Map<String, dynamic> _$AuditLogToJson(AuditLog instance) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'user_name': instance.userName,
  'action': instance.action,
  'object_type': instance.objectType,
  'object_id': instance.objectId,
  'changes': instance.changes,
  'created_at': instance.createdAt,
};

PaginatedAuditLogs _$PaginatedAuditLogsFromJson(Map<String, dynamic> json) =>
    PaginatedAuditLogs(
      logs: (json['logs'] as List<dynamic>)
          .map((e) => AuditLog.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: Pagination.fromJson(
        json['pagination'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$PaginatedAuditLogsToJson(PaginatedAuditLogs instance) =>
    <String, dynamic>{
      'logs': instance.logs.map((e) => e.toJson()).toList(),
      'pagination': instance.pagination.toJson(),
    };
