import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../comms/services/prescription_service.dart';
import '../models/prescription_model.dart';
import '../core/constants.dart';

/// Prescription service provider
final prescriptionServiceProvider = Provider<PrescriptionService>((ref) => PrescriptionService());

/// Prescription filter
class PrescriptionFilter {
  final int page;
  final int limit;
  final String? status;
  final int? patientId;
  final int? doctorId;
  
  const PrescriptionFilter({
    this.page = 1,
    this.limit = AppConstants.defaultPageSize,
    this.status,
    this.patientId,
    this.doctorId,
  });
  
  PrescriptionFilter copyWith({
    int? page,
    int? limit,
    String? status,
    int? patientId,
    int? doctorId,
  }) {
    return PrescriptionFilter(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      status: status ?? this.status,
      patientId: patientId ?? this.patientId,
      doctorId: doctorId ?? this.doctorId,
    );
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PrescriptionFilter &&
        other.page == page &&
        other.limit == limit &&
        other.status == status &&
        other.patientId == patientId &&
        other.doctorId == doctorId;
  }
  
  @override
  int get hashCode => Object.hash(page, limit, status, patientId, doctorId);
}

/// Prescriptions list provider with pagination
final prescriptionsProvider = StateNotifierProvider.family<PrescriptionsNotifier, AsyncValue<PaginatedPrescriptions>, PrescriptionFilter>(
  (ref, filter) => PrescriptionsNotifier(ref.read(prescriptionServiceProvider), filter),
);

/// Prescriptions notifier
class PrescriptionsNotifier extends StateNotifier<AsyncValue<PaginatedPrescriptions>> {
  final PrescriptionService _prescriptionService;
  final PrescriptionFilter filter;
  
  PrescriptionsNotifier(this._prescriptionService, this.filter) : super(const AsyncValue.loading()) {
    loadPrescriptions();
  }
  
  /// Load prescriptions
  Future<void> loadPrescriptions() async {
    state = const AsyncValue.loading();
    try {
      final result = await _prescriptionService.getAllPrescriptions(
        page: filter.page,
        limit: filter.limit,
        status: filter.status,
        patientId: filter.patientId,
        doctorId: filter.doctorId,
      );
      state = AsyncValue.data(result);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
  
  /// Refresh prescriptions
  Future<void> refresh() async {
    await loadPrescriptions();
  }
}

/// Single prescription provider
final prescriptionProvider = FutureProvider.family<Prescription, int>((ref, id) async {
  final service = ref.read(prescriptionServiceProvider);
  return await service.getPrescriptionById(id);
});

/// Create prescription action
final createPrescriptionProvider = Provider<Future<Prescription> Function(Map<String, dynamic>)>((ref) {
  return (data) async {
    final service = ref.read(prescriptionServiceProvider);
    return await service.createPrescription(
      patientId: data['patient_id'],
      doctorId: data['doctor_id'],
      notes: data['notes'],
      status: data['status'] ?? 'active',
      items: data['items'],
    );
  };
});

/// Update prescription action
final updatePrescriptionProvider = Provider<Future<Prescription> Function(int, Map<String, dynamic>)>((ref) {
  return (id, updates) async {
    final service = ref.read(prescriptionServiceProvider);
    return await service.updatePrescription(id, updates);
  };
});
