import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/global_widgets/custom_icon_widget.dart';

/// Earnings breakdown displaying delivery fee, tips, and total payout
class EarningsBreakdownWidget extends StatelessWidget {
  final Map<String, dynamic> earningsData;

  const EarningsBreakdownWidget({super.key, required this.earningsData, required earnings});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF059669).withValues(alpha: 0.1),
            const Color(0xFF059669).withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF059669).withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF059669),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: 'account_balance_wallet',
                  color: Colors.white,
                  size: 5.w,
                ),
              ),
              SizedBox(width: 3.w),
              Text(
                'Your Earnings',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF059669),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          _buildEarningRow(
            context,
            'Delivery Fee',
            '\$${earningsData["deliveryFee"]}',
            false,
          ),
          SizedBox(height: 1.5.h),
          _buildEarningRow(
            context,
            'Customer Tip',
            '\$${earningsData["tip"]}',
            false,
          ),
          if ((earningsData["bonus"] as double) > 0) ...[
            SizedBox(height: 1.5.h),
            _buildEarningRow(
              context,
              'Bonus',
              '\$${earningsData["bonus"]}',
              false,
            ),
          ],
          SizedBox(height: 2.h),
          Container(
            width: double.infinity,
            height: 1,
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
          SizedBox(height: 2.h),
          _buildEarningRow(
            context,
            'Total Payout',
            '\$${earningsData["total"]}',
            true,
          ),
          SizedBox(height: 2.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'info_outline',
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 4.w,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Earnings will be credited to your account within 24 hours',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEarningRow(
    BuildContext context,
    String label,
    String amount,
    bool isTotal,
  ) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                )
              : theme.textTheme.bodyMedium,
        ),
        Text(
          amount,
          style: isTotal
              ? theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF059669),
                )
              : theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
        ),
      ],
    );
  }
}
