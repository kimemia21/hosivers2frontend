import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/app_text_field.dart';

import '../../state/patient_provider.dart';
import '../../state/doctor_provider.dart';

/// Add Prescription Form Widget
class AddPrescriptionForm extends ConsumerStatefulWidget {
  final Future<void> Function(Map<String, dynamic>) onSubmit;
  
  const AddPrescriptionForm({required this.onSubmit});
  
  @override
  ConsumerState<AddPrescriptionForm> createState() => AddPrescriptionFormState();
}

class AddPrescriptionFormState extends ConsumerState<AddPrescriptionForm> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  
  int? _selectedPatientId;
  int? _selectedDoctorId;
  String _selectedStatus = 'active';
  bool _isSubmitting = false;
  
  // List of prescription items (medications)
  final List<Map<String, dynamic>> _items = [];
  
  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }
  
  void _addMedicationItem() {
    setState(() {
      _items.add({
        'med_name': '',
        'dose': '',
        'frequency': '',
        'route': '',
        'quantity': 0,
        'instructions': '',
      });
    });
  }
  
  void _removeMedicationItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }
  
  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_selectedPatientId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a patient')),
      );
      return;
    }
    
    if (_selectedDoctorId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a doctor')),
      );
      return;
    }
    
    if (_items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one medication')),
      );
      return;
    }
    
    // Validate all items have required fields
    for (var i = 0; i < _items.length; i++) {
      if (_items[i]['med_name'].toString().trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter medication name for item ${i + 1}')),
        );
        return;
      }
    }
    
    setState(() => _isSubmitting = true);
    
    try {
      final data = {
        'patient_id': _selectedPatientId,
        'doctor_id': _selectedDoctorId,
        'notes': _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        'status': _selectedStatus,
        'items': _items,
      };
      
      await widget.onSubmit(data);
      
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final patientsAsync = ref.watch(patientsProvider(const PatientsFilter(limit: 100)));
    final doctorsAsync = ref.watch(doctorsProvider);
    final theme = Theme.of(context);
    
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Patient Selection
            Text(
              'Patient *',
              style: theme.textTheme.labelLarge,
            ),
            const SizedBox(height: 8),
            patientsAsync.when(
              data: (paginatedPatients) {
                final patients = paginatedPatients.patients;
                return DropdownButtonFormField<int>(
                  value: _selectedPatientId,
                  decoration: const InputDecoration(
                    hintText: 'Select patient',
                    prefixIcon: Icon(Icons.person),
                  ),
                  items: patients.map((patient) {
                    return DropdownMenuItem(
                      value: patient.id,
                      child: Text('${patient.firstName} ${patient.lastName}'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedPatientId = value);
                  },
                  validator: (value) => value == null ? 'Please select a patient' : null,
                );
              },
              loading: () => DropdownButtonFormField<int>(
                items: [],
                onChanged: null,
                decoration: InputDecoration(
                  hintText: 'Loading patients...',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              error: (err, _) => Text('Error loading patients: $err', style: TextStyle(color: theme.colorScheme.error)),
            ),
            
            const SizedBox(height: 16),
            
            // Doctor Selection
            Text(
              'Doctor *',
              style: theme.textTheme.labelLarge,
            ),
            const SizedBox(height: 8),
            doctorsAsync.when(
              data: (doctors) {
                return DropdownButtonFormField<int>(
                  value: _selectedDoctorId,
                  decoration: const InputDecoration(
                    hintText: 'Select doctor',
                    prefixIcon: Icon(Icons.medical_services),
                  ),
                  items: doctors.map((doctor) {
                    return DropdownMenuItem(
                      value: doctor.id,
                      child: Text(doctor.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedDoctorId = value);
                  },
                  validator: (value) => value == null ? 'Please select a doctor' : null,
                );
              },
              loading: () =>  DropdownButtonFormField<int>(
                items: [],
                onChanged: null,
                decoration: InputDecoration(
                  hintText: 'Loading doctors...',
                  prefixIcon: Icon(Icons.medical_services),
                ),
              ),
              error: (err, _) => Text('Error loading doctors: $err', style: TextStyle(color: theme.colorScheme.error)),
            ),
            
            const SizedBox(height: 16),
            
            // Status Selection
            Text(
              'Status',
              style: theme.textTheme.labelLarge,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.info_outline),
              ),
              items: const [
                DropdownMenuItem(value: 'active', child: Text('Active')),
                DropdownMenuItem(value: 'completed', child: Text('Completed')),
                DropdownMenuItem(value: 'cancelled', child: Text('Cancelled')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedStatus = value);
                }
              },
            ),
            
            const SizedBox(height: 16),
            
            // Notes
            AppTextField(
              label: 'Notes',
              hint: 'Enter prescription notes (optional)',
              controller: _notesController,
              maxLines: 3,
              prefixIcon: Icons.note,
            ),
            
            const SizedBox(height: 24),
            
            // Medications Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Medications *',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: _addMedicationItem,
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text('Add Medication'),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Medication Items List
            if (_items.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.3)),
                ),
                child: Center(
                  child: Text(
                    'No medications added yet',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              )
            else
              ..._items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return _MedicationItemCard(
                  index: index,
                  item: item,
                  onRemove: () => _removeMedicationItem(index),
                  onUpdate: (updatedItem) {
                    setState(() {
                      _items[index] = updatedItem;
                    });
                  },
                );
              }).toList(),
            
            const SizedBox(height: 24),
            
            // Submit Button
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Create Prescription',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Medication Item Card Widget
class _MedicationItemCard extends StatefulWidget {
  final int index;
  final Map<String, dynamic> item;
  final VoidCallback onRemove;
  final Function(Map<String, dynamic>) onUpdate;
  
  const _MedicationItemCard({
    required this.index,
    required this.item,
    required this.onRemove,
    required this.onUpdate,
  });
  
  @override
  State<_MedicationItemCard> createState() => _MedicationItemCardState();
}

class _MedicationItemCardState extends State<_MedicationItemCard> {
  late TextEditingController _medNameController;
  late TextEditingController _doseController;
  late TextEditingController _frequencyController;
  late TextEditingController _routeController;
  late TextEditingController _quantityController;
  late TextEditingController _instructionsController;
  
  @override
  void initState() {
    super.initState();
    _medNameController = TextEditingController(text: widget.item['med_name']);
    _doseController = TextEditingController(text: widget.item['dose']);
    _frequencyController = TextEditingController(text: widget.item['frequency']);
    _routeController = TextEditingController(text: widget.item['route']);
    _quantityController = TextEditingController(text: widget.item['quantity']?.toString() ?? '0');
    _instructionsController = TextEditingController(text: widget.item['instructions']);
    
    // Add listeners to update parent
    _medNameController.addListener(_updateItem);
    _doseController.addListener(_updateItem);
    _frequencyController.addListener(_updateItem);
    _routeController.addListener(_updateItem);
    _quantityController.addListener(_updateItem);
    _instructionsController.addListener(_updateItem);
  }
  
  void _updateItem() {
    widget.onUpdate({
      'med_name': _medNameController.text,
      'dose': _doseController.text,
      'frequency': _frequencyController.text,
      'route': _routeController.text,
      'quantity': int.tryParse(_quantityController.text) ?? 0,
      'instructions': _instructionsController.text,
    });
  }
  
  @override
  void dispose() {
    _medNameController.dispose();
    _doseController.dispose();
    _frequencyController.dispose();
    _routeController.dispose();
    _quantityController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Medication ${widget.index + 1}',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  color: theme.colorScheme.error,
                  onPressed: widget.onRemove,
                  tooltip: 'Remove medication',
                ),
              ],
            ),
            const SizedBox(height: 12),
            AppTextField(
              label: 'Medication Name *',
              hint: 'Enter medication name',
              controller: _medNameController,
              prefixIcon: Icons.medication,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    label: 'Dose',
                    hint: 'e.g., 500mg',
                    controller: _doseController,
                    prefixIcon: Icons.medical_information,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppTextField(
                    label: 'Frequency',
                    hint: 'e.g., Twice daily',
                    controller: _frequencyController,
                    prefixIcon: Icons.access_time,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    label: 'Route',
                    hint: 'e.g., Oral',
                    controller: _routeController,
                    prefixIcon: Icons.route,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppTextField(
                    label: 'Quantity',
                    hint: '0',
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    prefixIcon: Icons.numbers,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            AppTextField(
              label: 'Instructions',
              hint: 'Special instructions (optional)',
              controller: _instructionsController,
              maxLines: 2,
              prefixIcon: Icons.description,
            ),
          ],
        ),
      ),
    );
  }
}