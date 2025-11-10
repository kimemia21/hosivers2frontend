import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hospital_management/widgets/appAlert.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/radius.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_view.dart';
import '../../widgets/empty_view.dart';
import '../../state/inventory_provider.dart';
import '../../core/utils.dart';
import 'inventory_form_screen.dart';
import 'inventory_detail_screen.dart';

/// Modern Inventory Management Screen
/// Displays medical supplies with stock levels, expiry dates, and alert indicators
class InventoryScreen extends ConsumerStatefulWidget {
  const InventoryScreen({super.key});
  
  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen> {
  final _searchController = TextEditingController();
  String? _searchQuery;
  bool _showLowStock = false;
  bool _showExpiringSoon = false;
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final filter = InventoryFilter(
      page: 1,
      limit: 50,
      search: _searchQuery,
      lowStock: _showLowStock ? true : null,
      expiringSoon: _showExpiringSoon ? true : null,
    );
    final inventoryAsync = ref.watch(inventoryProvider(filter));
    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          'Medical Inventory',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              ref.read(inventoryProvider(filter).notifier).refresh();
            },
            tooltip: 'Refresh inventory',
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
          // Modern search and filter section
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
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by item name, SKU, or category...',
                    hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
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
                    fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                  onSubmitted: (value) {
                    setState(() => _searchQuery = value.isEmpty ? null : value);
                  },
                ),
                const VSpace.sm(),
                
                // Filter chips with icons
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.xs,
                  children: [
                    FilterChip(
                      avatar: Icon(
                        Icons.inventory_2_outlined,
                        size: 18,
                        color: _showLowStock ? AppColors.warning : null,
                      ),
                      label: const Text('Low Stock Alert'),
                      selected: _showLowStock,
                      selectedColor: AppColors.warning.withValues(alpha: 0.15),
                      onSelected: (value) {
                        setState(() => _showLowStock = value);
                      },
                    ),
                    FilterChip(
                      avatar: Icon(
                        Icons.event_busy_outlined,
                        size: 18,
                        color: _showExpiringSoon ? AppColors.error : null,
                      ),
                      label: const Text('Expiring Soon'),
                      selected: _showExpiringSoon,
                      selectedColor: AppColors.error.withValues(alpha: 0.15),
                      onSelected: (value) {
                        setState(() => _showExpiringSoon = value);
                      },
                    ),
                  ],
                ),
                const VSpace.sm(),
                
                // Item count
                inventoryAsync.when(
                  data: (data) {
                    int alertCount = 0;
                    for (var item in data.inventory) {
                      if (item.isLowStock || item.isExpiringSoon || item.isExpired) {
                        alertCount++;
                      }
                    }
                    return Row(
                      children: [
                        Text(
                          '${data.inventory.length} item${data.inventory.length != 1 ? 's' : ''} in inventory',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                        if (alertCount > 0) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.warning.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(AppRadius.sm),
                              border: Border.all(
                                color: AppColors.warning.withValues(alpha: 0.3),
                                width: 0.5,
                              ),
                            ),
                            child: Text(
                              '$alertCount alert${alertCount != 1 ? 's' : ''}',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: AppColors.warning,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                  loading: () => Text(
                    'Loading inventory...',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ],
            ),
          ),
          
          // Modern inventory list with detailed cards
          Expanded(
            child: inventoryAsync.when(
              data: (data) {
                if (data.inventory.isEmpty) {
                  return EmptyView(
                    message: _searchQuery != null || _showLowStock || _showExpiringSoon
                      ? 'No items match your filters.\nTry adjusting your search or filter criteria.'
                      : 'No inventory items found.\nStart by adding medical supplies to your inventory.',
                    icon: Icons.inventory_2_outlined,
                  );
                }
                
                return ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: data.inventory.length,
                  itemBuilder: (context, index) {
                    final item = data.inventory[index];
                    final isLowStock = item.isLowStock;
                    final isExpiringSoon = item.isExpiringSoon;
                    final isExpired = item.isExpired;
                    
                    // Determine status color and icon
                    Color statusColor = AppColors.inventoryCard;
                    IconData statusIcon = Icons.check_circle_outline;
                    String? statusText;
                    
                    if (isExpired) {
                      statusColor = AppColors.error;
                      statusIcon = Icons.dangerous_outlined;
                      statusText = 'EXPIRED';
                    } else if (isExpiringSoon) {
                      statusColor = AppColors.warning;
                      statusIcon = Icons.warning_amber_outlined;
                      statusText = 'EXPIRING SOON';
                    } else if (isLowStock) {
                      statusColor = AppColors.warning;
                      statusIcon = Icons.trending_down_outlined;
                      statusText = 'LOW STOCK';
                    }
                    
                    return Container(
                      margin: const EdgeInsets.only(bottom: AppSpacing.md),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: AppRadius.card,
                        border: Border.all(
                          color: statusText != null 
                            ? statusColor.withValues(alpha: 0.3)
                            : Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                          width: statusText != null ? 1.5 : 0.5,
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () async {
                            // Navigate to inventory item details
                            final result = await BlurAlertDialog.show(context: context, title:item.name ,message:'View or edit item details',customBody: InventoryDetailScreen(itemId: item.id),);
                         
                            
                            // Refresh list if item was updated or deleted
                            if (result == true) {
                              ref.read(inventoryProvider(filter).notifier).refresh();
                            }
                          },
                          borderRadius: AppRadius.card,
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            child: Row(
                              children: [
                                // Icon with status color
                                Container(
                                  width: 56,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        statusColor,
                                        statusColor.withValues(alpha: 0.7),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(AppRadius.md),
                                    border: Border.all(
                                      color: statusColor.withValues(alpha: 0.3),
                                      width: 2,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.medication_outlined,
                                    color: AppColors.white,
                                    size: 28,
                                  ),
                                ),
                                const HSpace.md(),
                                
                                // Item information
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              item.name,
                                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                fontWeight: FontWeight.w700,
                                                letterSpacing: -0.2,
                                              ),
                                            ),
                                          ),
                                          if (statusText != null) ...[
                                            const HSpace.sm(),
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: AppSpacing.sm,
                                                vertical: 2,
                                              ),
                                              decoration: BoxDecoration(
                                                color: statusColor.withValues(alpha: 0.15),
                                                borderRadius: BorderRadius.circular(AppRadius.sm),
                                                border: Border.all(
                                                  color: statusColor.withValues(alpha: 0.3),
                                                  width: 0.5,
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    statusIcon,
                                                    size: 12,
                                                    color: statusColor,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    statusText,
                                                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                                      color: statusColor,
                                                      fontWeight: FontWeight.w700,
                                                      letterSpacing: 0.3,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                      const VSpace.xs(),
                                      
                                      // SKU
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.qr_code_rounded,
                                            size: 14,
                                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            'SKU: ${item.sku}',
                                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                                              fontFamily: 'monospace',
                                            ),
                                          ),
                                        ],
                                      ),
                                      const VSpace.xs(),
                                      
                                      // Quantity
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.inventory_2_outlined,
                                            size: 14,
                                            color: isLowStock 
                                              ? AppColors.warning
                                              : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            'Stock: ${item.quantity} ${item.unit ?? "units"}',
                                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                              color: isLowStock 
                                                ? AppColors.warning
                                                : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                                              fontWeight: isLowStock ? FontWeight.w600 : FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                      
                                      // Expiry date
                                      if (item.expiryDate != null) ...[
                                        const VSpace.xs(),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.event_outlined,
                                              size: 14,
                                              color: isExpired || isExpiringSoon
                                                ? statusColor
                                                : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              'Expires: ${Utils.formatDate(DateTime.parse(item.expiryDate!))}',
                                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                color: isExpired || isExpiringSoon
                                                  ? statusColor
                                                  : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                                                fontWeight: isExpired || isExpiringSoon 
                                                  ? FontWeight.w600 
                                                  : FontWeight.normal,
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
              loading: () => const LoadingIndicator(message: 'Loading medical inventory...'),
              error: (error, stack) => ErrorView(
                message: error.toString(),
                onRetry: () => ref.read(inventoryProvider(filter).notifier).refresh(),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // Navigate to create inventory screen
          final result = await  BlurAlertDialog.show(context: context, title:"Create Inventory" ,message:'View or edit item details',customBody:InventoryFormScreen(),);
          
          
          
          // Refresh list if item was created
          if (result == true) {
            ref.read(inventoryProvider(filter).notifier).refresh();
          }
        },
        icon: const Icon(Icons.add_box_rounded),
        label: const Text('Add Item'),
        tooltip: 'Add new inventory item',
      ),
    );
  }
}
