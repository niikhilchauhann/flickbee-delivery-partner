import 'package:flutter/material.dart';

import '../../../core/global_widgets/custom_icon_widget.dart';
import '../order_model.dart';

class DeliveryProgressWidget extends StatefulWidget {
  final OrderDetailsModel order;
  final VoidCallback onContactCustomer;
  final VoidCallback onMarkPickedUp;
  final VoidCallback onMarkOutForDelivery;
  final bool isPickedUp;
  final bool isOutForDelivery;

  const DeliveryProgressWidget({
    super.key,
    required this.order,
    required this.onContactCustomer,
    required this.onMarkPickedUp,
    required this.onMarkOutForDelivery,
    required this.isPickedUp,
    required this.isOutForDelivery,
  });

  @override
  State<DeliveryProgressWidget> createState() => _DeliveryProgressWidgetState();
}

class _DeliveryProgressWidgetState extends State<DeliveryProgressWidget> {
  final ValueNotifier<bool> isExpanded = ValueNotifier(false);

  @override
  void dispose() {
    isExpanded.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow,
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: ValueListenableBuilder<bool>(
              valueListenable: isExpanded,
              builder: (_, expanded, __) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Header
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Delivery in Progress',
                                style: theme.textTheme.titleLarge,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  CustomIconWidget(
                                    iconName: 'access_time',
                                    size: 16,
                                    color: theme.colorScheme.primary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'ETA: ${widget.order.estimatedTime}',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: CustomIconWidget(
                            iconName: expanded
                                ? 'keyboard_arrow_down'
                                : 'keyboard_arrow_up',
                            size: 24,
                            color: theme.colorScheme.onSurface,
                          ),
                          onPressed: () => isExpanded.value = !expanded,
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    /// Order summary
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                '#${widget.order.orderId}',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: theme.colorScheme.onPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.order.customerName,
                                  style: theme.textTheme.titleMedium,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${widget.order.itemCount} items • ${widget.order.paymentMode}',
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          OutlinedButton.icon(
                            onPressed: widget.onContactCustomer,
                            icon: CustomIconWidget(
                              iconName: 'phone',
                              size: 18,
                              color: theme.colorScheme.primary,
                            ),
                            label: const Text('Call'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              minimumSize: const Size(0, 36),
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (expanded) ...[
                      const SizedBox(height: 16),

                      /// Expanded details (INLINE)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          border: Border.all(
                            color: theme.colorScheme.outline.withValues(
                              alpha: 0.2,
                            ),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Order Items',
                              style: theme.textTheme.titleSmall,
                            ),
                            const SizedBox(height: 8),
                            ...widget.order.items.map(
                              (item) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.primary,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        '${item.name} x${item.quantity}',
                                        style: theme.textTheme.bodyMedium,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Divider(
                              color: theme.colorScheme.outline.withValues(
                                alpha: 0.2,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total Amount',
                                  style: theme.textTheme.titleSmall,
                                ),
                                Text(
                                  widget.order.totalAmount,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 16),

                    /// Status buttons (INLINE)
                    Column(
                      children: [
                        if (!widget.isPickedUp)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: widget.onMarkPickedUp,
                              icon: CustomIconWidget(
                                iconName: 'check_circle',
                                size: 20,
                                color: theme.colorScheme.onPrimary,
                              ),
                              label: const Text('Mark Picked Up from Store'),
                            ),
                          ),
                        if (widget.isPickedUp && !widget.isOutForDelivery)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: widget.onMarkOutForDelivery,
                              icon: CustomIconWidget(
                                iconName: 'local_shipping',
                                size: 20,
                                color: theme.colorScheme.onPrimary,
                              ),
                              label: const Text('Mark Out for Delivery'),
                            ),
                          ),
                        if (widget.isPickedUp) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF059669,
                              ).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const CustomIconWidget(
                                  iconName: 'check_circle',
                                  size: 16,
                                  color: Color(0xFF059669),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  widget.isOutForDelivery
                                      ? 'Out for Delivery'
                                      : 'Picked Up',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: const Color(0xFF059669),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
