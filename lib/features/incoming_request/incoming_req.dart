import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/global_widgets/custom_icon_widget.dart';
import '../order_details/order_details_screen.dart';
import 'widgets/countdown_timer.dart';
import 'widgets/customer_details.dart';
import 'widgets/order_summary.dart';
import 'widgets/route_map_preview.dart';
import 'widgets/store_detail.dart';

class IncomingOrderRequestScreen extends StatelessWidget {
  IncomingOrderRequestScreen({super.key});

  final ValueNotifier<bool> isProcessing = ValueNotifier(false);

  final Map<String, dynamic> orderData = {
    'orderId': 'ORD-2026-001234',
    'orderValue': '\$87.50',
    'earnings': '\$12.50',
    'distance': '2.3 mi',
    'estimatedTime': '25 min',
    'store': {
      'name': 'Fresh Mart Grocery',
      'itemsCount': 15,
      'specialInstructions': 'Handle frozen items with care',
    },
    'customer': {
      'name': 'Sarah Johnson',
      'address': '742 Maple Street, Apt 3B',
      'deliveryNotes': 'Please ring doorbell twice',
      'preferredTime': '6:00 PM - 6:30 PM',
    },
    'route': {
      'mapPreviewUrl':
          'https://images.unsplash.com/photo-1524661135-423995f22d0b?w=800&q=80',
      'totalDistance': '2.3 miles',
      'travelTime': '8 min drive',
    },
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: theme.brightness == Brightness.light
            ? Brightness.dark
            : Brightness.light,
      ),
      child: SafeArea(
        child: ValueListenableBuilder<bool>(
          valueListenable: isProcessing,
          builder: (_, processing, _) {
            return Column(
              children: [
                // HEADER
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    border: Border(
                      bottom: BorderSide(
                        color: theme.colorScheme.outline.withValues(alpha: 0.2),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: processing ? null : () => _handleReject(context),
                        child: Container(
                          width: 10.w,
                          height: 10.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: theme.colorScheme.outline.withValues(
                                alpha: 0.3,
                              ),
                            ),
                          ),
                          child: Center(
                            child: CustomIconWidget(
                              iconName: 'close',
                              color: theme.colorScheme.onSurface,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'Incoming Order',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                    ],
                  ),
                ),

                // BODY
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(4.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CountdownTimerWidget(
                          initialSeconds: 45,
                          onTimerExpired: () => _handleTimerExpired(context),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          'New Order Request',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Order #${orderData['orderId']}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(height: 3.h),

                        OrderSummaryCardWidget(
                          order: OrderSummaryModel(
                            orderValue: '200',
                            earnings: '20',
                            distance: '12',
                            estimatedTime: '12',
                          ),
                        ),
                        SizedBox(height: 3.h),

                        StoreDetailsWidget(
                          storeData: orderData['store'] as Map<String, dynamic>,
                        ),
                        SizedBox(height: 3.h),

                        CustomerDetailsWidget(
                          customerData:
                              orderData['customer'] as Map<String, dynamic>,
                        ),
                        SizedBox(height: 3.h),

                        Text(
                          'Route Preview',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 1.5.h),
                        RouteMapPreviewWidget(
                          routeData: orderData['route'] as Map<String, dynamic>,
                        ),
                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),
                ),

                // ACTION BUTTONS
                Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: processing
                                ? null
                                : () => _handleAccept(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF059669),
                              padding: EdgeInsets.symmetric(vertical: 2.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3.w),
                              ),
                            ),
                            child: processing
                                ? const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation(
                                      Colors.white,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomIconWidget(
                                        iconName: 'check_circle',
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      SizedBox(width: 2.w),
                                      Text(
                                        'Accept Order',
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: processing
                                ? null
                                : () => _handleReject(context),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFFDC2626),
                              side: const BorderSide(
                                color: Color(0xFFDC2626),
                                width: 2,
                              ),
                              padding: EdgeInsets.symmetric(vertical: 2.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3.w),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomIconWidget(
                                  iconName: 'cancel',
                                  color: const Color(0xFFDC2626),
                                  size: 20,
                                ),
                                SizedBox(width: 2.w),
                                Text(
                                  'Reject',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: const Color(0xFFDC2626),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _handleAccept(BuildContext context) async {
    if (isProcessing.value) return;
    isProcessing.value = true;
    HapticFeedback.mediumImpact();

    await Future.delayed(const Duration(milliseconds: 800));

    if (context.mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) =>  OrderDetailsScreen()),
      );
    }
  }

  void _handleReject(BuildContext context) {
    if (isProcessing.value) return;
    HapticFeedback.lightImpact();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Reject Order?'),
        content: const Text('Are you sure you want to reject this order?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }

  void _handleTimerExpired(BuildContext context) {
    if (isProcessing.value) return;
    HapticFeedback.heavyImpact();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Order Expired'),
        content: const Text('The time to accept this order has expired.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
