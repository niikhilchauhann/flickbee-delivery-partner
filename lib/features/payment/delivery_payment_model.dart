import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

@immutable
class PaymentWorkflowState {
  final double receivedAmount;
  final bool hasSignature;
  final XFile? deliveryPhoto;
  final bool checklistComplete;
  final bool isProcessing;

  const PaymentWorkflowState({
    this.receivedAmount = 0,
    this.hasSignature = false,
    this.deliveryPhoto,
    this.checklistComplete = false,
    this.isProcessing = false,
  });

  PaymentWorkflowState copyWith({
    double? receivedAmount,
    bool? hasSignature,
    XFile? deliveryPhoto,
    bool? checklistComplete,
    bool? isProcessing,
  }) {
    return PaymentWorkflowState(
      receivedAmount: receivedAmount ?? this.receivedAmount,
      hasSignature: hasSignature ?? this.hasSignature,
      deliveryPhoto: deliveryPhoto ?? this.deliveryPhoto,
      checklistComplete: checklistComplete ?? this.checklistComplete,
      isProcessing: isProcessing ?? this.isProcessing,
    );
  }
}
