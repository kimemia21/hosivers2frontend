import 'dart:ui';
import 'package:flutter/material.dart';

/// Reusable Alert Dialog with blur background and theme-based styling
/// Automatically shows as bottom sheet on mobile, dialog on larger screens
class BlurAlertDialog {
  /// Show a customizable alert dialog with blur background
  /// On mobile (<600px), shows as full-screen bottom sheet
  /// On larger screens, shows as centered dialog
  static Future<bool?> show({
    required BuildContext context,
    required String title,
    String? message,
    Widget? customBody,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool barrierDismissible = true,
    IconData? icon,
    Color? iconColor,
    bool scrollable = true,
    double? maxHeight,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    if (isMobile) {
      // Show as bottom sheet on mobile
      return showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        isDismissible: barrierDismissible,
        enableDrag: barrierDismissible,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.black26,
        builder: (BuildContext context) {
          return _BlurBottomSheet(
            title: title,
            message: message,
            customBody: customBody,
            confirmText: confirmText,
            cancelText: cancelText,
            onConfirm: onConfirm,
            onCancel: onCancel,
            icon: icon,
            iconColor: iconColor,
            scrollable: scrollable,
          );
        },
      );
    } else {
      // Show as dialog on larger screens
      return showDialog<bool>(
        context: context,
        barrierDismissible: barrierDismissible,
        barrierColor: Colors.black26,
        builder: (BuildContext context) {
          return _BlurAlertDialogWidget(
            title: title,
            message: message,
            customBody: customBody,
            confirmText: confirmText,
            cancelText: cancelText,
            onConfirm: onConfirm,
            onCancel: onCancel,
            icon: icon,
            iconColor: iconColor,
            scrollable: scrollable,
            maxHeight: maxHeight,
          );
        },
      );
    }
  }
}

// Bottom Sheet Widget for Mobile
class _BlurBottomSheet extends StatelessWidget {
  final String title;
  final String? message;
  final Widget? customBody;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final IconData? icon;
  final Color? iconColor;
  final bool scrollable;

  const _BlurBottomSheet({
    required this.title,
    this.message,
    this.customBody,
    this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
    this.icon,
    this.iconColor,
    this.scrollable = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final padding = MediaQuery.of(context).padding;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      child: Container(
        height: screenHeight,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Drag handle
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Row(
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      size: 28,
                      color: iconColor ?? theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(false),
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ],
              ),
            ),

            Divider(
              height: 1,
              color: theme.colorScheme.outline.withOpacity(0.2),
            ),

            // Content
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (customBody != null) {
                    return scrollable
                        ? SingleChildScrollView(
                            padding: const EdgeInsets.all(20),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: 0,
                                maxHeight: constraints.maxHeight,
                              ),
                              child: customBody,
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(20),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: 0,
                                maxHeight: constraints.maxHeight,
                              ),
                              child: customBody,
                            ),
                          );
                  } else if (message != null) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        message!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.8),
                          height: 1.5,
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),

            // Action buttons
            if (confirmText != null ||
                onConfirm != null ||
                cancelText != null ||
                onCancel != null)
              Container(
                padding: EdgeInsets.fromLTRB(20, 16, 20, padding.bottom + 16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  border: Border(
                    top: BorderSide(
                      color: theme.colorScheme.outline.withOpacity(0.2),
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (confirmText != null || onConfirm != null)
                      _buildConfirmButton(context, theme),
                    if (cancelText != null || onCancel != null) ...[
                      const SizedBox(height: 12),
                      _buildCancelButton(context, theme),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmButton(BuildContext context, ThemeData theme) {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: () {
          onConfirm?.call();
          Navigator.of(context).pop(true);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          confirmText ?? 'Confirm',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context, ThemeData theme) {
    return SizedBox(
      height: 52,
      child: OutlinedButton(
        onPressed: () {
          onCancel?.call();
          Navigator.of(context).pop(false);
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: theme.colorScheme.onSurface,
          side: BorderSide(color: theme.colorScheme.outline.withOpacity(0.5)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          cancelText ?? 'Cancel',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

// Dialog Widget for Larger Screens
class _BlurAlertDialogWidget extends StatelessWidget {
  final String title;
  final String? message;
  final Widget? customBody;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final IconData? icon;
  final Color? iconColor;
  final bool scrollable;
  final double? maxHeight;

  const _BlurAlertDialogWidget({
    required this.title,
    this.message,
    this.customBody,
    this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
    this.icon,
    this.iconColor,
    this.scrollable = true,
    this.maxHeight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    // Responsive sizing
    final isSmallScreen = screenWidth < 600;
    final padding = 24.0;

    // Calculate max height (leave space for system UI)
    final calculatedMaxHeight = maxHeight ?? (screenHeight * 0.8);

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.65,
            maxHeight: calculatedMaxHeight,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: theme.colorScheme.outline.withOpacity(0.2),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header section (non-scrollable)
                    if (icon != null || title.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          padding,
                          padding,
                          padding,
                          customBody != null ? 0 : padding,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Icon
                            if (icon != null) ...[
                              Icon(
                                icon,
                                size: 56,
                                color: iconColor ?? theme.colorScheme.primary,
                              ),
                              const SizedBox(height: 16),
                            ],

                            // Title
                            Text(
                              title,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                                fontSize: 24,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                    // Scrollable content area
                    Flexible(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          if (customBody != null) {
                            return scrollable
                                ? SingleChildScrollView(
                                    padding: EdgeInsets.all(padding),
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        minHeight: 0,
                                        maxHeight: constraints.maxHeight,
                                      ),
                                      child: customBody,
                                    ),
                                  )
                                : Padding(
                                    padding: EdgeInsets.all(padding),
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        minHeight: 0,
                                        maxHeight: constraints.maxHeight,
                                      ),
                                      child: customBody,
                                    ),
                                  );
                          } else if (message != null) {
                            return Padding(
                              padding: EdgeInsets.fromLTRB(
                                padding,
                                16,
                                padding,
                                0,
                              ),
                              child: Text(
                                message!,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.8),
                                  fontSize: 16,
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),

                    // Action buttons (non-scrollable)
                    if (confirmText != null ||
                        onConfirm != null ||
                        cancelText != null ||
                        onCancel != null)
                      Padding(
                        padding: EdgeInsets.all(padding),
                        child: Row(
                          children: [
                            if (cancelText != null || onCancel != null) ...[
                              Expanded(
                                child: _buildCancelButton(context, theme),
                              ),
                              const SizedBox(width: 12),
                            ],
                            if (confirmText != null || onConfirm != null)
                              Expanded(
                                child: _buildConfirmButton(context, theme),
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmButton(BuildContext context, ThemeData theme) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: () {
          onConfirm?.call();
          Navigator.of(context).pop(true);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          confirmText ?? 'Confirm',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context, ThemeData theme) {
    return SizedBox(
      height: 48,
      child: OutlinedButton(
        onPressed: () {
          onCancel?.call();
          Navigator.of(context).pop(false);
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: theme.colorScheme.onSurface,
          side: BorderSide(color: theme.colorScheme.outline.withOpacity(0.5)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          cancelText ?? 'Cancel',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
