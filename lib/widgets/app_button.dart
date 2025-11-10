import 'package:flutter/material.dart';
import '../theme/spacing.dart';

/// Custom app button widget that uses theme
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final IconData? icon;
  final double? width;
  final double? height;
  final bool isFullWidth;
  
  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.backgroundColor,
    this.foregroundColor,
    this.icon,
    this.width,
    this.height,
    this.isFullWidth = false,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveWidth = isFullWidth ? double.infinity : width;
    
    if (isOutlined) {
      return SizedBox(
        width: effectiveWidth,
        height: height,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: backgroundColor != null || foregroundColor != null
              ? OutlinedButton.styleFrom(
                  side: BorderSide(color: foregroundColor ?? theme.colorScheme.primary),
                  foregroundColor: foregroundColor ?? theme.colorScheme.primary,
                )
              : null,
          child: _buildContent(context),
        ),
      );
    }
    
    return SizedBox(
      width: effectiveWidth,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: backgroundColor != null || foregroundColor != null
            ? ElevatedButton.styleFrom(
                backgroundColor: backgroundColor,
                foregroundColor: foregroundColor,
              )
            : null,
        child: _buildContent(context),
      ),
    );
  }
  
  Widget _buildContent(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            foregroundColor ?? Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      );
    }
    
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const HSpace.sm(),
          Text(text),
        ],
      );
    }
    
    return Text(text);
  }
}
