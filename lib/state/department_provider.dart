import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../comms/services/department_service.dart';
import '../models/department_model.dart';

/// Department service provider
final departmentServiceProvider = Provider<DepartmentService>((ref) => DepartmentService());

/// Departments list provider
final departmentsProvider = FutureProvider<List<Department>>((ref) async {
  final service = ref.read(departmentServiceProvider);
  return await service.getAllDepartments();
});

/// Single department provider
final departmentProvider = FutureProvider.family<Department, int>((ref, id) async {
  final service = ref.read(departmentServiceProvider);
  return await service.getDepartmentById(id);
});

/// Create department action
final createDepartmentProvider = Provider<Future<Department> Function(String, String?)>((ref) {
  return (name, description) async {
    final service = ref.read(departmentServiceProvider);
    return await service.createDepartment(name: name, description: description);
  };
});

/// Update department action
final updateDepartmentProvider = Provider<Future<void> Function(int, Map<String, dynamic>)>((ref) {
  return (id, updates) async {
    final service = ref.read(departmentServiceProvider);
    await service.updateDepartment(id, updates);
  };
});

/// Delete department action
final deleteDepartmentProvider = Provider<Future<void> Function(int)>((ref) {
  return (id) async {
    final service = ref.read(departmentServiceProvider);
    await service.deleteDepartment(id);
  };
});
