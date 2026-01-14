import 'package:flutter/material.dart';

import '../../../core/global_widgets/custom_icon_widget.dart';


/// Widget containing floating action buttons for map controls
class MapControlsWidget extends StatelessWidget {
  final VoidCallback onCenterLocation;
  final VoidCallback onToggleMapType;
  final VoidCallback onOpenExternalNav;
  final bool isSatelliteView;

  const MapControlsWidget({
    super.key,
    required this.onCenterLocation,
    required this.onToggleMapType,
    required this.onOpenExternalNav,
    required this.isSatelliteView,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Positioned(
      right: 16,
      top: 100,
      child: Column(
        children: [
          // Center on location button
          FloatingActionButton(
            heroTag: 'center_location',
            onPressed: onCenterLocation,
            backgroundColor: theme.colorScheme.surface,
            foregroundColor: theme.colorScheme.primary,
            elevation: 4,
            child: CustomIconWidget(
              iconName: 'my_location',
              size: 24,
              color: theme.colorScheme.primary,
            ),
          ),

          const SizedBox(height: 12),

          // Toggle map type button
          FloatingActionButton(
            heroTag: 'toggle_map',
            onPressed: onToggleMapType,
            backgroundColor: theme.colorScheme.surface,
            foregroundColor: theme.colorScheme.primary,
            elevation: 4,
            child: CustomIconWidget(
              iconName: isSatelliteView ? 'map' : 'satellite',
              size: 24,
              color: theme.colorScheme.primary,
            ),
          ),

          const SizedBox(height: 12),

          // Open external navigation button
          FloatingActionButton(
            heroTag: 'external_nav',
            onPressed: onOpenExternalNav,
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            elevation: 4,
            child: CustomIconWidget(
              iconName: 'navigation',
              size: 24,
              color: theme.colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
