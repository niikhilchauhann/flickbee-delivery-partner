import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/exports.dart';
import '../../../core/global_widgets/custom_icon_widget.dart';
import '../domain/settings_model.dart';

class DocumentManagementWidget extends StatelessWidget {
  const DocumentManagementWidget({super.key});

  static final docs = [
    DocumentItem(
      icon: 'badge',
      title: 'Driver License',
      status: 'Verified',
      expiry: 'Expires: 12/15/2026',
      isVerified: true,
    ),
    DocumentItem(
      icon: 'description',
      title: 'Vehicle Insurance',
      status: 'Verified',
      expiry: 'Expires: 06/30/2026',
      isVerified: true,
    ),
    DocumentItem(
      icon: 'verified_user',
      title: 'Background Check',
      status: 'Verified',
      expiry: 'Valid until: 01/20/2027',
      isVerified: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(3.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Document Management',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          ...docs.map((doc) {
            return Padding(
              padding: EdgeInsets.only(bottom: 2.h),
              child: Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(2.w),
                  border: Border.all(
                    color: doc.isVerified
                        ? AppTheme.successLight.withValues(alpha: 0.3)
                        : theme.colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 12.w,
                      height: 12.w,
                      decoration: BoxDecoration(
                        color: doc.isVerified
                            ? AppTheme.successLight.withValues(alpha: 0.1)
                            : theme.colorScheme.outline.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(2.w),
                      ),
                      child: Center(
                        child: CustomIconWidget(
                          iconName: doc.icon,
                          color: doc.isVerified
                              ? AppTheme.successLight
                              : theme.colorScheme.onSurfaceVariant,
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
                            doc.title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            doc.expiry,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: CustomIconWidget(
                        iconName: 'upload_file',
                        color: theme.colorScheme.primary,
                        size: 6.w,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
