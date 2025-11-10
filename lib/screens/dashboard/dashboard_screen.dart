import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../widgets/dashboard_card.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_view.dart';
import '../../state/auth_provider.dart';
import '../../state/dashboard_provider.dart';
import '../patients/patients_screen.dart';
import '../doctors/doctors_screen.dart';
import '../inventory/inventory_screen.dart';
import '../prescriptions/prescriptions_screen.dart';

/// Main dashboard screen
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    final statsAsync = ref.watch(dashboardStatsProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hospital Management Dashboard',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              ref.invalidate(dashboardStatsProvider);
            },
            tooltip: 'Refresh',
            style: IconButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => _handleLogout(context, ref),
            tooltip: 'Logout',
            style: IconButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: userAsync.when(
        data: (user) {
          if (user == null) {
            return const Center(child: Text('Not authenticated'));
          }
          
          final isMobile = MediaQuery.of(context).size.width < 600;
          
          return SingleChildScrollView(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1400),
                padding: isMobile 
                  ? const EdgeInsets.all(AppSpacing.md)
                  : AppSpacing.screenPaddingResponsive(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome message - Modern header with description
                    Text(
                      'Welcome back, ${user.name}! 👋',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                        fontSize: isMobile ? 24 : null,
                      ),
                    ),
                    const VSpace.xs(),
                    Text(
                      isMobile 
                        ? 'Your hospital management overview'
                        : 'Here\'s an overview of your hospital management system',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                        fontSize: isMobile ? 14 : null,
                      ),
                    ),
                    const VSpace.sm(),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm + 2,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.2),
                              width: 0.5,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.badge_rounded,
                                size: 16,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                user.role.toUpperCase(),
                                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.verified_rounded,
                          size: 20,
                          color: AppColors.success,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Authorized Access',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.success,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const VSpace.xl(),
                    
                    // Statistics section with header
                    Row(
                      children: [
                        Icon(
                          Icons.analytics_rounded,
                          size: isMobile ? 20 : 24,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'System Overview',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.3,
                              fontSize: isMobile ? 18 : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (!isMobile) ...[
                      const VSpace.xs(),
                      Text(
                        'Real-time statistics and key metrics for hospital operations',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                    SizedBox(height: isMobile ? AppSpacing.sm : AppSpacing.lg),
                    
                    // Statistics
                    statsAsync.when(
                      data: (stats) => _buildStatsGrid(context, stats),
                      loading: () => const LoadingIndicator(message: 'Loading system statistics...'),
                      error: (error, stack) => ErrorView(
                        message: error.toString(),
                        onRetry: () => ref.invalidate(dashboardStatsProvider),
                      ),
                    ),
                    
                    SizedBox(height: isMobile ? AppSpacing.lg : AppSpacing.xl),
                    
                    // Quick access section
                    Row(
                      children: [
                        Icon(
                          Icons.speed_rounded,
                          size: isMobile ? 20 : 24,
                          color: AppColors.secondary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Quick Actions',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.3,
                              fontSize: isMobile ? 18 : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (!isMobile) ...[
                      const VSpace.xs(),
                      Text(
                        'Frequently used features for efficient workflow management',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                    SizedBox(height: isMobile ? AppSpacing.sm : AppSpacing.lg),
                    _buildQuickActions(context),
                    
                    const VSpace.xxl(),
                  ],
                ),
              ),
            ),
          );
        },
        loading: () => const LoadingIndicator(),
        error: (error, stack) => ErrorView(message: error.toString()),
      ),
    );
  }
  
  Widget _buildStatsGrid(BuildContext context, stats) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isTablet = MediaQuery.of(context).size.width >= 600 && MediaQuery.of(context).size.width < 900;
    final columns = isMobile ? 2 : isTablet ? 3 : 4;
    
    final cards = [
      DashboardCard(
        title: 'Total Patients',
        value: stats.totalPatients.toString(),
        icon: Icons.people_outline,
        color: AppColors.modulePatients,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PatientsScreen()),
        ),
      ),
      DashboardCard(
        title: 'Total Doctors',
        value: stats.totalDoctors.toString(),
        icon: Icons.medical_services_outlined,
        color: AppColors.moduleDoctors,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const DoctorsScreen()),
        ),
      ),
      DashboardCard(
        title: 'Inventory Items',
        value: stats.totalInventoryItems.toString(),
        icon: Icons.inventory_2_outlined,
        color: AppColors.moduleInventory,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const InventoryScreen()),
        ),
      ),
      DashboardCard(
        title: 'Prescriptions',
        value: stats.totalPrescriptions.toString(),
        icon: Icons.description_outlined,
        color: AppColors.modulePrescriptions,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PrescriptionsScreen()),
        ),
      ),
      DashboardCard(
        title: 'Low Stock Items',
        value: stats.lowStockItems.toString(),
        icon: Icons.warning_amber_outlined,
        color: AppColors.warning,
        subtitle: 'Alert',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const InventoryScreen()),
        ),
      ),
      DashboardCard(
        title: 'Expiring Soon',
        value: stats.expiringSoonItems.toString(),
        icon: Icons.event_busy_outlined,
        color: AppColors.error,
        subtitle: 'Critical',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const InventoryScreen()),
        ),
      ),
    ];
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: isMobile ? AppSpacing.sm : AppSpacing.gridSpacing,
        mainAxisSpacing: isMobile ? AppSpacing.sm : AppSpacing.gridSpacing,
        childAspectRatio: isMobile ? 1.1 : isTablet ? 1.4 : 1.6,
      ),
      itemCount: cards.length,
      itemBuilder: (context, index) => cards[index],
    );
  }
  
  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      _buildQuickActionCard(
        context,
        'Register Patient',
        'Add new patient to the system',
        Icons.person_add_alt_rounded,
        AppColors.modulePatients,
        () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PatientsScreen()),
        ),
      ),
      _buildQuickActionCard(
        context,
        'New Prescription',
        'Create medical prescription',
        Icons.note_add_rounded,
        AppColors.modulePrescriptions,
        () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PrescriptionsScreen()),
        ),
      ),
      _buildQuickActionCard(
        context,
        'Manage Inventory',
        'Update stock and supplies',
        Icons.add_box_rounded,
        AppColors.moduleInventory,
        () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const InventoryScreen()),
        ),
      ),
      _buildQuickActionCard(
        context,
        'View Doctors',
        'Medical staff directory',
        Icons.medical_services_rounded,
        AppColors.moduleDoctors,
        () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const DoctorsScreen()),
        ),
      ),
    ];
    
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isTablet = MediaQuery.of(context).size.width >= 600 && MediaQuery.of(context).size.width < 900;
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 1 : isTablet ? 2 : 4,
        crossAxisSpacing: isMobile ? 0 : AppSpacing.md,
        mainAxisSpacing: isMobile ? AppSpacing.sm : AppSpacing.md,
        childAspectRatio: isMobile ? 3.5 : isTablet ? 2.5 : 2.5,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) => actions[index],
    );
  }
  
  Widget _buildQuickActionCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        // borderRadius: AppRadius.card,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            // borderRadius: AppRadius.card,
            border: Border.all(
              color: color.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm + 2),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      color.withValues(alpha: 0.15),
                      color.withValues(alpha: 0.08),
                    ],
                  ),
                  // borderRadius: BorderRadius.circular(AppRadius.sm),
                  border: Border.all(
                    color: color.withValues(alpha: 0.2),
                    width: 0.5,
                  ),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const HSpace.md(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const VSpace.xs(),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: color.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      await ref.read(currentUserProvider.notifier).logout();
      if (context.mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    }
  }
}
