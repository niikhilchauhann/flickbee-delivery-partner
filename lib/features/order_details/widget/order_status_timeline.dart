import 'package:flutter/material.dart';

import '../../../core/global_widgets/custom_icon_widget.dart';

/// Order status timeline widget
/// Shows visual progression of order status
class OrderStatusTimelineWidget extends StatelessWidget {
  final String currentStatus;

  const OrderStatusTimelineWidget({super.key, required this.currentStatus});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statuses = [
      {'label': 'Accepted', 'icon': 'check_circle'},
      {'label': 'Picking Up', 'icon': 'shopping_bag'},
      {'label': 'En Route', 'icon': 'local_shipping'},
      {'label': 'Delivered', 'icon': 'done_all'},
    ];

    final currentIndex = statuses.indexWhere(
      (status) =>
          (status['label'] as String).toLowerCase() ==
          currentStatus.toLowerCase(),
    );

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Progress',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: List.generate(statuses.length * 2 - 1, (index) {
              if (index.isOdd) {
                final statusIndex = index ~/ 2;
                final isCompleted = statusIndex < currentIndex;
                return Expanded(
                  child: Container(
                    height: 2,
                    color: isCompleted
                        ? Color(0xFF059669)
                        : theme.colorScheme.outline.withValues(alpha: 0.3),
                  ),
                );
              }

              final statusIndex = index ~/ 2;
              final status = statuses[statusIndex];
              final isCompleted = statusIndex < currentIndex;
              final isCurrent = statusIndex == currentIndex;

              return Column(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isCompleted || isCurrent
                          ? Color(0xFF059669)
                          : theme.colorScheme.surface,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isCompleted || isCurrent
                            ? Color(0xFF059669)
                            : theme.colorScheme.outline.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: CustomIconWidget(
                      iconName: status['icon'] as String,
                      color: isCompleted || isCurrent
                          ? Colors.white
                          : theme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                  SizedBox(height: 8),
                  SizedBox(
                    width: 70,
                    child: Text(
                      status['label'] as String,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: isCurrent
                            ? Color(0xFF059669)
                            : theme.colorScheme.onSurfaceVariant,
                        fontWeight: isCurrent
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
