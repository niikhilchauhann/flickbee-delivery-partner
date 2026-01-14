import 'package:flutter/material.dart';
@immutable
class StoreModel extends StorePickupModel {
  final String id;
  final String operatingHours;
  final int currentOrders;
  final String estimatedEarnings;
  final String contactNumber;
  final String parkingInstructions;
  final double driverRating;
  final String imageUrl;
  final String semanticLabel;
  final bool recentlySelected;

  const StoreModel({
    required this.id,
    required super.name,
    required super.address,
    required super.pickupInstructions,
    required super.latitude,
    required super.longitude,
    required super.distance,
    required this.operatingHours,
    required this.currentOrders,
    required this.estimatedEarnings,
    required this.contactNumber,
    required this.parkingInstructions,
    required this.driverRating,
    required this.imageUrl,
    required this.semanticLabel,
    required this.recentlySelected,
  });
}

@immutable
class StorePickupModel {
  final String name;
  final String address;
  final String pickupInstructions;
  final double latitude;
  final double longitude;
  final double distance;

  const StorePickupModel({
    required this.name,
    required this.address,
    required this.pickupInstructions,
    required this.latitude,
    required this.longitude,
    required this.distance,
  });
}

@immutable
class PaymentInfoModel {
  final String method;
  final double totalAmount;

  const PaymentInfoModel({
    required this.method,
    required this.totalAmount,
  });
}

