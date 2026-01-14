// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';

// import '../../core/global_widgets/custom_icon_widget.dart';
// import './widgets/payment_method_card_widget.dart';
// import './widgets/photo_verification_widget.dart';
// import 'widgets/cash_collection.dart';
// import 'widgets/completion_widget.dart';
// import 'widgets/signature_verification_widget.dart';

// /// Payment Confirmation Screen
// /// Manages payment collection and order completion workflow
// class PaymentConfirmationScreen extends StatefulWidget {
//   const PaymentConfirmationScreen({super.key});

//   @override
//   State<PaymentConfirmationScreen> createState() =>
//       _PaymentConfirmationScreenState();
// }

// class _PaymentConfirmationScreenState extends State<PaymentConfirmationScreen> {
//   // Mock order data
//   final Map<String, dynamic> _orderData = {
//     "orderId": "ORD-2026-001234",
//     "paymentMethod": "Cash on Delivery",
//     "orderTotal": 127.50,
//     "transactionId": null,
//     "referenceNumber": null,
//     "customerName": "Sarah Johnson",
//     "deliveryAddress": "456 Oak Street, Apt 3B, Springfield, IL 62701",
//     "items": [
//       {"name": "Organic Bananas", "quantity": 2, "price": 4.50},
//       {"name": "Whole Milk (1 Gallon)", "quantity": 1, "price": 5.99},
//       {"name": "Fresh Bread", "quantity": 3, "price": 8.97},
//       {"name": "Chicken Breast (2 lbs)", "quantity": 1, "price": 12.99},
//       {"name": "Mixed Vegetables", "quantity": 2, "price": 11.98},
//     ],
//   };

//   double _receivedAmount = 0.0;
//   bool _hasSignature = false;
//   XFile? _deliveryPhoto;
//   bool _checklistComplete = false;
//   bool _isProcessing = false;

//   bool get _canCompleteDelivery {
//     if (_orderData["paymentMethod"] == "Cash on Delivery") {
//       return _receivedAmount >= (_orderData["orderTotal"] as double) &&
//           _hasSignature &&
//           _deliveryPhoto != null &&
//           _checklistComplete;
//     }
//     return _hasSignature && _deliveryPhoto != null && _checklistComplete;
//   }

//   Future<void> _completeDelivery() async {
//     if (!_canCompleteDelivery) return;

//     setState(() {
//       _isProcessing = true;
//     });

//     await Future.delayed(const Duration(seconds: 2));

