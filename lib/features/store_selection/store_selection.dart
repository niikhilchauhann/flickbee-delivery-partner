import 'package:flickbee_delivery_partner/core/app_structure.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/global_widgets/custom_icon_widget.dart';
import '../auth/login_screen.dart';
import '../order_details/order_pickup_model.dart';
import '../splash/navigation_logic.dart';
import 'widgets/store_card.dart';
import 'widgets/store_details.dart';

class StoreSelectionScreen extends StatelessWidget {
  StoreSelectionScreen({super.key});

  final TextEditingController _searchController = TextEditingController();

  final ValueNotifier<String> searchQuery = ValueNotifier('');
  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final ValueNotifier<StoreModel?> selectedStore = ValueNotifier(null);

  final List<StoreModel> allStores = _stores;

  static final List<StoreModel> _stores = [
    const StoreModel(
      id: 'store_001',
      name: 'FreshMart Downtown',
      address: '123 Main Street, Downtown District',
      pickupInstructions:
          'Use rear entrance parking lot. Show driver ID at gate.',
      latitude: 0,
      longitude: 0,
      distance: 2.3,
      operatingHours: '6:00 AM - 11:00 PM',
      currentOrders: 12,
      estimatedEarnings: '\$45-60/hour',
      contactNumber: '+1 (555) 123-4567',
      parkingInstructions:
          'Use rear entrance parking lot. Show driver ID at gate.',
      driverRating: 4.7,
      imageUrl: 'https://images.unsplash.com/photo-1471895131770-64cf5212f657',
      semanticLabel: 'FreshMart store',
      recentlySelected: true,
    ),
    // ⬅️ keep adding remaining stores exactly as before
  ];

  List<StoreModel> _filtered(String query) {
    if (query.isEmpty) return allStores;
    return allStores.where((s) {
      final q = query.toLowerCase();
      return s.name.toLowerCase().contains(q) ||
          s.address.toLowerCase().contains(q);
    }).toList();
  }

  List<StoreModel> _recent(List<StoreModel> stores) =>
      stores.where((s) => s.recentlySelected).toList();

  Future<void> _refresh() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;
  }

  Future<void> _selectStore(BuildContext context) async {
    final store = selectedStore.value;
    if (store == null) return;

    await DriverSession.setStoreSelected(store.id);
    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute(builder: (_) => AppStructure()),
      (_) => false,
    );
  }

  void _showDetails(BuildContext context, StoreModel store) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StoreDetailsBottomSheet(
        store: store,
        onSelectStore: () {
          Navigator.pop(context);
          selectedStore.value = store;
        },
      ),
    );
  }

  void _contactSupport(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Contacting support...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: theme.colorScheme.onSurface,
            size: 24,
          ),
          onPressed: () => Navigator.push(
            context,
            CupertinoPageRoute(builder: (context) => const LoginScreen()),
          ),
        ),
        title: Text('Select Store', style: theme.appBarTheme.titleTextStyle),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            /// SEARCH BAR (UNCHANGED)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: TextField(
                controller: _searchController,
                onChanged: (v) => searchQuery.value = v,
                decoration: InputDecoration(
                  hintText: 'Search by store name or address',
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12),
                    child: CustomIconWidget(
                      iconName: 'search',
                      color: theme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                  suffixIcon: ValueListenableBuilder<String>(
                    valueListenable: searchQuery,
                    builder: (_, q, __) => q.isNotEmpty
                        ? IconButton(
                            icon: CustomIconWidget(
                              iconName: 'clear',
                              color: theme.colorScheme.onSurfaceVariant,
                              size: 20,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              searchQuery.value = '';
                            },
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
              ),
            ),

            /// LIST
            Expanded(
              child: ValueListenableBuilder<bool>(
                valueListenable: isLoading,
                builder: (_, loading, __) {
                  if (loading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return ValueListenableBuilder<String>(
                    valueListenable: searchQuery,
                    builder: (_, query, __) {
                      final stores = _filtered(query);
                      final recent = _recent(stores);

                      if (stores.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomIconWidget(
                                iconName: 'store',
                                color: theme.colorScheme.onSurfaceVariant,
                                size: 64,
                              ),
                              SizedBox(height: 2.h),
                              const Text('No stores available'),
                              SizedBox(height: 3.h),
                              ElevatedButton.icon(
                                onPressed: () => _contactSupport(context),
                                icon: CustomIconWidget(
                                  iconName: 'support_agent',
                                  color: theme.colorScheme.onPrimary,
                                  size: 20,
                                ),
                                label: const Text('Contact Support'),
                              ),
                            ],
                          ),
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: _refresh,
                        child: ListView(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          children: [
                            if (recent.isNotEmpty && query.isEmpty) ...[
                              SizedBox(height: 2.h),
                              Text(
                                'Recently Selected',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 1.h),
                              ...recent.map(
                                (s) => StoreCardWidget(
                                  store: s,
                                  isSelected: selectedStore.value?.id == s.id,
                                  onTap: () => _showDetails(context, s),
                                  onSelect: () => selectedStore.value = s,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              const Divider(),
                            ],
                            ...stores.map(
                              (s) => StoreCardWidget(
                                store: s,
                                isSelected: selectedStore.value?.id == s.id,
                                onTap: () => _showDetails(context, s),
                                onSelect: () => selectedStore.value = s,
                              ),
                            ),
                            SizedBox(height: 10.h),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

      /// BOTTOM SHEET
      bottomSheet: ValueListenableBuilder<StoreModel?>(
        valueListenable: selectedStore,
        builder: (_, store, __) {
          if (store == null) return const SizedBox.shrink();

          return Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor,
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: ElevatedButton(
                onPressed: () => _selectStore(context),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 7.h),
                ),
                child: const Text('Select Store'),
              ),
            ),
          );
        },
      ),
    );
  }
}
