import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/global_widgets/custom_icon_widget.dart';
import 'widgets/home_card.dart';

class DriverHomeScreenInitialPage extends StatelessWidget {
  DriverHomeScreenInitialPage({super.key});

  final ValueNotifier<bool> isOnline = ValueNotifier(false);
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  final driverStatus = {
    "selectedStore": "Fresh Mart Downtown",
    "shiftDuration": "2h 34m",
    "completedDeliveries": 8,
    "todayEarnings": "\$127.50",
  };

  final todayStats = [
    {
      "icon": "local_shipping",
      "label": "Total Deliveries",
      "value": "8",
      "color": Color(0xFF2563EB),
    },
    {
      "icon": "account_balance_wallet",
      "label": "Earnings",
      "value": "\$127.50",
      "color": Color(0xFF059669),
    },
    {
      "icon": "star",
      "label": "Average Rating",
      "value": "4.8",
      "color": Color(0xFFD97706),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ValueListenableBuilder<bool>(
      valueListenable: isOnline,
      builder: (_, online, __) {
        return RefreshIndicator(
          onRefresh: () async => Future.delayed(const Duration(seconds: 1)),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ValueListenableBuilder<bool>(
                  valueListenable: isLoading,
                  builder: (_, loading, __) {
                    return Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.shadow,
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 3.w,
                                height: 3.w,
                                decoration: BoxDecoration(
                                  color: online
                                      ? const Color(0xFF059669)
                                      : const Color(0xFF64748B),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                online ? 'You are Online' : 'You are Offline',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: online
                                      ? const Color(0xFF059669)
                                      : const Color(0xFF64748B),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.h),
                          SizedBox(
                            width: 70.w,
                            height: 7.h,
                            child: ElevatedButton(
                              onPressed: loading
                                  ? null
                                  : () async {
                                      isLoading.value = true;
                                      await Future.delayed(
                                        const Duration(milliseconds: 800),
                                      );
                                      isOnline.value = !online;
                                      isLoading.value = false;
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: online
                                    ? const Color(0xFFDC2626)
                                    : const Color(0xFF059669),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: loading
                                  ? SizedBox(
                                      width: 5.w,
                                      height: 5.w,
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    )
                                  : Text(
                                      online ? 'Go Offline' : 'Go Online',
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                SizedBox(height: 3.h),

                StatusCardWidget(isOnline: online, driverStatus: driverStatus),

                SizedBox(height: 3.h),

                online
                    ? const WaitingStateWidget()
                    : Container(
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: theme.colorScheme.outline.withValues(
                              alpha: 0.3,
                            ),
                          ),
                        ),
                        child: Column(
                          children: [
                            const CustomIconWidget(
                              iconName: 'info_outline',
                              color: Color(0xFF64748B),
                              size: 48,
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'Go Online to Receive Orders',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              'Toggle your status to online to start receiving delivery requests from nearby stores',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                SizedBox(height: 3.h),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Today\'s Performance',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'View History',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 2.h),

                SizedBox(
                  height: 18.h,
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    scrollDirection: Axis.horizontal,
                    itemCount: todayStats.length,
                    separatorBuilder: (_, __) => SizedBox(width: 3.w),
                    itemBuilder: (_, i) {
                      final s = todayStats[i];
                      return StatsCardWidget(
                        icon: s["icon"] as String,
                        label: s["label"] as String,
                        value: s["value"] as String,
                        color: s["color"] as Color,
                      );
                    },
                  ),
                ),

                SizedBox(height: 3.h),

                Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDC2626).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFDC2626).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDC2626),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const CustomIconWidget(
                          iconName: 'phone',
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Emergency Support',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              'Available 24/7 for urgent assistance',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 18.w,
                        height: 5.h,
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFDC2626)),
                            foregroundColor: const Color(0xFFDC2626),
                          ),
                          child: const Text('Call'),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 3.h),
              ],
            ),
          ),
        );
      },
    );
  }
}
