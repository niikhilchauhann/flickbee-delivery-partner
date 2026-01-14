import 'package:flutter/material.dart';

import '../incoming_request/widgets/order_summary.dart';

@immutable
class OrderCompletionData {
  final OrderSummaryModel order;
  final EarningsSummaryModel earnings;
  final DeliveryMetricsModel metrics;

  const OrderCompletionData({
    required this.order,
    required this.earnings,
    required this.metrics,
  });
}


class EarningsSummaryModel {
  final double deliveryFee;
  final double tip;
  final double bonus;
  final double total;

  const EarningsSummaryModel({
    required this.deliveryFee,
    required this.tip,
    required this.bonus,
    required this.total,
  });
}

class DeliveryMetricsModel {
  final String completionTime;
  final String distance;
  final double efficiency;

  const DeliveryMetricsModel({
    required this.completionTime,
    required this.distance,
    required this.efficiency,
  });
}
