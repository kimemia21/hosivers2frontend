import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/radius.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_view.dart';
import '../../widgets/empty_view.dart';
import '../../state/doctor_provider.dart';

/// Modern Doctors Directory Screen
/// Displays medical staff with specializations, departments, and contact information
class DoctorsScreen extends ConsumerWidget {
  const DoctorsScreen({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doctorsAsync = ref.watch(doctorsProvider);
    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          'Medical Staff Directory',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.invalidate(doctorsProvider),
            tooltip: 'Refresh doctors list',
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
          // Header with count
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
            child: Row(
              children: [
                Icon(
                  Icons.local_hospital_rounded,
                  size: 20,
                  color: AppColors.doctorCard,
                ),
                const SizedBox(width: 8),
                doctorsAsync.when(
                  data: (doctors) => Text(
                    '${doctors.length} medical professional${doctors.length != 1 ? 's' : ''} registered',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  loading: () => Text(
                    'Loading medical staff...',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ],
            ),
          ),
          
          // Doctors list
          Expanded(
            child: doctorsAsync.when(
              data: (doctors) {
                if (doctors.isEmpty) {
                  return const EmptyView(
                    message: 'No doctors registered yet.\nAdd medical staff to get started.',
                    icon: Icons.medical_services_outlined,
                  );
                }
                
                return ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: doctors.length,
                  itemBuilder: (context, index) {
                    final doctor = doctors[index];
                    
                    return Container(
                      margin: const EdgeInsets.only(bottom: AppSpacing.md),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: AppRadius.card,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                          width: 0.5,
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            // Navigate to doctor details
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Opening profile for Dr. ${doctor.name}'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          borderRadius: AppRadius.card,
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            child: Row(
                              children: [
                                // Doctor avatar with medical icon
                                Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        AppColors.doctorCard,
                                        AppColors.doctorCard.withValues(alpha: 0.7),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(AppRadius.md),
                                    border: Border.all(
                                      color: AppColors.doctorCard.withValues(alpha: 0.3),
                                      width: 2,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.medical_services_rounded,
                                    color: AppColors.white,
                                    size: 32,
                                  ),
                                ),
                                const HSpace.md(),
                                
                                // Doctor information
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Dr. ',
                                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                              fontWeight: FontWeight.w500,
                                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              doctor.name,
                                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                fontWeight: FontWeight.w700,
                                                letterSpacing: -0.2,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      
                                      // Specialization
                                      if (doctor.specialization != null) ...[
                                        const VSpace.xs(),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: AppSpacing.sm,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.doctorCard.withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(AppRadius.sm),
                                            border: Border.all(
                                              color: AppColors.doctorCard.withValues(alpha: 0.3),
                                              width: 0.5,
                                            ),
                                          ),
                                          child: Text(
                                            doctor.specialization!,
                                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                              color: AppColors.doctorCard,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.3,
                                            ),
                                          ),
                                        ),
                                      ],
                                      
                                      const VSpace.xs(),
                                      
                                      // Department
                                      if (doctor.departmentName != null) ...[
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.business_rounded,
                                              size: 14,
                                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                                            ),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                doctor.departmentName!,
                                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                      
                                      // Phone
                                      if (doctor.phone != null) ...[
                                        const VSpace.xs(),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.phone_outlined,
                                              size: 14,
                                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              doctor.phone!,
                                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                      
                                      // Email
                                      if (doctor.email != null) ...[
                                        const VSpace.xs(),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.email_outlined,
                                              size: 14,
                                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                                            ),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                doctor.email!,
                                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                
                                // Arrow icon
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 16,
                                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const LoadingIndicator(message: 'Loading medical staff directory...'),
              error: (error, stack) => ErrorView(
                message: error.toString(),
                onRetry: () => ref.invalidate(doctorsProvider),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigate to add doctor screen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Add new doctor feature coming soon...'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        icon: const Icon(Icons.person_add_alt_rounded),
        label: const Text('Add Doctor'),
        tooltip: 'Register new medical staff',
      ),
    );
  }
}
