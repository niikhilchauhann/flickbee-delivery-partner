import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/global_widgets/custom_icon_widget.dart';

/// Payment method selection card widget
/// Displays payment method with appropriate visual treatment
class PaymentMethodCardWidget extends StatelessWidget {
  final String paymentMethod;
  final double orderTotal;
  final String? transactionId;
  final String? referenceNumber;

  const PaymentMethodCardWidget({
    super.key,
    required this.paymentMethod,
    required this.orderTotal,
    this.transactionId,
    this.referenceNumber,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
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
                  color: _getPaymentColor(theme).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: CustomIconWidget(
                  iconName: _getPaymentIcon(),
                  color: _getPaymentColor(theme),
                  size: 6.w,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      paymentMethod,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      _getPaymentStatus(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: _getPaymentColor(theme),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order Total',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  '\$${orderTotal.toStringAsFixed(2)}',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          if (transactionId != null) ...[
            SizedBox(height: 2.h),
            _buildInfoRow(context, 'Transaction ID', transactionId!),
          ],
          if (referenceNumber != null) ...[
            SizedBox(height: 2.h),
            _buildInfoRow(context, 'Reference Number', referenceNumber!),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }

  String _getPaymentIcon() {
    if (paymentMethod == 'Cash on Delivery') return 'payments';
    if (paymentMethod == 'Online Payment') return 'credit_card';
    return 'check_circle';
  }

  Color _getPaymentColor(ThemeData theme) {
    if (paymentMethod == 'Cash on Delivery') return const Color(0xFFD97706);
    if (paymentMethod == 'Online Payment') return const Color(0xFF059669);
    return const Color(0xFF2563EB);
  }

  String _getPaymentStatus() {
    if (paymentMethod == 'Cash on Delivery') {
      return 'Collect payment from customer';
    }
    if (paymentMethod == 'Online Payment') return 'Already Paid';
    return 'Payment Complete';
  }
}
