import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/global_widgets/custom_icon_widget.dart';
class CashCollectionWidget extends StatelessWidget {
  final double orderTotal;
  final ValueChanged<double> onAmountChanged;

  CashCollectionWidget({
    super.key,
    required this.orderTotal,
    required this.onAmountChanged,
  });

  final ValueNotifier<String> _displayAmount = ValueNotifier('0');
  final ValueNotifier<double> _receivedAmount = ValueNotifier(0.0);

  void _onNumberPressed(String number) {
    _displayAmount.value =
        _displayAmount.value == '0' ? number : _displayAmount.value + number;

    _receivedAmount.value =
        double.tryParse(_displayAmount.value) ?? 0.0;

    onAmountChanged(_receivedAmount.value);
  }

  void _onDecimalPressed() {
    if (!_displayAmount.value.contains('.')) {
      _displayAmount.value += '.';
    }
  }

  void _onClearPressed() {
    _displayAmount.value = '0';
    _receivedAmount.value = 0.0;
    onAmountChanged(0.0);
  }

  void _onBackspacePressed() {
    _displayAmount.value =
        _displayAmount.value.length > 1
            ? _displayAmount.value.substring(
                0,
                _displayAmount.value.length - 1,
              )
            : '0';

    _receivedAmount.value =
        double.tryParse(_displayAmount.value) ?? 0.0;

    onAmountChanged(_receivedAmount.value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ValueListenableBuilder<double>(
      valueListenable: _receivedAmount,
      builder: (context, receivedAmount, _) {
        final changeAmount = receivedAmount - orderTotal;

        return ValueListenableBuilder<String>(
          valueListenable: _displayAmount,
          builder: (context, displayAmount, __) {
            return Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(3.w),
                border: Border.all(
                  color:
                      theme.colorScheme.outline.withValues(alpha: 0.2),
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

                  /// DISPLAY
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer
                          .withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(2.w),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Amount Received',
                          style:
                              theme.textTheme.bodySmall?.copyWith(
                            color: theme
                                .colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          '\$$displayAmount',
                          style:
                              theme.textTheme.displaySmall?.copyWith(
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
                        color: const Color(0xFF059669)
                            .withValues(alpha: 0.1),
                        borderRadius:
                            BorderRadius.circular(2.w),
                      ),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Change to Return',
                            style: theme.textTheme.titleMedium
                                ?.copyWith(
                              color:
                                  const Color(0xFF059669),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '\$${changeAmount.toStringAsFixed(2)}',
                            style: theme.textTheme.titleLarge
                                ?.copyWith(
                              color:
                                  const Color(0xFF059669),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  SizedBox(height: 3.h),

                  /// CALCULATOR (INLINE, NO HELPERS)
                  for (final row in const [
                    ['1', '2', '3'],
                    ['4', '5', '6'],
                    ['7', '8', '9'],
                    ['.', '0', 'back'],
                  ]) ...[
                    Row(
                      children: row.map((value) {
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 1.w),
                            child: Material(
                              color: value == 'back'
                                  ? theme.colorScheme
                                      .secondaryContainer
                                  : theme
                                      .colorScheme.primaryContainer
                                      .withValues(alpha: 0.3),
                              borderRadius:
                                  BorderRadius.circular(2.w),
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
                                borderRadius:
                                    BorderRadius.circular(2.w),
                                child: Container(
                                  height: 8.h,
                                  alignment: Alignment.center,
                                  child: value == 'back'
                                      ? CustomIconWidget(
                                          iconName: 'backspace',
                                          color: theme
                                              .colorScheme
                                              .onSecondaryContainer,
                                          size: 6.w,
                                        )
                                      : Text(
                                          value,
                                          style: theme
                                              .textTheme
                                              .headlineSmall
                                              ?.copyWith(
                                            fontWeight:
                                                FontWeight.w600,
                                            color: theme
                                                .colorScheme
                                                .onSurface,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 2.h),
                  ],

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _onClearPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            theme.colorScheme.errorContainer,
                        foregroundColor:
                            theme.colorScheme.error,
                        padding:
                            EdgeInsets.symmetric(vertical: 2.h),
                      ),
                      child: Text(
                        'Clear',
                        style: theme.textTheme.titleMedium
                            ?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
