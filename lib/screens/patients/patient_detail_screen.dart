import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hospital_management/widgets/appAlert.dart';
import '../../theme/spacing.dart';
import '../../theme/radius.dart';
import '../../theme/colors.dart';
import '../../models/patient_model.dart';
import '../../comms/services/patient_service.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_view.dart';
import '../../core/utils.dart';
import 'patient_form_screen.dart';

/// Patient Detail Screen - View and manage patient information
class PatientDetailScreen extends ConsumerStatefulWidget {
  final int patientId;

  const PatientDetailScreen({super.key, required this.patientId});

  @override
  ConsumerState<PatientDetailScreen> createState() =>
      _PatientDetailScreenState();
}

class _PatientDetailScreenState extends ConsumerState<PatientDetailScreen> {
  final _patientService = PatientService();
  Patient? _patient;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPatient();
  }

  Future<void> _loadPatient() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final patient = await _patientService.getPatientById(widget.patientId);
      setState(() {
        _patient = patient;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _editPatient() async {
    Navigator.pop(context);
    final result = await BlurAlertDialog.show(
      customBody: PatientFormScreen(patient: _patient),
      context: context,
      title: 'Edit Patient',
      message: 'You are about to edit patient details. Proceed?',
    );

    // Navigator.push<bool>(
    //   context,
    //   MaterialPageRoute(
    //     builder: (_) => PatientFormScreen(patient: _patient),
    //   ),
    // );

    if (result == true) {
      _loadPatient();
    }
  }

  Future<void> _deletePatient() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Patient'),
        content: Text(
          'Are you sure you want to delete ${_patient!.fullName}? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _patientService.deletePatient(widget.patientId);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Patient deleted successfully'),
              backgroundColor: AppColors.success,
            ),
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error deleting patient: ${e.toString()}'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,

        actions: [
          if (_patient != null) ...[
            IconButton(
              icon: const Icon(Icons.edit_rounded),
              onPressed: _editPatient,
              tooltip: 'Edit patient',
            ),
            IconButton(
              icon: const Icon(Icons.delete_rounded),
              onPressed: _deletePatient,
              tooltip: 'Delete patient',
            ),
          ],
          const SizedBox(width: 8),
        ],
      ),
      body: _isLoading
          ? const LoadingIndicator(message: 'Loading patient details...')
          : _error != null
          ? ErrorView(message: _error!, onRetry: _loadPatient)
          : _buildPatientDetails(),
    );
  }

  Widget _buildPatientDetails() {
    if (_patient == null) return const SizedBox.shrink();

    final age = _patient!.dob != null
        ? Utils.calculateAge(DateTime.parse(_patient!.dob!))
        : null;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        // Patient Header Card
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.patientCard,
                AppColors.patientCard.withValues(alpha: 0.8),
              ],
            ),
            borderRadius: AppRadius.card,
          ),
          child: Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.5),
                    width: 3,
                  ),
                ),
                child: Center(
                  child: Text(
                    Utils.getInitials(_patient!.fullName),
                    style: TextStyle(
                      color: AppColors.patientCard,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const VSpace.md(),
              Text(
                _patient!.fullName,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              if (age != null) ...[
                const VSpace.xs(),
                Text(
                  '$age years old',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
              const VSpace.sm(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  'Patient ID: ${_patient!.id}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),

        const VSpace.lg(),

        // Personal Information
        _buildSection('Personal Information', Icons.person_rounded, [
          _buildInfoRow('Full Name', _patient!.fullName, Icons.badge_outlined),
          _buildInfoRow(
            'Gender',
            _patient!.gender!.toUpperCase(),
            Icons.wc_outlined,
          ),
          if (_patient!.dob != null)
            _buildInfoRow(
              'Date of Birth',
              Utils.formatDate(DateTime.parse(_patient!.dob!)),
              Icons.cake_outlined,
            ),
          if (_patient!.nationalId != null)
            _buildInfoRow(
              'National ID',
              _patient!.nationalId!,
              Icons.credit_card_outlined,
            ),
        ]),

        const VSpace.lg(),

        // Contact Information
        _buildSection('Contact Information', Icons.contact_phone_rounded, [
          if (_patient!.phone != null)
            _buildInfoRow('Phone', _patient!.phone!, Icons.phone_outlined),
          if (_patient!.email != null)
            _buildInfoRow('Email', _patient!.email!, Icons.email_outlined),
          if (_patient!.address != null)
            _buildInfoRow(
              'Address',
              _patient!.address!,
              Icons.location_on_outlined,
            ),
        ]),

        const VSpace.lg(),

        // Emergency Contact
        if (_patient!.emergencyContactName != null ||
            _patient!.emergencyContactPhone != null)
          _buildSection('Emergency Contact', Icons.contact_emergency_rounded, [
            if (_patient!.emergencyContactName != null)
              _buildInfoRow(
                'Name',
                _patient!.emergencyContactName!,
                Icons.person_outline,
              ),
            if (_patient!.emergencyContactPhone != null)
              _buildInfoRow(
                'Phone',
                _patient!.emergencyContactPhone!,
                Icons.phone_in_talk_outlined,
              ),
          ]),

        const VSpace.lg(),

        // Medical Information
        if (_patient!.allergies != null || _patient!.knownConditions != null)
          _buildSection(
            'Medical Information',
            Icons.medical_information_rounded,
            [
              if (_patient!.allergies != null)
                _buildInfoRow(
                  'Allergies',
                  _patient!.allergies!,
                  Icons.health_and_safety_outlined,
                ),
              if (_patient!.knownConditions != null)
                _buildInfoRow(
                  'Known Conditions',
                  _patient!.knownConditions!,
                  Icons.medication_outlined,
                ),
            ],
          ),

        const VSpace.xxl(),
      ],
    );
  }

  Widget _buildSection(String title, IconData icon, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: AppRadius.card,
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.patientCard.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppRadius.lg),
                topRight: Radius.circular(AppRadius.lg),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, size: 24, color: AppColors.patientCard),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.patientCard,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.5),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
