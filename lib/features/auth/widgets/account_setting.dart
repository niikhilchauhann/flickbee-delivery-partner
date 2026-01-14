import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../core/global_widgets/custom_icon_widget.dart';
import '../domain/settings_model.dart';
class AccountSettingsWidget extends StatelessWidget {
  const AccountSettingsWidget({super.key});

  static final items = [
    AccountSettingItem(
      icon: 'person',
      title: 'Personal Information',
      subtitle: 'Update your profile details',
    ),
    AccountSettingItem(
      icon: 'directions_car',
      title: 'Vehicle Details',
      subtitle: 'Honda Civic 2022 - ABC 1234',
    ),
    AccountSettingItem(
      icon: 'account_balance',
      title: 'Payment Method',
      subtitle: 'Bank Account •••• 5678',
    ),
    AccountSettingItem(
      icon: 'notifications',
      title: 'Notification Preferences',
      subtitle: 'Manage alerts and sounds',
    ),
    AccountSettingItem(
      icon: 'contact_phone',
      title: 'Emergency Contact',
      subtitle: 'John Rodriguez - (555) 123-4567',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(3.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Account Settings',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, __) => Divider(height: 3.h),
            itemBuilder: (context, index) {
              final item = items[index];
              return InkWell(
                borderRadius: BorderRadius.circular(2.w),
                onTap: () {},
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 1.h),
                  child: Row(
                    children: [
                      Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(2.w),
                        ),
                        child: Center(
                          child: CustomIconWidget(
                            iconName: item.icon,
                            color: theme.colorScheme.primary,
                            size: 6.w,
                          ),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              item.subtitle,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color:
                                    theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      CustomIconWidget(
                        iconName: 'chevron_right',
                        color: theme.colorScheme.onSurfaceVariant,
                        size: 6.w,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
