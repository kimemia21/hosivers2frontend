import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hospital_management/screens/prescriptions/add_presecriptions.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_view.dart';
import '../../widgets/empty_view.dart';
import '../../widgets/appAlert.dart';
import '../../widgets/app_text_field.dart';
import '../../state/prescription_provider.dart';
import '../../state/patient_provider.dart';
import '../../state/doctor_provider.dart';
import '../../core/utils.dart';

/// Modern Prescriptions Management Screen
/// Displays medical prescriptions with patient details, doctor info, and status tracking
class PrescriptionsScreen extends ConsumerStatefulWidget {
  const PrescriptionsScreen({super.key});
  
  @override
  ConsumerState<PrescriptionsScreen> createState() => _PrescriptionsScreenState();
}

class _PrescriptionsScreenState extends ConsumerState<PrescriptionsScreen> {
  String? _selectedStatus;
  
  /// Show add prescription dialog
  void _showAddPrescriptionDialog(BuildContext context) {
    BlurAlertDialog.show(
      context: context,
      title: 'Add New Prescription',
      icon: Icons.note_add_rounded,
      iconColor: Theme.of(context).colorScheme.primary,
      customBody: AddPrescriptionForm(
        onSubmit: (data) async {
          try {
            // Create prescription using the service
            final createPrescription = ref.read(createPrescriptionProvider);
            await createPrescription(data);
            
            // Refresh the list
            final filter = PrescriptionFilter(
              page: 1,
              limit: 50,
              status: _selectedStatus,
            );
            ref.read(prescriptionsProvider(filter).notifier).refresh();
            
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Prescription created successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to create prescription: $e'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
      ),
      confirmText: null, // Form has its own submit button
      cancelText: null,
      scrollable: true,
      barrierDismissible: true,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final filter = PrescriptionFilter(
      page: 1,
      limit: 50,
      status: _selectedStatus,
    );
    final prescriptionsAsync = ref.watch(prescriptionsProvider(filter));
    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          'Prescription Records',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              ref.read(prescriptionsProvider(filter).notifier).refresh();
            },
            tooltip: 'Refresh prescriptions', 
            style: IconButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Modern status filter section
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Filter by Status',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const VSpace.sm(),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.xs,
                  children: [
                    FilterChip(
                      avatar: Icon(
                        Icons.medication_rounded,
                        size: 18,
                        color: _selectedStatus == 'active' ? AppColors.active : null,
                      ),
                      label: const Text('Active'),
                      selected: _selectedStatus == 'active',
                      selectedColor: AppColors.active.withValues(alpha: 0.15),
                      onSelected: (value) {
                        setState(() => _selectedStatus = value ? 'active' : null);
                      },
                    ),
                    FilterChip(
                      avatar: Icon(
                        Icons.check_circle_rounded,
                        size: 18,
                        color: _selectedStatus == 'completed' ? AppColors.completed : null,
                      ),
                      label: const Text('Completed'),
                      selected: _selectedStatus == 'completed',
                      selectedColor: AppColors.completed.withValues(alpha: 0.15),
                      onSelected: (value) {
                        setState(() => _selectedStatus = value ? 'completed' : null);
                      },
                    ),
                    FilterChip(
                      avatar: Icon(
                        Icons.cancel_rounded,
                        size: 18,
                        color: _selectedStatus == 'cancelled' ? AppColors.cancelled : null,
                      ),
                      label: const Text('Cancelled'),
                      selected: _selectedStatus == 'cancelled',
                      selectedColor: AppColors.cancelled.withValues(alpha: 0.15),
                      onSelected: (value) {
                        setState(() => _selectedStatus = value ? 'cancelled' : null);
                      },
                    ),
                  ],
                ),
                const VSpace.sm(),
                prescriptionsAsync.when(
                  data: (data) => Text(
                    '${data.prescriptions.length} prescription${data.prescriptions.length != 1 ? 's' : ''}${_selectedStatus != null ? ' (${_selectedStatus})' : ''}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  loading: () => Text(
                    'Loading prescriptions...',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ],
            ),
          ),
          
          // Prescriptions list
          Expanded(
            child: prescriptionsAsync.when(
              data: (data) {
                if (data.prescriptions.isEmpty) {
                  return const EmptyView(
                    message: 'No prescriptions found',
                    icon: Icons.description_outlined,
                  );
                }
                
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: data.prescriptions.length,
                  itemBuilder: (context, index) {
                    final prescription = data.prescriptions[index];
                    final statusColor = prescription.status == 'active'
                        ? AppColors.active
                        : prescription.status == 'completed'
                            ? AppColors.completed
                            : AppColors.cancelled;
                    
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.prescriptionCard,
                          child: const Icon(Icons.description, color: AppColors.white),
                        ),
                        title: Text(
                          prescription.patientName ?? 'Patient #${prescription.patientId}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Doctor: ${prescription.doctorName ?? "Dr. #${prescription.doctorId}"}'),
                            Text('Date: ${Utils.formatDate(DateTime.parse(prescription.issueDate))}'),
                            Text('Items: ${prescription.itemsCount ?? 0}'),
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: statusColor.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                prescription.status.toUpperCase(),
                                style: TextStyle(
                                  color: statusColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          // Navigate to prescription details
                        },
                      ),
                    );
                  },
                );
              },
              loading: () => const LoadingIndicator(message: 'Loading prescriptions...'),
              error: (error, stack) => ErrorView(
                message: error.toString(),
                onRetry: () => ref.read(prescriptionsProvider(filter).notifier).refresh(),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddPrescriptionDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}