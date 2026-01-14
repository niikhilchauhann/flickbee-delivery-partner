import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/global_widgets/custom_icon_widget.dart';

/// Cash collection interface with calculator
/// Handles amount input and change calculation
class CashCollectionWidget extends StatefulWidget {
  final double orderTotal;
  final Function(double) onAmountChanged;

  const CashCollectionWidget({
    super.key,
    required this.orderTotal,
    required this.onAmountChanged,
  });

  @override
  State<CashCollectionWidget> createState() => _CashCollectionWidgetState();
}

class _CashCollectionWidgetState extends State<CashCollectionWidget> {
  String _displayAmount = '0';
  double _receivedAmount = 0.0;

  void _onNumberPressed(String number) {
    setState(() {
      if (_displayAmount == '0') {
        _displayAmount = number;
      } else {
        _displayAmount += number;
      }
      _receivedAmount = double.tryParse(_displayAmount) ?? 0.0;
      widget.onAmountChanged(_receivedAmount);
    });
  }

  void _onDecimalPressed() {
    setState(() {
      if (!_displayAmount.contains('.')) {
        _displayAmount += '.';
      }
    });
  }

  void _onClearPressed() {
    setState(() {
      _displayAmount = '0';
      _receivedAmount = 0.0;
      widget.onAmountChanged(0.0);
    });
  }

  void _onBackspacePressed() {
    setState(() {
      if (_displayAmount.length > 1) {
        _displayAmount = _displayAmount.substring(0, _displayAmount.length - 1);
      } else {
        _displayAmount = '0';
      }
      _receivedAmount = double.tryParse(_displayAmount) ?? 0.0;
      widget.onAmountChanged(_receivedAmount);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final changeAmount = _receivedAmount - widget.orderTotal;

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
            'Cash Collection',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Amount Received',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  '\$$_displayAmount',
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          if (changeAmount > 0) ...[
            SizedBox(height: 2.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: const Color(0xFF059669).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(2.w),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Change to Return',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: const Color(0xFF059669),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '\$${changeAmount.toStringAsFixed(2)}',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: const Color(0xFF059669),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
          SizedBox(height: 3.h),
          _buildCalculatorPad(theme),
        ],
      ),
    );
  }

  Widget _buildCalculatorPad(ThemeData theme) {
    return Column(
      children: [
        _buildCalculatorRow(theme, ['1', '2', '3']),
        SizedBox(height: 2.h),
        _buildCalculatorRow(theme, ['4', '5', '6']),
        SizedBox(height: 2.h),
        _buildCalculatorRow(theme, ['7', '8', '9']),
        SizedBox(height: 2.h),
        _buildCalculatorRow(theme, ['.', '0', 'back']),
        SizedBox(height: 2.h),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _onClearPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.errorContainer,
              foregroundColor: theme.colorScheme.error,
              padding: EdgeInsets.symmetric(vertical: 2.h),
            ),
            child: Text(
              'Clear',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCalculatorRow(ThemeData theme, List<String> buttons) {
    return Row(
      children: buttons.map((button) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 1.w),
            child: _buildCalculatorButton(theme, button),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalculatorButton(ThemeData theme, String value) {
    return Material(
      color: value == 'back'
          ? theme.colorScheme.secondaryContainer
          : theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
      borderRadius: BorderRadius.circular(2.w),
      child: InkWell(
        onTap: () {
          if (value == 'back') {
            _onBackspacePressed();
          } else if (value == '.') {
            _onDecimalPressed();
          } else {
            _onNumberPressed(value);
          }
        },
        borderRadius: BorderRadius.circular(2.w),
        child: Container(
          height: 8.h,
          alignment: Alignment.center,
          child: value == 'back'
              ? CustomIconWidget(
                  iconName: 'backspace',
                  color: theme.colorScheme.onSecondaryContainer,
                  size: 6.w,
                )
              : Text(
                  value,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
        ),
      ),
    );
  }
}
