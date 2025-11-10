import 'package:flutter/material.dart';
import 'dart:ui';
import '../theme/spacing.dart';
import '../theme/radius.dart';
import '../theme/shadows.dart';

/// Modern dashboard statistics card with hover effect and gradient
/// Inspired by modern healthcare dashboards (Epic, Cerner, Athenahealth)
class DashboardCard extends StatefulWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  final String? subtitle;
  final Widget? trailing;
  
  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.onTap,
    this.subtitle,
    this.trailing,
  });
  
  @override
  State<DashboardCard> createState() => _DashboardCardState();
}

class _DashboardCardState extends State<DashboardCard> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _animationController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _animationController.reverse();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: AppRadius.card,
            border: Border.all(
              color: _isHovered 
                ? widget.color.withValues(alpha: 0.3)
                : theme.colorScheme.outline.withValues(alpha: 0.2),
              width: _isHovered ? 1.5 : 0.5,
            ),
            boxShadow: _isHovered ? AppShadows.shadowMD : null,
            gradient: _isHovered
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      widget.color.withValues(alpha: isDark ? 0.08 : 0.03),
                      theme.colorScheme.surface,
                    ],
                  )
                : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTap,
              borderRadius: AppRadius.card,
              splashColor: widget.color.withValues(alpha: 0.1),
              highlightColor: widget.color.withValues(alpha: 0.05),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Adjust layout based on card width
                    final isCompact = constraints.maxWidth < 200;
                    final iconSize = isCompact ? 24.0 : 28.0;
                    final iconPadding = isCompact ? AppSpacing.xs + 2 : AppSpacing.sm + 2;
                    
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Modern icon container with gradient
                            Container(
                              padding: EdgeInsets.all(iconPadding),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    widget.color.withValues(alpha: isDark ? 0.3 : 0.15),
                                    widget.color.withValues(alpha: isDark ? 0.2 : 0.08),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(AppRadius.md),
                                border: Border.all(
                                  color: widget.color.withValues(alpha: 0.2),
                                  width: 0.5,
                                ),
                              ),
                              child: Icon(
                                widget.icon,
                                color: widget.color,
                                size: iconSize,
                              ),
                            ),
                            if (widget.trailing != null) widget.trailing!,
                          ],
                        ),
                        SizedBox(height: isCompact ? AppSpacing.xs : AppSpacing.sm),
                        Flexible(
                          child: Text(
                            widget.title,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                              fontWeight: FontWeight.w500,
                              fontSize: isCompact ? 11 : 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(height: isCompact ? 2 : AppSpacing.xs),
                        Flexible(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    widget.value,
                                    style: theme.textTheme.headlineMedium?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: theme.colorScheme.onSurface,
                                      letterSpacing: -0.5,
                                      fontSize: isCompact ? 24 : 28,
                                    ),
                                  ),
                                ),
                              ),
                              if (widget.subtitle != null) ...[
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: isCompact ? 4 : 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: widget.color.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(AppRadius.xs),
                                      border: Border.all(
                                        color: widget.color.withValues(alpha: 0.3),
                                        width: 0.5,
                                      ),
                                    ),
                                    child: Text(
                                      widget.subtitle!,
                                      style: theme.textTheme.labelSmall?.copyWith(
                                        color: widget.color,
                                        fontWeight: FontWeight.w700,
                                        fontSize: isCompact ? 8 : 9,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
