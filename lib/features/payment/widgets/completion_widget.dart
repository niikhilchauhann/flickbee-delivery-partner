import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/global_widgets/custom_icon_widget.dart';

/// Order completion checklist widget
/// Ensures all delivery requirements are met
class CompletionChecklistWidget extends StatefulWidget {
  final Function(bool) onChecklistChanged;

  const CompletionChecklistWidget({super.key, required this.onChecklistChanged});

  @override
  State<CompletionChecklistWidget> createState() =>
      _CompletionChecklistWidgetState();
}

class _CompletionChecklistWidgetState extends State<CompletionChecklistWidget> {
  bool _paymentCollected = false;
  bool _itemsDelivered = false;
  bool _customerSatisfied = false;

  void _updateChecklist() {
    final allChecked =
        _paymentCollected && _itemsDelivered && _customerSatisfied;
    widget.onChecklistChanged(allChecked);
  }

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
          Text(
            'Completion Checklist',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          _buildChecklistItem(theme, 'Payment Collected', _paymentCollected, (
            value,
          ) {
            setState(() {
              _paymentCollected = value;
              _updateChecklist();
            });
          }),
          SizedBox(height: 2.h),
          _buildChecklistItem(theme, 'All Items Delivered', _itemsDelivered, (
            value,
          ) {
            setState(() {
              _itemsDelivered = value;
              _updateChecklist();
            });
          }),
          SizedBox(height: 2.h),
          _buildChecklistItem(theme, 'Customer Satisfied', _customerSatisfied, (
            value,
          ) {
            setState(() {
              _customerSatisfied = value;
              _updateChecklist();
            });
          }),
        ],
      ),
    );
  }

  Widget _buildChecklistItem(
    ThemeData theme,
    String label,
    bool value,
    Function(bool) onChanged,
  ) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: value
            ? const Color(0xFF059669).withValues(alpha: 0.1)
            : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: value
              ? const Color(0xFF059669)
              : theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 6.w,
            height: 6.w,
            child: Checkbox(
              value: value,
              onChanged: (newValue) => onChanged(newValue ?? false),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(1.w),
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: value
                    ? const Color(0xFF059669)
                    : theme.colorScheme.onSurface,
              ),
            ),
          ),
          if (value)
            CustomIconWidget(
              iconName: 'check_circle',
              color: const Color(0xFF059669),
              size: 6.w,
            ),
        ],
      ),
    );
  }
}
