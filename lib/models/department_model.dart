import 'package:json_annotation/json_annotation.dart';

part 'department_model.g.dart';

@JsonSerializable()
class Department {
  final int id;
  final String name;
  final String? description;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  
  Department({
    required this.id,
    required this.name,
    this.description,
    this.createdAt,
    this.updatedAt,
  });
  
  factory Department.fromJson(Map<String, dynamic> json) =>
      _$DepartmentFromJson(json);
  
  Map<String, dynamic> toJson() => _$DepartmentToJson(this);
  
  Department copyWith({
    int? id,
    String? name,
    String? description,
    String? createdAt,
    String? updatedAt,
  }) {
    return Department(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
