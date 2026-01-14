import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../payment/payment_confirmation_screen.dart';
import 'order_model.dart';
import 'widgets/completion_button.dart';
import 'widgets/delivery_progress.dart';
import 'widgets/map_controls.dart';
import 'widgets/turn_directions.dart';

class NavigationTrackingScreen extends StatefulWidget {
  const NavigationTrackingScreen({super.key});

  @override
  State<NavigationTrackingScreen> createState() =>
      _NavigationTrackingScreenState();
}

class _NavigationTrackingScreenState extends State<NavigationTrackingScreen> {
  GoogleMapController? mapController;
  StreamSubscription<Position>? positionStream;
  Timer? locationTimer;

  final ValueNotifier<Position?> currentPosition = ValueNotifier(null);
  final ValueNotifier<bool> isSatelliteView = ValueNotifier(false);
  final ValueNotifier<bool> isPickedUp = ValueNotifier(false);
  final ValueNotifier<bool> isOutForDelivery = ValueNotifier(false);
  final ValueNotifier<bool> isNearDestination = ValueNotifier(false);

  final LatLng storeLocation = const LatLng(37.7749, -122.4194);
  final LatLng customerLocation = const LatLng(37.7849, -122.4094);

  final String currentInstruction = "Head north on Main Street";
  final String nextInstruction = "Turn right onto Oak Avenue";
  final String distanceToTurn = "0.3 mi";

  late final OrderDetailsModel order;

  final Set<Marker> markers = {};
  final Set<Polyline> polylines = {
    Polyline(
      polylineId: const PolylineId('route'),
      points: const [LatLng(37.7749, -122.4194), LatLng(37.7849, -122.4094)],
      color: Color(0xFF2563EB),
      width: 5,
      patterns: [PatternItem.dash(20), PatternItem.gap(10)],
    ),
  };

  @override
  void initState() {
    super.initState();

    order = const OrderDetailsModel(
      orderId: "5678",
      customerName: "Sarah Johnson",
      customerPhone: "+1 (555) 234-5678",
      itemCount: 8,
      paymentMode: "Cash on Delivery",
      totalAmount: "\$87.50",
      estimatedTime: "12 mins",

      deliveryAddress: "456 Oak Street, Apt 3B, Springfield, IL 62701",
      items: [],
    );

    markers.addAll([
      Marker(
        markerId: const MarkerId('store'),
        position: storeLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: const InfoWindow(
          title: 'Store Location',
          snippet: 'Pickup point',
        ),
      ),
      Marker(
        markerId: const MarkerId('customer'),
        position: customerLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(
          title: order.customerName,
          snippet: 'Delivery destination',
        ),
      ),
    ]);

    _initLocation();
  }

  @override
  void dispose() {
    positionStream?.cancel();
    locationTimer?.cancel();
    mapController?.dispose();
    super.dispose();
  }

  Future<void> _initLocation() async {
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    currentPosition.value = position;

    positionStream =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 10,
          ),
        ).listen((pos) {
          currentPosition.value = pos;
          final d = Geolocator.distanceBetween(
            pos.latitude,
            pos.longitude,
            customerLocation.latitude,
            customerLocation.longitude,
          );
          isNearDestination.value = d <= 100;
        });

    locationTimer = Timer.periodic(const Duration(seconds: 30), (_) {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ValueListenableBuilder<Position?>(
          valueListenable: currentPosition,
          builder: (_, pos, __) {
            return ValueListenableBuilder<bool>(
              valueListenable: isSatelliteView,
              builder: (_, satellite, __) {
                return GoogleMap(
                  onMapCreated: (c) => mapController = c,
                  initialCameraPosition: CameraPosition(
                    target: pos != null
                        ? LatLng(pos.latitude, pos.longitude)
                        : storeLocation,
                    zoom: 15,
                  ),
                  mapType: satellite ? MapType.satellite : MapType.normal,
                  markers: markers,
                  polylines: polylines,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  compassEnabled: true,
                  trafficEnabled: true,
                );
              },
            );
          },
        ),

        TurnDirectionsWidget(
          currentInstruction: currentInstruction,
          nextInstruction: nextInstruction,
          distanceToTurn: distanceToTurn,
        ),

        MapControlsWidget(
          onCenterLocation: () {
            final pos = currentPosition.value;
            if (pos != null && mapController != null) {
              mapController!.animateCamera(
                CameraUpdate.newLatLngZoom(
                  LatLng(pos.latitude, pos.longitude),
                  15,
                ),
              );
            }
          },
          onToggleMapType: () => isSatelliteView.value = !isSatelliteView.value,
          onOpenExternalNav: () {},
          isSatelliteView: isSatelliteView.value,
        ),

        Align(
          alignment: Alignment.bottomCenter,
          child: DeliveryProgressWidget(
            order: order,
            onContactCustomer: () {},
            onMarkPickedUp: () => isPickedUp.value = true,
            onMarkOutForDelivery: () => isOutForDelivery.value = true,
            isPickedUp: isPickedUp.value,
            isOutForDelivery: isOutForDelivery.value,
          ),
        ),

        ValueListenableBuilder<bool>(
          valueListenable: isNearDestination,
          builder: (_, near, __) {
            return CompletionButtonWidget(
              isNearDestination: near,
              onComplete: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>  PaymentConfirmationScreen(),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
