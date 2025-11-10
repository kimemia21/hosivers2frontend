import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hospital_management/widgets/appAlert.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/radius.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_view.dart';
import '../../widgets/empty_view.dart';
import '../../state/patient_provider.dart';
import '../../core/utils.dart';
import 'patient_form_screen.dart';
import 'patient_detail_screen.dart';

/// Modern Patients Management Screen
/// Displays a comprehensive list of all patients with search and detailed information
class PatientsScreen extends ConsumerStatefulWidget {
  const PatientsScreen({super.key});

  @override
  ConsumerState<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends ConsumerState<PatientsScreen> {
  final _searchController = TextEditingController();
  String? _searchQuery;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filter = PatientsFilter(page: 1, limit: 50, search: _searchQuery);
    final patientsAsync = ref.watch(patientsProvider(filter));

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          'Patient Records',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              ref.read(patientsProvider(filter).notifier).refresh();
            },
            tooltip: 'Refresh patient list',
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
          // Modern search bar with description
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(
                    context,
                  ).colorScheme.outline.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by name, phone, or patient ID...',
                    hintStyle: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                    prefixIcon: const Icon(Icons.search_rounded, size: 22),
                    suffixIcon: _searchQuery != null
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 20),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = null);
                            },
                            tooltip: 'Clear search',
                          )
                        : null,
                    filled: true,
                    fillColor: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                  ),
                  onSubmitted: (value) {
                    setState(() => _searchQuery = value.isEmpty ? null : value);
                  },
                ),
                const VSpace.sm(),
                patientsAsync.when(
                  data: (data) => Text(
                    '${data.patients.length} patient${data.patients.length != 1 ? 's' : ''} found${_searchQuery != null ? ' for "$_searchQuery"' : ''}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  loading: () => Text(
                    'Searching patients...',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ],
            ),
          ),

          // Modern patients list with detailed cards
          Expanded(
            child: patientsAsync.when(
              data: (data) {
                print(
                  '=== SCREEN: Rendering data with ${data.patients.length} patients ===',
                );
                if (data.patients.isEmpty) {
                  return EmptyView(
                    message: _searchQuery != null
                        ? 'No patients match your search criteria.\nTry adjusting your search terms.'
                        : 'No patients registered yet.\nAdd your first patient to get started.',
                    icon: Icons.people_outline,
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: data.patients.length,
                  itemBuilder: (context, index) {
                    final patient = data.patients[index];
                    final age = patient.dob != null
                        ? Utils.calculateAge(DateTime.parse(patient.dob!))
                        : null;

                    return Container(
                      margin: const EdgeInsets.only(bottom: AppSpacing.md),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: AppRadius.card,
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).colorScheme.outline.withValues(alpha: 0.2),
                          width: 0.5,
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () async {
                            // Navigate to patient details
                            final result = await BlurAlertDialog.show(
                              customBody:PatientDetailScreen(patientId: patient.id),
                              context: context, title: patient.firstName ,message:patient.lastName );

                            // Navigator.push<bool>(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (_) =>
                            //         PatientDetailScreen(patientId: patient.id),
                            //   ),
                            // );

                            // Refresh list if patient was updated or deleted
                            if (result == true) {
                              ref
                                  .read(patientsProvider(filter).notifier)
                                  .refresh();
                            }
                          },
                          borderRadius: AppRadius.card,
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            child: Row(
                              children: [
                                // Avatar with gradient
                                Container(
                                  width: 56,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        AppColors.patientCard,
                                        AppColors.patientCard.withValues(
                                          alpha: 0.7,
                                        ),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      AppRadius.md,
                                    ),
                                    border: Border.all(
                                      color: AppColors.patientCard.withValues(
                                        alpha: 0.3,
                                      ),
                                      width: 2,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      Utils.getInitials(patient.fullName),
                                      style: TextStyle(
                                        color: AppColors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                                const HSpace.md(),

                                // Patient information
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        patient.fullName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: -0.2,
                                            ),
                                      ),
                                      const VSpace.xs(),
                                      Row(
                                        children: [
                                          if (age != null) ...[
                                            Icon(
                                              Icons.cake_outlined,
                                              size: 14,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface
                                                  .withValues(alpha: 0.5),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              '$age years old',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurface
                                                        .withValues(alpha: 0.6),
                                                  ),
                                            ),
                                            const SizedBox(width: 12),
                                          ],
                                          Icon(
                                            Icons.badge_outlined,
                                            size: 14,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withValues(alpha: 0.5),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            'ID: ${patient.id}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface
                                                      .withValues(alpha: 0.6),
                                                ),
                                          ),
                                        ],
                                      ),
                                      const VSpace.xs(),
                                      if (patient.phone != null) ...[
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.phone_outlined,
                                              size: 14,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface
                                                  .withValues(alpha: 0.5),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              patient.phone!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurface
                                                        .withValues(alpha: 0.6),
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ],
                                      if (patient.email != null) ...[
                                        const VSpace.xs(),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.email_outlined,
                                              size: 14,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface
                                                  .withValues(alpha: 0.5),
                                            ),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                patient.email!,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSurface
                                                          .withValues(
                                                            alpha: 0.6,
                                                          ),
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
                                  color: Theme.of(context).colorScheme.onSurface
                                      .withValues(alpha: 0.3),
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
              loading: () {
                print('=== SCREEN: Showing loading indicator ===');
                return const LoadingIndicator(
                  message: 'Loading patient records...',
                );
              },
              error: (error, stack) {
                print('=== SCREEN: Showing error: $error ===');
                return ErrorView(
                  message: error.toString(),
                  onRetry: () =>
                      ref.read(patientsProvider(filter).notifier).refresh(),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // Navigate to create patient screen
          final result =  await BlurAlertDialog.show(
                              customBody: PatientFormScreen(),
                              context: context, title:"Create new Patient" ,message:'Add Patient');
          
          //  await Navigator.push<bool>(
          //   context,
          //   MaterialPageRoute(builder: (_) => const PatientFormScreen()),
          // );

          // Refresh list if patient was created
          if (result == true) {
            ref.read(patientsProvider(filter).notifier).refresh();
          }
        },
        icon: const Icon(Icons.person_add_rounded),
        label: const Text('Add Patient'),
        tooltip: 'Register a new patient',
      ),
    );
  }
}
