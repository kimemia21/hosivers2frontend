import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../comms/services/patient_service.dart';
import '../models/patient_model.dart';
import '../core/constants.dart';

/// Patient service provider
final patientServiceProvider = Provider<PatientService>((ref) => PatientService());

/// Patients list provider with pagination
final patientsProvider = StateNotifierProvider.family<PatientsNotifier, AsyncValue<PaginatedPatients>, PatientsFilter>(
  (ref, filter) => PatientsNotifier(ref.read(patientServiceProvider), filter),
);

/// Patients filter
class PatientsFilter {
  final int page;
  final int limit;
  final String? search;
  final String? sort;
  final String? order;
  
  const PatientsFilter({
    this.page = 1,
    this.limit = AppConstants.defaultPageSize,
    this.search,
    this.sort = 'id',
    this.order = 'desc',
  });
  
  PatientsFilter copyWith({
    int? page,
    int? limit,
    String? search,
    String? sort,
    String? order,
  }) {
    return PatientsFilter(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      search: search ?? this.search,
      sort: sort ?? this.sort,
      order: order ?? this.order,
    );
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PatientsFilter &&
        other.page == page &&
        other.limit == limit &&
        other.search == search &&
        other.sort == sort &&
        other.order == order;
  }
  
  @override
  int get hashCode => Object.hash(page, limit, search, sort, order);
}

/// Patients notifier
class PatientsNotifier extends StateNotifier<AsyncValue<PaginatedPatients>> {
  final PatientService _patientService;
  final PatientsFilter filter;
  
  PatientsNotifier(this._patientService, this.filter) : super(const AsyncValue.loading()) {
    loadPatients();
  }
  
  /// Load patients
  Future<void> loadPatients() async {
    state = const AsyncValue.loading();
    try {
      final result = await _patientService.getAllPatients(
        page: filter.page,
        limit: filter.limit,
        search: filter.search,
        sort: filter.sort,
        order: filter.order,
      );
      state = AsyncValue.data(result);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
  
  /// Refresh patients
  Future<void> refresh() async {
    await loadPatients();
  }
}

/// Single patient provider
final patientProvider = FutureProvider.family<Patient, int>((ref, id) async {
  final service = ref.read(patientServiceProvider);
  return await service.getPatientById(id);
});

/// Patient records provider
final patientRecordsProvider = FutureProvider.family<Map<String, dynamic>, int>((ref, id) async {
  final service = ref.read(patientServiceProvider);
  return await service.getPatientRecords(id);
});

/// Create patient action
final createPatientProvider = Provider<Future<Patient> Function(Map<String, dynamic>)>((ref) {
  return (data) async {
    final service = ref.read(patientServiceProvider);
    return await service.createPatient(
      firstName: data['first_name'],
      lastName: data['last_name'],
      dob: data['dob'],
      gender: data['gender'],
      nationalId: data['national_id'],
      phone: data['phone'],
      email: data['email'],
      address: data['address'],
      emergencyContactName: data['emergency_contact_name'],
      emergencyContactPhone: data['emergency_contact_phone'],
      allergies: data['allergies'],
      knownConditions: data['known_conditions'],
    );
  };
});

/// Update patient action
final updatePatientProvider = Provider<Future<Patient> Function(int, Map<String, dynamic>)>((ref) {
  return (id, updates) async {
    final service = ref.read(patientServiceProvider);
    return await service.updatePatient(id, updates);
  };
});

/// Delete patient action
final deletePatientProvider = Provider<Future<void> Function(int)>((ref) {
  return (id) async {
    final service = ref.read(patientServiceProvider);
    await service.deletePatient(id);
  };
});
