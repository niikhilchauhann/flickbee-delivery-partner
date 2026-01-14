import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../core/global_widgets/custom_icon_widget.dart';

class SupportSectionWidget extends StatelessWidget {
  const SupportSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final options = [
      {
        "icon": "help_center",
        "title": "Help Center",
        "subtitle": "Browse FAQs and guides",
      },
      {
        "icon": "support_agent",
        "title": "Contact Support",
        "subtitle": "Get help from our team",
      },
      {
        "icon": "feedback",
        "title": "Send Feedback",
        "subtitle": "Share your suggestions",
      },
    ];

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
            "Support",
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: options.length,
            separatorBuilder: (_, __) => Divider(height: 3.h),
            itemBuilder: (context, index) {
              final o = options[index];
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
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.1,
                          ),
                          borderRadius: BorderRadius.circular(2.w),
                        ),
                        child: Center(
                          child: CustomIconWidget(
                            iconName: o["icon"] as String,
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
                              o["title"] as String,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              o["subtitle"] as String,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
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
          Divider(height: 3.h),
          Center(
            child: Text(
              "App Version 2.5.1",
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
