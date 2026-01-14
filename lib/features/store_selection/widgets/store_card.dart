import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/exports.dart';
import '../../../core/global_widgets/custom_icon_widget.dart';
import '../../order_details/order_pickup_model.dart';

class StoreCardWidget extends StatelessWidget {
  final StoreModel store;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onSelect;

  const StoreCardWidget({
    super.key,
    required this.store,
    required this.isSelected,
    required this.onTap,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: isSelected ? 4 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isSelected
            ? BorderSide(color: theme.colorScheme.primary, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(3.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// STORE IMAGE + BASIC INFO
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CustomImageWidget(
                      imageUrl: store.imageUrl,
                      width: 20.w,
                      height: 20.w,
                      fit: BoxFit.cover,
                      semanticLabel: store.semanticLabel,
                    ),
                  ),
                  SizedBox(width: 3.w),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                store.name,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (store.recentlySelected)
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 2.w,
                                  vertical: 0.5.h,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'Recent',
                                  style:
                                      theme.textTheme.labelSmall?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 0.5.h),
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'location_on',
                              color:
                                  theme.colorScheme.onSurfaceVariant,
                              size: 14,
                            ),
                            SizedBox(width: 1.w),
                            Expanded(
                              child: Text(
                                store.address,
                                style:
                                    theme.textTheme.bodySmall?.copyWith(
                                  color: theme
                                      .colorScheme.onSurfaceVariant,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 0.5.h),
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'access_time',
                              color:
                                  theme.colorScheme.onSurfaceVariant,
                              size: 14,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              store.operatingHours,
                              style:
                                  theme.textTheme.bodySmall?.copyWith(
                                color: theme
                                    .colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 2.h),

              /// METRICS ROW
              Row(
                children: [
                  Expanded(
                    child: _MetricTile(
                      icon: 'directions_car',
                      color: theme.colorScheme.primary,
                      value:
                          '${store.distance.toStringAsFixed(1)} mi',
                      label: 'Distance',
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: _MetricTile(
                      icon: 'shopping_bag',
                      color: theme.colorScheme.tertiary,
                      value: '${store.currentOrders}',
                      label: 'Orders',
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: _MetricTile(
                      icon: 'attach_money',
                      color: AppTheme.successLight,
                      value: store.estimatedEarnings,
                      label: 'Est. Earnings',
                      centerText: true,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 2.h),

              /// SELECT BUTTON
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onSelect,
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(double.infinity, 6.h),
                    side: BorderSide(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outline,
                      width: isSelected ? 2 : 1,
                    ),
                    backgroundColor: isSelected
                        ? theme.colorScheme.primary
                            .withValues(alpha: 0.1)
                        : Colors.transparent,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isSelected)
                        Padding(
                          padding: EdgeInsets.only(right: 2.w),
                          child: CustomIconWidget(
                            iconName: 'check_circle',
                            color: theme.colorScheme.primary,
                            size: 20,
                          ),
                        ),
                      Text(
                        isSelected ? 'Selected' : 'Select Store',
                        style: TextStyle(
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class _MetricTile extends StatelessWidget {
  final String icon;
  final Color color;
  final String value;
  final String label;
  final bool centerText;

  const _MetricTile({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
    this.centerText = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          CustomIconWidget(iconName: icon, color: color, size: 20),
          SizedBox(height: 0.5.h),
          Text(
            value,
            textAlign: centerText ? TextAlign.center : TextAlign.start,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
