import 'package:flutter/material.dart';
import '../core/constants.dart';

/// Responsive layout builder
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  
  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= AppConstants.desktopBreakpoint) {
          return desktop ?? tablet ?? mobile;
        } else if (constraints.maxWidth >= AppConstants.tabletBreakpoint) {
          return tablet ?? mobile;
        } else {
          return mobile;
        }
      },
    );
  }
}

/// Check if screen is mobile
bool isMobile(BuildContext context) {
  return MediaQuery.of(context).size.width < AppConstants.tabletBreakpoint;
}

/// Check if screen is tablet
bool isTablet(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  return width >= AppConstants.tabletBreakpoint && width < AppConstants.desktopBreakpoint;
}

/// Check if screen is desktop
bool isDesktop(BuildContext context) {
  return MediaQuery.of(context).size.width >= AppConstants.desktopBreakpoint;
}

/// Get responsive columns count
int getResponsiveColumns(BuildContext context, {int mobile = 1, int tablet = 2, int desktop = 4}) {
  if (isDesktop(context)) return desktop;
  if (isTablet(context)) return tablet;
  return mobile;
}
