import 'package:flutter/material.dart';

import '../order_details/order_pickup_model.dart';
@immutable
class OrderDetailsModel {
  final String orderId;
  final String customerName;
  final String customerPhone;
  final int itemCount;
  final String paymentMode;
  final String totalAmount;
  final String estimatedTime;
  final List<OrderItemModel> items;
  final String deliveryAddress;

  // ✅ OPTIONAL (non-breaking)
  final String? orderDate;
  final String? specialInstructions;
  final StorePickupModel? store;
  final PaymentInfoModel? payment;

  const OrderDetailsModel({
    required this.orderId,
    required this.customerName,
    required this.customerPhone,
    required this.itemCount,
    required this.paymentMode,
    required this.totalAmount,
    required this.estimatedTime,
    required this.items,
    required this.deliveryAddress,
    this.orderDate,
    this.specialInstructions,
    this.store,
    this.payment,
  });

  OrderDetailsModel copyWith({
    List<OrderItemModel>? items,
  }) {
    return OrderDetailsModel(
      orderId: orderId,
      customerName: customerName,
      customerPhone: customerPhone,
      itemCount: itemCount,
      paymentMode: paymentMode,
      totalAmount: totalAmount,
      estimatedTime: estimatedTime,
      items: items ?? this.items,
      deliveryAddress: deliveryAddress,
      orderDate: orderDate,
      specialInstructions: specialInstructions,
      store: store,
      payment: payment,
    );
  }
}


@immutable
class OrderItemModel {
  final String name;
  final int quantity;
  final double price;
  final String image;
  final String semanticLabel;
  final String substitutionNote;
  final bool isUnavailable;

  const OrderItemModel({
    required this.name,
    required this.quantity,
    required this.price,
    required this.image,
    required this.semanticLabel,
    required this.substitutionNote,
    required this.isUnavailable,
  });

  OrderItemModel copyWith({String? substitutionNote, bool? isUnavailable}) {
    return OrderItemModel(
      name: name,
      quantity: quantity,
      price: price,
      image: image,
      semanticLabel: semanticLabel,
      substitutionNote: substitutionNote ?? this.substitutionNote,
      isUnavailable: isUnavailable ?? this.isUnavailable,
    );
  }
}
