import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/spacing.dart';
import '../../theme/radius.dart';
import '../../theme/colors.dart';
import '../../models/patient_model.dart';
import '../../comms/services/patient_service.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';

/// Patient Form Screen for Create/Edit
class PatientFormScreen extends ConsumerStatefulWidget {
  final Patient? patient; // null for create, provided for edit
  
  const PatientFormScreen({super.key, this.patient});
  
  @override
  ConsumerState<PatientFormScreen> createState() => _PatientFormScreenState();
}

class _PatientFormScreenState extends ConsumerState<PatientFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _patientService = PatientService();
  
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _dobController;
  late TextEditingController _nationalIdController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _emergencyContactNameController;
  late TextEditingController _emergencyContactPhoneController;
  late TextEditingController _allergiesController;
  late TextEditingController _knownConditionsController;
  
  String _selectedGender = 'male';
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.patient?.firstName ?? '');
    _lastNameController = TextEditingController(text: widget.patient?.lastName ?? '');
    _dobController = TextEditingController(text: widget.patient?.dob ?? '');
    _nationalIdController = TextEditingController(text: widget.patient?.nationalId ?? '');
    _phoneController = TextEditingController(text: widget.patient?.phone ?? '');
    _emailController = TextEditingController(text: widget.patient?.email ?? '');
    _addressController = TextEditingController(text: widget.patient?.address ?? '');
    _emergencyContactNameController = TextEditingController(text: widget.patient?.emergencyContactName ?? '');
    _emergencyContactPhoneController = TextEditingController(text: widget.patient?.emergencyContactPhone ?? '');
    _allergiesController = TextEditingController(text: widget.patient?.allergies ?? '');
    _knownConditionsController = TextEditingController(text: widget.patient?.knownConditions ?? '');
    
    if (widget.patient != null) {
      _selectedGender = widget.patient!.gender!;
    }
  }
  
  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dobController.dispose();
    _nationalIdController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _emergencyContactNameController.dispose();
    _emergencyContactPhoneController.dispose();
    _allergiesController.dispose();
    _knownConditionsController.dispose();
    super.dispose();
  }
  
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.patient?.dob != null 
        ? DateTime.parse(widget.patient!.dob!) 
        : DateTime.now().subtract(const Duration(days: 365 * 30)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    
    if (picked != null) {
      setState(() {
        _dobController.text = picked.toIso8601String().split('T')[0];
      });
    }
  }
  
  Future<void> _savePatient() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() => _isLoading = true);
    
    try {
      if (widget.patient == null) {
        // Create new patient
        await _patientService.createPatient(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          dob: _dobController.text,
          gender: _selectedGender,
          nationalId: _nationalIdController.text.isEmpty ? null : _nationalIdController.text,
          phone: _phoneController.text.isEmpty ? null : _phoneController.text,
          email: _emailController.text.isEmpty ? null : _emailController.text,
          address: _addressController.text.isEmpty ? null : _addressController.text,
          emergencyContactName: _emergencyContactNameController.text.isEmpty ? null : _emergencyContactNameController.text,
          emergencyContactPhone: _emergencyContactPhoneController.text.isEmpty ? null : _emergencyContactPhoneController.text,
          allergies: _allergiesController.text.isEmpty ? null : _allergiesController.text,
          knownConditions: _knownConditionsController.text.isEmpty ? null : _knownConditionsController.text,
        );
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Patient created successfully'),
              backgroundColor: AppColors.success,
            ),
          );
          Navigator.pop(context, true);
        }
      } else {
        // Update existing patient
        final updates = <String, dynamic>{};
        if (_firstNameController.text != widget.patient!.firstName) {
          updates['first_name'] = _firstNameController.text;
        }
        if (_lastNameController.text != widget.patient!.lastName) {
          updates['last_name'] = _lastNameController.text;
        }
        if (_dobController.text != widget.patient!.dob) {
          updates['dob'] = _dobController.text;
        }
        if (_selectedGender != widget.patient!.gender) {
          updates['gender'] = _selectedGender;
        }
        if (_nationalIdController.text != (widget.patient!.nationalId ?? '')) {
          updates['national_id'] = _nationalIdController.text;
        }
        if (_phoneController.text != (widget.patient!.phone ?? '')) {
          updates['phone'] = _phoneController.text;
        }
        if (_emailController.text != (widget.patient!.email ?? '')) {
          updates['email'] = _emailController.text;
        }
        if (_addressController.text != (widget.patient!.address ?? '')) {
          updates['address'] = _addressController.text;
        }
        if (_emergencyContactNameController.text != (widget.patient!.emergencyContactName ?? '')) {
          updates['emergency_contact_name'] = _emergencyContactNameController.text;
        }
        if (_emergencyContactPhoneController.text != (widget.patient!.emergencyContactPhone ?? '')) {
          updates['emergency_contact_phone'] = _emergencyContactPhoneController.text;
        }
        if (_allergiesController.text != (widget.patient!.allergies ?? '')) {
          updates['allergies'] = _allergiesController.text;
        }
        if (_knownConditionsController.text != (widget.patient!.knownConditions ?? '')) {
          updates['known_conditions'] = _knownConditionsController.text;
        }
        
        if (updates.isNotEmpty) {
          await _patientService.updatePatient(widget.patient!.id, updates);
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Patient updated successfully'),
                backgroundColor: AppColors.success,
              ),
            );
            Navigator.pop(context, true);
          }
        } else {
          if (mounted) {
            Navigator.pop(context, false);
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final isEdit = widget.patient != null;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? 'Edit Patient' : 'Add New Patient',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            // Personal Information Section
            _buildSectionHeader('Personal Information'),
            const VSpace.md(),
            
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: _firstNameController,
                    label: 'First Name',
                    prefixIcon: Icons.person_outline,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'First name is required';
                      }
                      return null;
                    },
                  ),
                ),
                const HSpace.md(),
                Expanded(
                  child: AppTextField(
                    controller: _lastNameController,
                    label: 'Last Name',
                    prefixIcon:Icons.person_outline,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Last name is required';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const VSpace.md(),
            
            AppTextField(
              controller: _dobController,
              label: 'Date of Birth',
              prefixIcon: Icons.calendar_today,
              readOnly: true,
              onTap: _selectDate,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Date of birth is required';
                }
                return null;
              },
            ),
            const VSpace.md(),
            
            // Gender Selection
            Text(
              'Gender',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const VSpace.sm(),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Male'),
                    value: 'male',
                    groupValue: _selectedGender,
                    onChanged: (value) {
                      setState(() => _selectedGender = value!);
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Female'),
                    value: 'female',
                    groupValue: _selectedGender,
                    onChanged: (value) {
                      setState(() => _selectedGender = value!);
                    },
                  ),
                ),
              ],
            ),
            const VSpace.lg(),
            
            // Contact Information Section
            _buildSectionHeader('Contact Information'),
            const VSpace.md(),
            
            AppTextField(
              controller: _nationalIdController,
              label: 'National ID (Optional)',
              prefixIcon: Icons.badge_outlined,
            ),
            const VSpace.md(),
            
            AppTextField(
              controller: _phoneController,
              label: 'Phone Number',
              prefixIcon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),
            const VSpace.md(),
            
            AppTextField(
              controller: _emailController,
              label: 'Email Address',
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            const VSpace.md(),
            
            AppTextField(
              controller: _addressController,
              label: 'Address',
              prefixIcon: Icons.location_on_outlined,
              maxLines: 3,
            ),
            const VSpace.lg(),
            
            // Emergency Contact Section
            _buildSectionHeader('Emergency Contact'),
            const VSpace.md(),
            
            AppTextField(
              controller: _emergencyContactNameController,
              label: 'Contact Name',
              prefixIcon: Icons.contact_emergency_outlined,
            ),
            const VSpace.md(),
            
            AppTextField(
              controller: _emergencyContactPhoneController,
              label: 'Contact Phone',
              prefixIcon: Icons.phone_in_talk_outlined,
              keyboardType: TextInputType.phone,
            ),
            const VSpace.lg(),
            
            // Medical Information Section
            _buildSectionHeader('Medical Information'),
            const VSpace.md(),
            
            AppTextField(
              controller: _allergiesController,
              label: 'Allergies (Optional)',
              prefixIcon: Icons.health_and_safety_outlined,
              hint: 'e.g., Penicillin, Peanuts',
              maxLines: 2,
            ),
            const VSpace.md(),
            
            AppTextField(
              controller: _knownConditionsController,
              label: 'Known Conditions (Optional)',
              prefixIcon: Icons.medical_information_outlined,
              hint: 'e.g., Diabetes, Hypertension',
              maxLines: 3,
            ),
            const VSpace.xxl(),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                const HSpace.md(),
                Expanded(
                  flex: 2,
                  child:
                  
                   AppButton(
                    onPressed: _isLoading ? null : _savePatient,
                    isLoading: _isLoading,
                    
                    text: isEdit ? 'Update Patient' : 'Create Patient',
                  ),
                ),
              ],
            ),
            const VSpace.xxl(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 18,
            color: AppColors.primary,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
