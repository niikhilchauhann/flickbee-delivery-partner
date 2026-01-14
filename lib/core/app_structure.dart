import 'package:flutter/material.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';

import '../features/home/driver_home.dart';
import '../features/incoming_request/incoming_req.dart';
import '../features/order_details/order_details_screen.dart';
import '../features/navigation/navigation_tracking.dart';
import '../features/auth/profile_screen.dart';
import 'exports.dart';

class AppStructure extends StatelessWidget {
  AppStructure({super.key});

  final ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);

  final List<Widget> _screens = [
     DriverHomeScreenInitialPage(),
     IncomingOrderRequestScreen(),
     OrderDetailsScreen(),
    // const NavigationTrackingScreen(),
    SizedBox(),
    ProfileAndAvailabilityScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _currentIndex,
      builder: (context, index, _) {
        return Scaffold(
          body: IndexedStack(index: index, children: _screens),
          bottomNavigationBar: SizedBox(
            height: 75,
            child: CustomNavigationBar(
              currentIndex: index,
              onTap: (i) => _currentIndex.value = i,
              backgroundColor: AppColors.white,
              selectedColor: AppColors.black,
              unSelectedColor: AppColors.black.withValues(alpha: 0.5),
              strokeColor: AppColors.primaryAppColor.withValues(alpha: 0.1),
              elevation: 4,
              items: _navItems(index),
            ),
          ),
        );
      },
    );
  }

  List<CustomNavigationBarItem> _navItems(int index) {
    TextStyle textStyle(int i) => AppTextTheme.size12Normal.copyWith(
      height: 1.6,
      color: index == i
          ? AppColors.black
          : AppColors.black.withValues(alpha: 0.5),
    );

    return [
      CustomNavigationBarItem(
        icon: const Icon(Icons.home_filled),
        title: Text('Home', style: textStyle(0)),
      ),
      CustomNavigationBarItem(
        icon: const Icon(Icons.call_missed_outgoing),
        title: Text('Requests', style: textStyle(1)),
      ),
      CustomNavigationBarItem(
        icon: const CustomRoundButton(
          btnColor: AppColors.primaryAppColor,
          iconColor: AppColors.white,
          icon: Icons.bolt,
        ),
        title: Text('Orders', style: textStyle(2).copyWith(height: 2)),
      ),
      CustomNavigationBarItem(
        icon: const Icon(Icons.navigation),
        title: Text('Navigation', style: textStyle(3)),
      ),
      CustomNavigationBarItem(
        icon: const Icon(Icons.person),
        title: Text('Profile', style: textStyle(4)),
      ),
    ];
  }
}
