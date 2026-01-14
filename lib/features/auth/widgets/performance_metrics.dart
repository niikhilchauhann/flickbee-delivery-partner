import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/exports.dart';
import '../../../core/global_widgets/custom_icon_widget.dart';
class PerformanceMetricsWidget extends StatelessWidget {
  const PerformanceMetricsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final metrics = [
      {
        "icon": "local_shipping",
        "label": "Total Deliveries",
        "value": "1,247",
        "color": theme.colorScheme.primary,
      },
      {
        "icon": "star",
        "label": "Customer Rating",
        "value": "4.8/5.0",
        "color": AppTheme.warningLight,
      },
      {
        "icon": "schedule",
        "label": "On-Time Rate",
        "value": "96%",
        "color": AppTheme.successLight,
      },
      {
        "icon": "attach_money",
        "label": "Total Earnings",
        "value": "\$12,450",
        "color": AppTheme.successLight,
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
            "Performance Metrics",
            style: theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 2.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 3.w,
              mainAxisSpacing: 2.h,
              childAspectRatio: 1.5,
            ),
            itemCount: metrics.length,
            itemBuilder: (context, index) {
              final m = metrics[index];
              return Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(2.w),
                  border: Border.all(
                    color: theme.colorScheme.outline
                        .withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: m["icon"] as String,
                      color: m["color"] as Color,
                      size: 8.w,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      m["value"] as String,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: m["color"]  as Color,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      m["label"] as String,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
