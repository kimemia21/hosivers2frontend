import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'patient_provider.dart';
import 'doctor_provider.dart';
import 'inventory_provider.dart';
import 'prescription_provider.dart';

/// Dashboard statistics
class DashboardStats {
  final int totalPatients;
  final int totalDoctors;
  final int totalInventoryItems;
  final int totalPrescriptions;
  final int lowStockItems;
  final int expiringSoonItems;
  
  DashboardStats({
    required this.totalPatients,
    required this.totalDoctors,
    required this.totalInventoryItems,
    required this.totalPrescriptions,
    required this.lowStockItems,
    required this.expiringSoonItems,
  });
}

/// Dashboard statistics provider
final dashboardStatsProvider = FutureProvider<DashboardStats>((ref) async {
  // Fetch data from all sources
  final patientsAsync = ref.watch(patientsProvider(const PatientsFilter(page: 1, limit: 1)));
  final doctorsAsync = ref.watch(doctorsProvider);
  final inventoryAsync = ref.watch(inventoryProvider(const InventoryFilter(page: 1, limit: 1)));
  final prescriptionsAsync = ref.watch(prescriptionsProvider(const PrescriptionFilter(page: 1, limit: 1)));
  final lowStockAsync = ref.watch(inventoryProvider(const InventoryFilter(page: 1, limit: 1, lowStock: true)));
  final expiringSoonAsync = ref.watch(inventoryProvider(const InventoryFilter(page: 1, limit: 1, expiringSoon: true)));
  
  // Wait for all data
  final patients = patientsAsync.maybeWhen(
    data: (data) => data.pagination.total,
    orElse: () => 0,
  );
  
  final doctors = doctorsAsync.maybeWhen(
    data: (data) => data.length,
    orElse: () => 0,
  );
  
  final inventory = inventoryAsync.maybeWhen(
    data: (data) => data.pagination.total,
    orElse: () => 0,
  );
  
  final prescriptions = prescriptionsAsync.maybeWhen(
    data: (data) => data.pagination.total,
    orElse: () => 0,
  );
  
  final lowStock = lowStockAsync.maybeWhen(
    data: (data) => data.pagination.total,
    orElse: () => 0,
  );
  
  final expiringSoon = expiringSoonAsync.maybeWhen(
    data: (data) => data.pagination.total,
    orElse: () => 0,
  );
  
  return DashboardStats(
    totalPatients: patients,
    totalDoctors: doctors,
    totalInventoryItems: inventory,
    totalPrescriptions: prescriptions,
    lowStockItems: lowStock,
    expiringSoonItems: expiringSoon,
  );
});
