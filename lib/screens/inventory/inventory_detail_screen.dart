import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hospital_management/widgets/appAlert.dart';
import '../../theme/spacing.dart';
import '../../theme/radius.dart';
import '../../theme/colors.dart';
import '../../models/inventory_model.dart';
import '../../comms/services/inventory_service.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_view.dart';
import '../../core/utils.dart';
import 'inventory_form_screen.dart';

/// Inventory Detail Screen - View and manage inventory item
class InventoryDetailScreen extends ConsumerStatefulWidget {
  final int itemId;
  
  const InventoryDetailScreen({super.key, required this.itemId});
  
  @override
  ConsumerState<InventoryDetailScreen> createState() => _InventoryDetailScreenState();
}

class _InventoryDetailScreenState extends ConsumerState<InventoryDetailScreen> {
  final _inventoryService = InventoryService();
  InventoryItem? _item;
  bool _isLoading = true;
  String? _error;
  
  @override
  void initState() {
    super.initState();
    _loadItem();
  }
  
  Future<void> _loadItem() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    
    try {
      final item = await _inventoryService.getInventoryById(widget.itemId);
      setState(() {
        _item = item;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }
  
  Future<void> _editItem() async {
    final result = await BlurAlertDialog.show(context: context, title:_item!.name ,message:'edit item details',customBody: InventoryFormScreen(item: _item),);
                            
    
    
    
    if (result == true) {
      _loadItem();
    }
  }
  
  Future<void> _deleteItem() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Inventory Item'),
        content: Text('Are you sure you want to delete ${_item!.name}? This action cannot be undone.'),
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
        await _inventoryService.deleteInventory(widget.itemId);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Item deleted successfully'),
              backgroundColor: AppColors.success,
            ),
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error deleting item: ${e.toString()}'),
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
        title: Text(
          'Inventory Details',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          if (_item != null) ...[
            IconButton(
              icon: const Icon(Icons.edit_rounded),
              onPressed: _editItem,
              tooltip: 'Edit item',
            ),
            IconButton(
              icon: const Icon(Icons.delete_rounded),
              onPressed: _deleteItem,
              tooltip: 'Delete item',
            ),
          ],
          const SizedBox(width: 8),
        ],
      ),
      body: _isLoading
          ? const LoadingIndicator(message: 'Loading item details...')
          : _error != null
              ? ErrorView(message: _error!, onRetry: _loadItem)
              : _buildItemDetails(),
    );
  }
  
  Widget _buildItemDetails() {
    if (_item == null) return const SizedBox.shrink();
    
    Color statusColor = AppColors.moduleInventory;
    String? statusText;
    IconData statusIcon = Icons.check_circle_outline;
    
    if (_item!.isExpired) {
      statusColor = AppColors.error;
      statusText = 'EXPIRED';
      statusIcon = Icons.dangerous_outlined;
    } else if (_item!.isExpiringSoon) {
      statusColor = AppColors.warning;
      statusText = 'EXPIRING SOON';
      statusIcon = Icons.warning_amber_outlined;
    } else if (_item!.isLowStock) {
      statusColor = AppColors.warning;
      statusText = 'LOW STOCK';
      statusIcon = Icons.trending_down_outlined;
    }
    
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        // Item Header Card
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                statusColor,
                statusColor.withValues(alpha: 0.8),
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
                ),
                child: Icon(
                  Icons.medication_outlined,
                  size: 48,
                  color: statusColor,
                ),
              ),
              const VSpace.md(),
              Text(
                _item!.name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              if (statusText != null) ...[
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
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 16, color: Colors.white),
                      const SizedBox(width: 6),
                      Text(
                        statusText,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        
        const VSpace.lg(),
        
        // Basic Information
        _buildSection(
          'Item Information',
          Icons.info_rounded,
          [
            _buildInfoRow('SKU', _item!.sku, Icons.qr_code_rounded),
            _buildInfoRow('Item Name', _item!.name, Icons.medication_outlined),
            if (_item!.description != null)
              _buildInfoRow('Description', _item!.description!, Icons.description_outlined),
          ],
        ),
        
        const VSpace.lg(),
        
        // Stock Information
        _buildSection(
          'Stock Information',
          Icons.inventory_2_rounded,
          [
            _buildInfoRow(
              'Quantity',
              '${_item!.quantity} ${_item!.unit ?? "units"}',
              Icons.inventory_2_outlined,
            ),
            if (_item!.batchNumber != null)
              _buildInfoRow('Batch Number', _item!.batchNumber!, Icons.numbers_rounded),
            if (_item!.expiryDate != null)
              _buildInfoRow(
                'Expiry Date',
                Utils.formatDate(DateTime.parse(_item!.expiryDate!)),
                Icons.event_outlined,
              ),
            if (_item!.location != null)
              _buildInfoRow('Storage Location', _item!.location!, Icons.location_on_outlined),
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
              color: AppColors.moduleInventory.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppRadius.lg),
                topRight: Radius.circular(AppRadius.lg),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, size: 24, color: AppColors.moduleInventory),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.moduleInventory,
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
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
