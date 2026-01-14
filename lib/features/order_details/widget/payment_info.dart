import 'package:flutter/material.dart';

import '../../../core/global_widgets/custom_icon_widget.dart';

/// Payment information widget
/// Displays payment method and collection requirements
class PaymentInfoWidget extends StatelessWidget {
  final Map<String, dynamic> paymentData;

  const PaymentInfoWidget({super.key, required this.paymentData});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final paymentMethod =
        paymentData['method'] as String? ?? 'Cash on Delivery';
    final totalAmount = paymentData['totalAmount'] as double? ?? 0.0;
    final isPrepaid = paymentMethod.toLowerCase() == 'prepaid';
    final isOnline = paymentMethod.toLowerCase() == 'online payment';
    final isCOD = paymentMethod.toLowerCase() == 'cash on delivery';

    Color methodColor;
    IconData methodIcon;
    String collectionNote;

    if (isPrepaid) {
      methodColor = Color(0xFF059669);
      methodIcon = Icons.check_circle;
      collectionNote = 'Payment already collected. No action required.';
    } else if (isOnline) {
      methodColor = Color(0xFF2563EB);
      methodIcon = Icons.credit_card;
      collectionNote =
          'Payment will be processed online. Verify payment status before delivery.';
    } else {
      methodColor = Color(0xFFD97706);
      methodIcon = Icons.payments;
      collectionNote =
          'Collect \$${totalAmount.toStringAsFixed(2)} cash from customer at delivery.';
    }

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
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: methodColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(methodIcon, color: methodColor, size: 20),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payment Method',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      paymentMethod,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: methodColor,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '\$${totalAmount.toStringAsFixed(2)}',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: methodColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: methodColor.withValues(alpha: 0.3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomIconWidget(
                  iconName: 'info',
                  color: methodColor,
                  size: 20,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    collectionNote,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: methodColor,
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
}
