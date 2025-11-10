import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/spacing.dart';
import '../../theme/radius.dart';
import '../../theme/colors.dart';
import '../../models/inventory_model.dart';
import '../../comms/services/inventory_service.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';

/// Inventory Form Screen for Create/Edit
class InventoryFormScreen extends ConsumerStatefulWidget {
  final InventoryItem? item; // null for create, provided for edit
  
  const InventoryFormScreen({super.key, this.item});
  
  @override
  ConsumerState<InventoryFormScreen> createState() => _InventoryFormScreenState();
}

class _InventoryFormScreenState extends ConsumerState<InventoryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _inventoryService = InventoryService();
  
  late TextEditingController _skuController;
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _batchNumberController;
  late TextEditingController _expiryDateController;
  late TextEditingController _unitController;
  late TextEditingController _quantityController;
  late TextEditingController _locationController;
  
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    _skuController = TextEditingController(text: widget.item?.sku ?? '');
    _nameController = TextEditingController(text: widget.item?.name ?? '');
    _descriptionController = TextEditingController(text: widget.item?.description ?? '');
    _batchNumberController = TextEditingController(text: widget.item?.batchNumber ?? '');
    _expiryDateController = TextEditingController(text: widget.item?.expiryDate ?? '');
    _unitController = TextEditingController(text: widget.item?.unit ?? '');
    _quantityController = TextEditingController(text: widget.item?.quantity.toString() ?? '');
    _locationController = TextEditingController(text: widget.item?.location ?? '');
  }
  
  @override
  void dispose() {
    _skuController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _batchNumberController.dispose();
    _expiryDateController.dispose();
    _unitController.dispose();
    _quantityController.dispose();
    _locationController.dispose();
    super.dispose();
  }
  
  Future<void> _selectExpiryDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.item?.expiryDate != null 
        ? DateTime.parse(widget.item!.expiryDate!) 
        : DateTime.now().add(const Duration(days: 365)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
    );
    
    if (picked != null) {
      setState(() {
        _expiryDateController.text = picked.toIso8601String().split('T')[0];
      });
    }
  }
  
  Future<void> _saveItem() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() => _isLoading = true);
    
    try {
      final quantity = int.parse(_quantityController.text);
      
      if (widget.item == null) {
        // Create new item
        await _inventoryService.createInventory(
          sku: _skuController.text,
          name: _nameController.text,
          description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
          batchNumber: _batchNumberController.text.isEmpty ? null : _batchNumberController.text,
          expiryDate: _expiryDateController.text.isEmpty ? null : _expiryDateController.text,
          unit: _unitController.text.isEmpty ? null : _unitController.text,
          quantity: quantity,
          location: _locationController.text.isEmpty ? null : _locationController.text,
        );
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Inventory item created successfully'),
              backgroundColor: AppColors.success,
            ),
          );
          Navigator.pop(context, true);
        }
      } else {
        // Update existing item
        final updates = <String, dynamic>{};
        if (_skuController.text != widget.item!.sku) {
          updates['sku'] = _skuController.text;
        }
        if (_nameController.text != widget.item!.name) {
          updates['name'] = _nameController.text;
        }
        if (_descriptionController.text != (widget.item!.description ?? '')) {
          updates['description'] = _descriptionController.text;
        }
        if (_batchNumberController.text != (widget.item!.batchNumber ?? '')) {
          updates['batch_number'] = _batchNumberController.text;
        }
        if (_expiryDateController.text != (widget.item!.expiryDate ?? '')) {
          updates['expiry_date'] = _expiryDateController.text;
        }
        if (_unitController.text != (widget.item!.unit ?? '')) {
          updates['unit'] = _unitController.text;
        }
        if (quantity != widget.item!.quantity) {
          updates['quantity'] = quantity;
        }
        if (_locationController.text != (widget.item!.location ?? '')) {
          updates['location'] = _locationController.text;
        }
        
        if (updates.isNotEmpty) {
          await _inventoryService.updateInventory(widget.item!.id, updates);
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Inventory item updated successfully'),
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
    final isEdit = widget.item != null;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? 'Edit Inventory Item' : 'Add Inventory Item',
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
            // Basic Information
            _buildSectionHeader('Basic Information'),
            const VSpace.md(),
            
            AppTextField(
              controller: _skuController,
              label: 'SKU (Stock Keeping Unit)',
              prefixIcon: Icons.qr_code_rounded,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'SKU is required';
                }
                return null;
              },
            ),
            const VSpace.md(),
            
            AppTextField(
              controller: _nameController,
              label: 'Item Name',
              prefixIcon: Icons.medication_outlined,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Item name is required';
                }
                return null;
              },
            ),
            const VSpace.md(),
            
            AppTextField(
              controller: _descriptionController,
              label: 'Description (Optional)',
              prefixIcon: Icons.description_outlined,
              maxLines: 3,
            ),
            const VSpace.lg(),
            
            // Stock Information
            _buildSectionHeader('Stock Information'),
            const VSpace.md(),
            
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: AppTextField(
                    controller: _quantityController,
                    label: 'Quantity',
                    prefixIcon: Icons.inventory_2_outlined,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Quantity is required';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Must be a number';
                      }
                      return null;
                    },
                  ),
                ),
                const HSpace.md(),
                Expanded(
                  child: AppTextField(
                    controller: _unitController,
                    label: 'Unit',
                    prefixIcon: Icons.straighten_rounded,
                    hint: 'e.g., tablets, ml',
                  ),
                ),
              ],
            ),
            const VSpace.md(),
            
            AppTextField(
              controller: _batchNumberController,
              label: 'Batch Number (Optional)',
              prefixIcon: Icons.numbers_rounded,
            ),
            const VSpace.md(),
            
            AppTextField(
              controller: _expiryDateController,
              label: 'Expiry Date (Optional)',
              prefixIcon: Icons.event_outlined,
              readOnly: true,
              onTap: _selectExpiryDate,
            ),
            const VSpace.md(),
            
            AppTextField(
              controller: _locationController,
              label: 'Storage Location (Optional)',
              prefixIcon: Icons.location_on_outlined,
              hint: 'e.g., Shelf A-1, Room 3',
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
                  child: AppButton(
                    onPressed: _isLoading ? null : _saveItem,
                    isLoading: _isLoading,
                    text:isEdit ? 'Update Item' : 'Add Item',
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
        color: AppColors.moduleInventory.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(
          color: AppColors.moduleInventory.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 18,
            color: AppColors.moduleInventory,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.moduleInventory,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
