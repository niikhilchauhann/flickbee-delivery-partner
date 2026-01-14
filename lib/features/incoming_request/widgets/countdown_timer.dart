import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/global_widgets/custom_icon_widget.dart';

/// Countdown timer widget for order acceptance
class CountdownTimerWidget extends StatefulWidget {
  final int initialSeconds;
  final VoidCallback onTimerExpired;

  const CountdownTimerWidget({
    super.key,
    required this.initialSeconds,
    required this.onTimerExpired,
  });

  @override
  State<CountdownTimerWidget> createState() => _CountdownTimerWidgetState();
}

class _CountdownTimerWidgetState extends State<CountdownTimerWidget> {
  late int _remainingSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.initialSeconds;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer?.cancel();
        widget.onTimerExpired();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Color _getTimerColor(ThemeData theme) {
    if (_remainingSeconds <= 10) {
      return const Color(0xFFDC2626);
    } else if (_remainingSeconds <= 20) {
      return const Color(0xFFD97706);
    }
    return theme.colorScheme.primary;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timerColor = _getTimerColor(theme);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: timerColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(color: timerColor.withValues(alpha: 0.3), width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(iconName: 'timer', color: timerColor, size: 24),
          SizedBox(width: 3.w),
          Text(
            'Accept within',
            style: theme.textTheme.titleMedium?.copyWith(
              color: timerColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 2.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: timerColor,
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: Text(
              '${_remainingSeconds}s',
              style: theme.textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
