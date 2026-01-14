import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/global_widgets/custom_icon_widget.dart';
import '../incoming_request/widgets/order_summary.dart';
import 'order_completion_model.dart';
import 'widgets/action_buttons.dart';
import 'widgets/completion_header.dart';
import 'widgets/customer_rating.dart';
import 'widgets/delivery_metrics.dart';
import 'widgets/earnings_breakdown.dart';
class OrderCompletionScreen extends StatelessWidget {
  OrderCompletionScreen({super.key});

  final ValueNotifier<bool> _showSheet = ValueNotifier(false);

  final OrderCompletionData data = const OrderCompletionData(
    order: OrderSummaryModel(
      orderValue: 'ORD-2026-0111-4523',
      earnings: '',
      distance: '',
      estimatedTime: 'Completed at 11:35 AM, Jan 11, 2026',
    ),
    earnings: EarningsSummaryModel(
      deliveryFee: 8.50,
      tip: 5.00,
      bonus: 2.50,
      total: 16.00,
    ),
    metrics: DeliveryMetricsModel(
      completionTime: '28 min',
      distance: '4.2 mi',
      efficiency: 92.0,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: Navigator.of(context).pop,
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: theme.colorScheme.onSurface,
            size: 6.w,
          ),
        ),
        title: Text(
          'Delivery Completed',
          style: theme.appBarTheme.titleTextStyle,
        ),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'share',
              color: theme.colorScheme.onSurface,
              size: 6.w,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text(
                    'Share Achievement',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  content: Text(
                    'Share your delivery milestone on social media!',
                    style: theme.textTheme.bodyMedium,
                  ),
                  actions: [
                    TextButton(
                      onPressed: Navigator.of(context).pop,
                      child: Text(
                        'Cancel',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              'Achievement shared successfully!',
                            ),
                            backgroundColor: const Color(0xFF059669),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'Share',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const CompletionHeaderWidget(),
                  OrderSummaryCardWidget(order: data.order),
                  EarningsBreakdownWidget(
                    earnings: data.earnings,
                    earningsData: const {},
                  ),
                  DeliveryMetricsWidget(
                    metrics: data.metrics,
                    metricsData: const {},
                  ),
                  CustomerRatingWidget(
                    onSubmitRating: (_, __) {},
                  ),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),
          ActionButtonsWidget(
            onReturnToDashboard: Navigator.of(context).pop,
            onViewEarningsDetails: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) =>
                    EarningsDetailsSheet(earnings: data.earnings),
              );
            },
          ),
        ],
      ),
    );
  }
}
class EarningsDetailsSheet extends StatelessWidget {
  final EarningsSummaryModel earnings;

  const EarningsDetailsSheet({super.key, required this.earnings});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 12.w,
            height: 4,
            margin: EdgeInsets.symmetric(vertical: 2.h),
            decoration: BoxDecoration(
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Earnings Breakdown',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  onPressed: Navigator.of(context).pop,
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: theme.colorScheme.onSurface,
                    size: 6.w,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Base Delivery Fee',
                          style: theme.textTheme.bodyMedium),
                      Text('\$${earnings.deliveryFee}',
                          style: theme.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600)),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Customer Tip',
                          style: theme.textTheme.bodyMedium),
                      Text('\$${earnings.tip}',
                          style: theme.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600)),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Performance Bonus',
                          style: theme.textTheme.bodyMedium),
                      Text('\$${earnings.bonus}',
                          style: theme.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600)),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Divider(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Earnings',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '\$${earnings.total}',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF059669),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
