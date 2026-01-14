import 'package:flutter/material.dart';

import '../navigation/order_model.dart';
import 'order_pickup_model.dart';
import 'widget/customer_info_widget.dart';
import 'widget/order_items_widget.dart';
import 'widget/order_status_timeline.dart';
import 'widget/payment_info.dart';
import 'widget/store_pickup.dart';

class OrderDetailsScreen extends StatelessWidget {
  OrderDetailsScreen({super.key});

  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final ValueNotifier<String> currentStatus = ValueNotifier('Accepted');

  final ValueNotifier<OrderDetailsModel> order = ValueNotifier(
    OrderDetailsModel(
      orderId: 'ORD-2026-001234',
      customerName: 'Sarah Johnson',
      customerPhone: '+1-555-0123',
      itemCount: 2,
      paymentMode: 'Cash on Delivery',
      totalAmount: '24.75',
      estimatedTime: '20 mins',
      deliveryAddress: '742 Evergreen Terrace, Springfield, IL 62701, USA',
      orderDate: '2026-01-11 10:30 AM',
      specialInstructions:
          'Please ring the doorbell twice. Leave at front door if no answer.',
      items: const [
        OrderItemModel(
          name: 'Organic Bananas',
          quantity: 2,
          price: 3.99,
          image: 'https://images.unsplash.com/photo-1675586677399-2dbd468cad2f',
          semanticLabel: 'Bananas',
          substitutionNote: 'If unavailable, substitute with regular bananas',
          isUnavailable: false,
        ),
        OrderItemModel(
          name: 'Whole Milk',
          quantity: 1,
          price: 4.49,
          image:
              'https://img.rocket.new/generatedImages/rocket_gen_img_1636156f2-1764672084085.png',
          semanticLabel: 'Milk',
          substitutionNote: '',
          isUnavailable: false,
        ),
      ],
      store: const StorePickupModel(
        name: 'Fresh Market Grocery',
        address: '123 Main Street, Springfield, IL 62701',
        pickupInstructions:
            'Enter through the back entrance. Show order number to staff.',
        latitude: 39.7817,
        longitude: -89.6501,
        distance: 2.3,
      ),
      payment: const PaymentInfoModel(
        method: 'Cash on Delivery',
        totalAmount: 24.75,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: () async {
        isLoading.value = true;
        await Future.delayed(const Duration(seconds: 1));
        isLoading.value = false;
      },
      child: ValueListenableBuilder<bool>(
        valueListenable: isLoading,
        builder: (_, loading, __) {
          if (loading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SafeArea(
              child: ValueListenableBuilder<OrderDetailsModel>(
                valueListenable: order,
                builder: (_, orderData, __) {
                  return Column(
                    children: [
                      const SizedBox(height: 8),
                      ValueListenableBuilder<String>(
                        valueListenable: currentStatus,
                        builder: (_, status, __) =>
                            OrderStatusTimelineWidget(currentStatus: status),
                      ),
                      CustomerInfoWidget(
                        orderData: {
                          'orderNumber': orderData.orderId,
                          'orderDate': orderData.orderDate,
                          'customerName': orderData.customerName,
                          'phoneNumber': orderData.customerPhone,
                          'deliveryAddress': orderData.deliveryAddress,
                          'specialInstructions': orderData.specialInstructions,
                        },
                      ),
                      OrderItemsWidget(
                        items: orderData.items
                            .map(
                              (e) => {
                                'name': e.name,
                                'quantity': e.quantity,
                                'price': e.price,
                                'image': e.image,
                                'semanticLabel': e.semanticLabel,
                                'substitutionNote': e.substitutionNote,
                                'isUnavailable': e.isUnavailable,
                              },
                            )
                            .toList(),
                        onItemAction: (index, action) {
                          final updatedItems = List<OrderItemModel>.from(
                            orderData.items,
                          );

                          if (action == 'unavailable') {
                            updatedItems[index] = updatedItems[index].copyWith(
                              isUnavailable: true,
                            );
                          }

                          order.value = orderData.copyWith(items: updatedItems);
                        },
                      ),
                      StorePickupWidget(
                        store: StorePickupModel(
                          name: 'name',
                          address: 'address',
                          pickupInstructions: 'pickupInstructions',
                          latitude: 20,
                          longitude: 20,
                          distance: 20,
                        ),
                      ),
                      PaymentInfoWidget(
                        paymentData: {
                          'method': orderData.payment?.method,
                          'totalAmount': orderData.payment?.totalAmount,
                        },
                      ),
                      const SizedBox(height: 100),
                      Container(
                        padding: const EdgeInsets.all(16),
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
                          child: ValueListenableBuilder<String>(
                            valueListenable: currentStatus,
                            builder: (_, status, __) => SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (status == 'Accepted') {
                                    currentStatus.value = 'Picking Up';
                                  } else if (status == 'Picking Up') {
                                    currentStatus.value = 'En Route';
                                    Navigator.pushNamed(
                                      context,
                                      '/navigation-tracking-screen',
                                    );
                                  } else if (status == 'En Route') {
                                    Navigator.pushNamed(
                                      context,
                                      '/payment-confirmation-screen',
                                    );
                                  }
                                },
                                child: Text(
                                  status == 'Accepted'
                                      ? 'Start Pickup'
                                      : status == 'Picking Up'
                                      ? 'Begin Delivery'
                                      : 'Mark Delivered',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
