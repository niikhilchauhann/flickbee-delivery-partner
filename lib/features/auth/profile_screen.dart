import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/exports.dart';
import '../../core/global_widgets/custom_icon_widget.dart';
import 'widgets/account_setting.dart';
import 'widgets/app_settings.dart';
import 'widgets/availability_screen.dart';
import 'widgets/document_management.dart';
import 'widgets/performance_metrics.dart';
import 'widgets/profile_header.dart';
import 'widgets/support_section.dart';

class ProfileAndAvailabilityScreen extends StatelessWidget {
  ProfileAndAvailabilityScreen({super.key});

  // bool _isOnline = true;
  final ValueNotifier<bool> _isOnline = ValueNotifier(true);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Custom AppBar
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Profile & Settings",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  ValueListenableBuilder(
                    valueListenable: _isOnline,
                    builder: (context, value, child) => Row(
                      children: [
                        Text(
                          value ? "Online" : "Offline",
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: value
                                ? AppTheme.successLight
                                : theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Switch(
                          value: _isOnline.value,
                          onChanged: (val) {
                            _isOnline.value = val;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  value
                                      ? "You are now online and can receive orders"
                                      : "You are now offline",
                                ),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Column(
              children: [
                // Profile Header
                ProfileHeaderWidget(),
                SizedBox(height: 3.h),

                // Availability Section
                AvailabilitySectionWidget(),
                SizedBox(height: 3.h),

                // Performance Metrics
                PerformanceMetricsWidget(),
                SizedBox(height: 3.h),

                // Account Settings
                AccountSettingsWidget(),
                SizedBox(height: 3.h),

                // Document Management
                DocumentManagementWidget(),
                SizedBox(height: 3.h),

                // App Settings
                AppSettingsWidget(),
                SizedBox(height: 3.h),

                // Support Section
                SupportSectionWidget(),
                SizedBox(height: 3.h),

                // Logout Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _showLogoutDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.errorLight,
                      foregroundColor: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'logout',
                          color: Colors.white,
                          size: 5.w,
                        ),
                        SizedBox(width: 2.w),
                        Text("Logout"),
                      ],
                    ),
                  ).px(16),
                ),
                SizedBox(height: 2.h),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Logout",
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          "Are you sure you want to logout? You will stop receiving delivery orders.",
          style: theme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(
                context,
                rootNavigator: true,
              ).pushNamedAndRemoveUntil('/login-screen', (route) => false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorLight,
              foregroundColor: Colors.white,
            ),
            child: Text("Logout"),
          ),
        ],
      ),
    );
  }
}
