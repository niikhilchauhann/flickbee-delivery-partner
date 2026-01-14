import 'package:flickbee_delivery_partner/features/order_completion/order_completion.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/global_widgets/custom_icon_widget.dart';
import '../auth/login_screen.dart';
import '../navigation/order_model.dart';
import './widgets/payment_method_card_widget.dart';
import './widgets/photo_verification_widget.dart';
import 'delivery_payment_model.dart';
import 'widgets/cash_collection.dart';
import 'widgets/completion_widget.dart';
import 'widgets/signature_verification_widget.dart';

class PaymentConfirmationScreen extends StatelessWidget {
  PaymentConfirmationScreen({super.key});

  final ValueNotifier<PaymentWorkflowState> workflow = ValueNotifier(
    const PaymentWorkflowState(),
  );

  final OrderDetailsModel order = const OrderDetailsModel(
    orderId: 'ORD-2026-001234',
    customerName: 'Sarah Johnson',
    customerPhone: '+1-555-0123',
    itemCount: 5,
    paymentMode: 'Cash on Delivery',
    totalAmount: '127.50',
    estimatedTime: '—',
    deliveryAddress: '456 Oak Street, Apt 3B, Springfield, IL 62701',
    items: [],
  );

  bool _canComplete(OrderDetailsModel order, PaymentWorkflowState state) {
    if (order.paymentMode == 'Cash on Delivery') {
      return state.receivedAmount >= double.parse(order.totalAmount) &&
          state.hasSignature &&
          state.deliveryPhoto != null &&
          state.checklistComplete;
    }
    return state.hasSignature &&
        state.deliveryPhoto != null &&
        state.checklistComplete;
  }

  Future<void> _completeDelivery(BuildContext context, bool canComplete) async {
    if (!canComplete) return;

    workflow.value = workflow.value.copyWith(isProcessing: true);

    await Future.delayed(const Duration(seconds: 2));

    workflow.value = workflow.value.copyWith(isProcessing: false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: Colors.white,
              size: 5.w,
            ),
            SizedBox(width: 3.w),
            const Expanded(
              child: Text(
                'Delivery completed successfully!',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF059669),
        behavior: SnackBarBehavior.floating,
      ),
    );

    await Future.delayed(const Duration(milliseconds: 500));
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute(builder: (context) => OrderCompletionScreen()),
      (r) => false,
    );

   
  }

  void _reportIssue(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Report Issue'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _IssueOption(label: 'Payment Dispute'),
            _IssueOption(label: 'Customer Not Available'),
            _IssueOption(label: 'Incorrect Address'),
            _IssueOption(label: 'Other Issue'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Issue reported. Support will contact you shortly.',
                  ),
                  backgroundColor: Color(0xFFD97706),
                ),
              );
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: theme.colorScheme.onSurface,
            size: 6.w,
          ),
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
        ),
        title: const Text('Payment Confirmation'),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'report_problem',
              color: const Color(0xFFD97706),
              size: 6.w,
            ),
            onPressed: () => _reportIssue(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer.withValues(
                          alpha: 0.2,
                        ),
                        borderRadius: BorderRadius.circular(2.w),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'info_outline',
                            color: theme.colorScheme.primary,
                            size: 5.w,
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Text(
                              'Order #${order.orderId}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 3.h),
                    PaymentMethodCardWidget(
                      paymentMethod: order.paymentMode,
                      orderTotal: double.parse(order.totalAmount),
                      transactionId: null,
                      referenceNumber: null,
                    ),
                    SizedBox(height: 3.h),
                    if (order.paymentMode == 'Cash on Delivery') ...[
                      CashCollectionWidget(
                        orderTotal: double.parse(order.totalAmount),
                        onAmountChanged: (amount) {
                          workflow.value = workflow.value.copyWith(
                            receivedAmount: amount,
                          );
                        },
                      ),
                      SizedBox(height: 3.h),
                    ],
                    SignatureCaptureWidget(
                      onSignatureChanged: (v) {
                        workflow.value = workflow.value.copyWith(
                          hasSignature: v,
                        );
                      },
                    ),
                    SizedBox(height: 3.h),
                    PhotoVerificationWidget(
                      onPhotoChanged: (photo) {
                        workflow.value = workflow.value.copyWith(
                          deliveryPhoto: photo,
                        );
                      },
                    ),
                    SizedBox(height: 3.h),
                    CompletionChecklistWidget(
                      onChecklistChanged: (v) {
                        workflow.value = workflow.value.copyWith(
                          checklistComplete: v,
                        );
                      },
                    ),
                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            ),
            ValueListenableBuilder<PaymentWorkflowState>(
              valueListenable: workflow,
              builder: (_, state, _) {
                final canComplete = _canComplete(order, state);

                return Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.shadow,
                        blurRadius: 8,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    top: false,
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: !state.isProcessing
                            ? () => _completeDelivery(context, canComplete)
                            : null,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          backgroundColor: canComplete
                              ? const Color(0xFF059669)
                              : null,
                        ),
                        child: state.isProcessing
                            ? SizedBox(
                                height: 5.w,
                                width: 5.w,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    theme.colorScheme.onPrimary,
                                  ),
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomIconWidget(
                                    iconName: 'check_circle',
                                    color: canComplete
                                        ? Colors.white
                                        : theme.colorScheme.onSurface
                                              .withValues(alpha: 0.38),
                                    size: 6.w,
                                  ),
                                  SizedBox(width: 3.w),
                                  Text(
                                    'Complete Delivery',
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _IssueOption extends StatelessWidget {
  final String label;

  const _IssueOption({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        children: [
          const Radio(value: true, groupValue: false, onChanged: null),
          SizedBox(width: 2.w),
          Text(label),
        ],
      ),
    );
  }
}
