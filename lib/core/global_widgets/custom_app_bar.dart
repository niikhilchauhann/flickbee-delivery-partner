import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Custom app bar variants for delivery driver application
/// Optimized for professional efficiency and clear visual hierarchy
enum CustomAppBarVariant {
  /// Standard app bar with title and optional actions
  standard,

  /// App bar with back button and title
  withBack,

  /// App bar with status indicator (online/offline)
  withStatus,

  /// App bar with earnings display
  withEarnings,

  /// Minimal app bar for full-screen experiences (map view)
  minimal,
}

/// Custom app bar component for delivery driver application
/// Provides consistent navigation and context across screens
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// App bar variant to display
  final CustomAppBarVariant variant;

  /// Title text to display
  final String? title;

  /// Optional subtitle for additional context
  final String? subtitle;

  /// Leading widget (overrides default back button)
  final Widget? leading;

  /// Action widgets to display on the right
  final List<Widget>? actions;

  /// Whether to show back button (for withBack variant)
  final bool showBackButton;

  /// Online status (for withStatus variant)
  final bool? isOnline;

  /// Earnings amount (for withEarnings variant)
  final String? earnings;

  /// Background color override
  final Color? backgroundColor;

  /// Elevation override
  final double? elevation;

  /// Whether to center the title
  final bool centerTitle;

  const CustomAppBar({
    super.key,
    this.variant = CustomAppBarVariant.standard,
    this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.showBackButton = true,
    this.isOnline,
    this.earnings,
    this.backgroundColor,
    this.elevation,
    this.centerTitle = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      backgroundColor: backgroundColor ?? theme.appBarTheme.backgroundColor,
      foregroundColor: theme.appBarTheme.foregroundColor,
      elevation: elevation ?? theme.appBarTheme.elevation,
      centerTitle: centerTitle,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: theme.brightness == Brightness.light
            ? Brightness.dark
            : Brightness.light,
      ),
      leading: _buildLeading(context),
      title: _buildTitle(context),
      actions: _buildActions(context),
    );
  }

  /// Build leading widget based on variant
  Widget? _buildLeading(BuildContext context) {
    if (leading != null) return leading;

    switch (variant) {
      case CustomAppBarVariant.withBack:
        if (showBackButton) {
          return IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: 'Back',
          );
        }
        return null;

      case CustomAppBarVariant.minimal:
        return null;

      default:
        return null;
    }
  }

  /// Build title widget based on variant
  Widget? _buildTitle(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (variant) {
      case CustomAppBarVariant.standard:
      case CustomAppBarVariant.withBack:
        if (title == null) return null;

        if (subtitle != null) {
          return Column(
            crossAxisAlignment: centerTitle
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title!, style: theme.appBarTheme.titleTextStyle),
              const SizedBox(height: 2),
              Text(
                subtitle!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          );
        }

        return Text(title!);

      case CustomAppBarVariant.withStatus:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null) ...[Text(title!), const SizedBox(width: 12)],
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: (isOnline ?? false)
                    ? const Color(0xFF059669).withValues(alpha: 0.1)
                    : const Color(0xFF64748B).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: (isOnline ?? false)
                          ? const Color(0xFF059669)
                          : const Color(0xFF64748B),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    (isOnline ?? false) ? 'Online' : 'Offline',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: (isOnline ?? false)
                          ? const Color(0xFF059669)
                          : const Color(0xFF64748B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );

      case CustomAppBarVariant.withEarnings:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null) ...[Text(title!), const SizedBox(width: 16)],
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF059669).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.account_balance_wallet,
                    size: 16,
                    color: Color(0xFF059669),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    earnings ?? '\$0.00',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: const Color(0xFF059669),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );

      case CustomAppBarVariant.minimal:
        return null;
    }
  }

  /// Build actions based on variant
  List<Widget>? _buildActions(BuildContext context) {
    if (actions != null) return actions;

    switch (variant) {
      case CustomAppBarVariant.minimal:
        return null;

      default:
        return null;
    }
  }
}
