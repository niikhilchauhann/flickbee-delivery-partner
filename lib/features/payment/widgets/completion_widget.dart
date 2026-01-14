import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/global_widgets/custom_icon_widget.dart';

class CompletionChecklistWidget extends StatelessWidget {
  final ValueChanged<bool> onChecklistChanged;

   CompletionChecklistWidget({
    super.key,
    required this.onChecklistChanged,
  });

  final ValueNotifier<bool> _paymentCollected = ValueNotifier(false);

  final ValueNotifier<bool> _itemsDelivered = ValueNotifier(false);

  final ValueNotifier<bool> _customerSatisfied = ValueNotifier(false);

  void _updateChecklist() {
    onChecklistChanged(
      _paymentCollected.value &&
          _itemsDelivered.value &&
          _customerSatisfied.value,
    );
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

          /// Payment Collected
          ValueListenableBuilder<bool>(
            valueListenable: _paymentCollected,
            builder: (_, value, __) {
              return _ChecklistRow(
                theme: theme,
                label: 'Payment Collected',
                value: value,
                onChanged: (v) {
                  _paymentCollected.value = v;
                  _updateChecklist();
                },
              );
            },
          ),

          SizedBox(height: 2.h),

          /// Items Delivered
          ValueListenableBuilder<bool>(
            valueListenable: _itemsDelivered,
            builder: (_, value, __) {
              return _ChecklistRow(
                theme: theme,
                label: 'All Items Delivered',
                value: value,
                onChanged: (v) {
                  _itemsDelivered.value = v;
                  _updateChecklist();
                },
              );
            },
          ),

          SizedBox(height: 2.h),

          /// Customer Satisfied
          ValueListenableBuilder<bool>(
            valueListenable: _customerSatisfied,
            builder: (_, value, __) {
              return _ChecklistRow(
                theme: theme,
                label: 'Customer Satisfied',
                value: value,
                onChanged: (v) {
                  _customerSatisfied.value = v;
                  _updateChecklist();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Internal UI row (not a helper method in widget tree)
class _ChecklistRow extends StatelessWidget {
  final ThemeData theme;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  static const Color _successColor = Color(0xFF059669);

  const _ChecklistRow({
    required this.theme,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: value
            ? _successColor.withValues(alpha: 0.1)
            : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: value
              ? _successColor
              : theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 6.w,
            height: 6.w,
            child: Checkbox(
              value: value,
              onChanged: (v) => onChanged(v ?? false),
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
                color: value ? _successColor : theme.colorScheme.onSurface,
              ),
            ),
          ),
          if (value)
            CustomIconWidget(
              iconName: 'check_circle',
              color: _successColor,
              size: 6.w,
            ),
        ],
      ),
    );
  }
}
