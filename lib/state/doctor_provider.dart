import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../comms/services/doctor_service.dart';
import '../models/doctor_model.dart';

/// Doctor service provider
final doctorServiceProvider = Provider<DoctorService>((ref) => DoctorService());

/// Doctors list provider
final doctorsProvider = FutureProvider<List<Doctor>>((ref) async {
  final service = ref.read(doctorServiceProvider);
  return await service.getAllDoctors();
});

/// Single doctor provider
final doctorProvider = FutureProvider.family<Doctor, int>((ref, id) async {
  final service = ref.read(doctorServiceProvider);
  return await service.getDoctorById(id);
});

/// Create doctor action
final createDoctorProvider = Provider<Future<Doctor> Function(Map<String, dynamic>)>((ref) {
  return (data) async {
    final service = ref.read(doctorServiceProvider);
    return await service.createDoctor(
      userId: data['user_id'],
      departmentId: data['department_id'],
      licenseNumber: data['license_number'],
      specialization: data['specialization'],
      phone: data['phone'],
    );
  };
});

/// Update doctor action
final updateDoctorProvider = Provider<Future<void> Function(int, Map<String, dynamic>)>((ref) {
  return (id, updates) async {
    final service = ref.read(doctorServiceProvider);
    await service.updateDoctor(id, updates);
  };
});

/// Delete doctor action
final deleteDoctorProvider = Provider<Future<void> Function(int)>((ref) {
  return (id) async {
    final service = ref.read(doctorServiceProvider);
    await service.deleteDoctor(id);
  };
});
