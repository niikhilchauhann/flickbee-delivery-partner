import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/global_widgets/custom_icon_widget.dart';

/// Delivery metrics displaying completion time, distance, and efficiency
class DeliveryMetricsWidget extends StatelessWidget {
  final Map<String, dynamic> metricsData;

  const DeliveryMetricsWidget({super.key, required this.metricsData, required metrics});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Delivery Performance',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  context,
                  'timer',
                  'Completion Time',
                  metricsData["completionTime"] as String,
                  theme.colorScheme.primary,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildMetricCard(
                  context,
                  'route',
                  'Distance',
                  metricsData["distance"] as String,
                  const Color(0xFF3B82F6),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: _getEfficiencyColor(
                metricsData["efficiency"] as double,
              ).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'speed',
                          color: _getEfficiencyColor(
                            metricsData["efficiency"] as double,
                          ),
                          size: 5.w,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Efficiency Rating',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${metricsData["efficiency"]}%',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: _getEfficiencyColor(
                          metricsData["efficiency"] as double,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: (metricsData["efficiency"] as double) / 100,
                    minHeight: 8,
                    backgroundColor: theme.colorScheme.outline.withValues(
                      alpha: 0.2,
                    ),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getEfficiencyColor(metricsData["efficiency"] as double),
                    ),
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  _getEfficiencyMessage(metricsData["efficiency"] as double),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
    BuildContext context,
    String iconName,
    String label,
    String value,
    Color color,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          CustomIconWidget(iconName: iconName, color: color, size: 6.w),
          SizedBox(height: 1.h),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getEfficiencyColor(double efficiency) {
    if (efficiency >= 90) {
      return const Color(0xFF059669);
    } else if (efficiency >= 70) {
      return const Color(0xFFFBBF24);
    } else {
      return const Color(0xFFDC2626);
    }
  }

  String _getEfficiencyMessage(double efficiency) {
    if (efficiency >= 90) {
      return 'Excellent! You completed this delivery faster than estimated.';
    } else if (efficiency >= 70) {
      return 'Good job! You completed this delivery on time.';
    } else {
      return 'This delivery took longer than estimated. Keep improving!';
    }
  }
}
