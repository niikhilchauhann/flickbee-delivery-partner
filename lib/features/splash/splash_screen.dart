import 'package:flickbee_delivery_partner/core/app_structure.dart';
import 'package:flickbee_delivery_partner/features/auth/login_screen.dart';
import 'package:flickbee_delivery_partner/features/store_selection/store_selection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/global_widgets/custom_icon_widget.dart';
import 'navigation_logic.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startBootstrap();
  }

  void _setupAnimations() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scale = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _controller.forward();
  }

  Future<void> _startBootstrap() async {
    try {
      await Future.wait([
        _checkAuthentication(),
        _loadCachedData(),
        _verifyLocationPermissions(),
        _fetchDeliveryConfig(),
        Future.delayed(const Duration(milliseconds: 2000)),
      ]);

      if (!mounted) return;

      final isAuthenticated = await _isDriverAuthenticated();
      final hasStore = await _hasAssignedStore();

      if (!mounted) return;

      if (isAuthenticated) {
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
            builder: (context) =>
                hasStore ? AppStructure() : StoreSelectionScreen(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(builder: (context) => LoginScreen()),
        );
      }
    } catch (_) {
      if (mounted) _showRetryDialog();
    }
  }

  Future<void> _checkAuthentication() async =>
      Future.delayed(const Duration(milliseconds: 500));

  Future<void> _loadCachedData() async =>
      Future.delayed(const Duration(milliseconds: 600));

  Future<void> _verifyLocationPermissions() async =>
      Future.delayed(const Duration(milliseconds: 400));

  Future<void> _fetchDeliveryConfig() async =>
      Future.delayed(const Duration(milliseconds: 700));

  Future<bool> _isDriverAuthenticated() async => DriverSession.isLoggedIn();

  Future<bool> _hasAssignedStore() async => DriverSession.hasStore();

  void _showRetryDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(
          'Connection Error',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Text(
          'Unable to initialize the app. Please check your internet connection and try again.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _startBootstrap();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.primaryContainer,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              FadeTransition(
                opacity: _fade,
                child: ScaleTransition(
                  scale: _scale,
                  child: Container(
                    width: 32.w,
                    height: 32.w,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onPrimary,
                      borderRadius: BorderRadius.circular(6.w),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: 'local_shipping',
                        color: theme.colorScheme.primary,
                        size: 18.w,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 3.h),
              FadeTransition(
                opacity: _fade,
                child: Text(
                  'DeliveryPartner',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              SizedBox(height: 1.h),
              FadeTransition(
                opacity: _fade,
                child: Text(
                  'Efficient Grocery Delivery',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onPrimary.withValues(alpha: 0.9),
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: 8.w,
                height: 8.w,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.onPrimary,
                  ),
                ),
              ),
              SizedBox(height: 6.h),
            ],
          ),
        ),
      ),
    );
  }
}