//     if (mounted) {
//       setState(() {
//         _isProcessing = false;
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Row(
//             children: [
//               CustomIconWidget(
//                 iconName: 'check_circle',
//                 color: Colors.white,
//                 size: 5.w,
//               ),
//               SizedBox(width: 3.w),
//               Expanded(
//                 child: Text(
//                   'Delivery completed successfully!',
//                   style: Theme.of(
//                     context,
//                   ).textTheme.bodyMedium?.copyWith(color: Colors.white),
//                 ),
//               ),
//             ],
//           ),
//           backgroundColor: const Color(0xFF059669),
//           behavior: SnackBarBehavior.floating,
//           duration: const Duration(seconds: 3),
//         ),
//       );

//       await Future.delayed(const Duration(milliseconds: 500));

//       if (mounted) {
//         Navigator.of(
//           context,
//           rootNavigator: true,
//         ).pushNamedAndRemoveUntil('/order-completion-screen', (route) => false);
//       }
//     }
//   }

//   void _reportIssue() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Report Issue'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Select issue type:'),
//             SizedBox(height: 2.h),
//             _buildIssueOption('Payment Dispute'),
//             _buildIssueOption('Customer Not Available'),
//             _buildIssueOption('Incorrect Address'),
//             _buildIssueOption('Other Issue'),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text(
//                     'Issue reported. Support will contact you shortly.',
//                   ),
//                   backgroundColor: const Color(0xFFD97706),
//                 ),
//               );
//             },
//             child: Text('Submit'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildIssueOption(String issue) {
//     return InkWell(
//       onTap: () {},
//       child: Padding(
//         padding: EdgeInsets.symmetric(vertical: 1.h),
//         child: Row(
//           children: [
//             Radio<String>(
//               value: issue,
//               groupValue: null,
//               onChanged: (value) {},
//             ),
//             SizedBox(width: 2.w),
//             Text(issue),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: CustomIconWidget(
//             iconName: 'arrow_back',
//             color: theme.colorScheme.onSurface,
//             size: 6.w,
//           ),
//           onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
//         ),
//         title: Text('Payment Confirmation'),
//         actions: [
//           IconButton(
//             icon: CustomIconWidget(
//               iconName: 'report_problem',
//               color: const Color(0xFFD97706),
//               size: 6.w,
//             ),
//             onPressed: _reportIssue,
//             tooltip: 'Report Issue',
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Expanded(
//               child: SingleChildScrollView(
//                 padding: EdgeInsets.all(4.w),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       padding: EdgeInsets.all(3.w),
//                       decoration: BoxDecoration(
//                         color: theme.colorScheme.primaryContainer.withValues(
//                           alpha: 0.2,
//                         ),
//                         borderRadius: BorderRadius.circular(2.w),
//                       ),
//                       child: Row(
//                         children: [
//                           CustomIconWidget(
//                             iconName: 'info_outline',
//                             color: theme.colorScheme.primary,
//                             size: 5.w,
//                           ),
//                           SizedBox(width: 3.w),
//                           Expanded(
//                             child: Text(
//                               'Order #${_orderData["orderId"]}',
//                               style: theme.textTheme.titleMedium?.copyWith(
//                                 fontWeight: FontWeight.w600,
//                                 color: theme.colorScheme.primary,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 3.h),
//                     PaymentMethodCardWidget(
//                       paymentMethod: _orderData["paymentMethod"] as String,
//                       orderTotal: _orderData["orderTotal"] as double,
//                       transactionId: _orderData["transactionId"] as String?,
//                       referenceNumber: _orderData["referenceNumber"] as String?,
//                     ),
//                     SizedBox(height: 3.h),
//                     if (_orderData["paymentMethod"] == "Cash on Delivery") ...[
//                       CashCollectionWidget(
//                         orderTotal: _orderData["orderTotal"] as double,
//                         onAmountChanged: (amount) {
//                           setState(() {
//                             _receivedAmount = amount;
//                           });
//                         },
//                       ),
//                       SizedBox(height: 3.h),
//                     ],
//                     SignatureCaptureWidget(
//                       onSignatureChanged: (hasSignature) {
//                         setState(() {
//                           _hasSignature = hasSignature;
//                         });
//                       },
//                     ),
//                     SizedBox(height: 3.h),
//                     PhotoVerificationWidget(
//                       onPhotoChanged: (photo) {
//                         setState(() {
//                           _deliveryPhoto = photo;
//                         });
//                       },
//                     ),
//                     SizedBox(height: 3.h),
//                     CompletionChecklistWidget(
//                       onChecklistChanged: (isComplete) {
//                         setState(() {
//                           _checklistComplete = isComplete;
//                         });
//                       },
//                     ),
//                     SizedBox(height: 10.h),
//                   ],
//                 ),
//               ),
//             ),
//             Container(
//               padding: EdgeInsets.all(4.w),
//               decoration: BoxDecoration(
//                 color: theme.colorScheme.surface,
//                 boxShadow: [
//                   BoxShadow(
//                     color: theme.colorScheme.shadow,
//                     blurRadius: 8,
//                     offset: const Offset(0, -2),
//                   ),
//                 ],
//               ),
//               child: SafeArea(
//                 top: false,
//                 child: SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: _canCompleteDelivery && !_isProcessing
//                         ? _completeDelivery
//                         : null,
//                     style: ElevatedButton.styleFrom(
//                       padding: EdgeInsets.symmetric(vertical: 2.h),
//                       backgroundColor: _canCompleteDelivery
//                           ? const Color(0xFF059669)
//                           : null,
//                     ),
//                     child: _isProcessing
//                         ? SizedBox(
//                             height: 5.w,
//                             width: 5.w,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2,
//                               valueColor: AlwaysStoppedAnimation<Color>(
//                                 theme.colorScheme.onPrimary,
//                               ),
//                             ),
//                           )
//                         : Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               CustomIconWidget(
//                                 iconName: 'check_circle',
//                                 color: _canCompleteDelivery
//                                     ? Colors.white
//                                     : theme.colorScheme.onSurface.withValues(
//                                         alpha: 0.38,
//                                       ),
//                                 size: 6.w,
//                               ),
//                               SizedBox(width: 3.w),
//                               Text(
//                                 'Complete Delivery',
//                                 style: theme.textTheme.titleLarge?.copyWith(
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ],
//                           ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
