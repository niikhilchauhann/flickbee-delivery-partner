import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/exports.dart';
import '../../../core/global_widgets/custom_icon_widget.dart';

/// Route map preview widget showing delivery route
class RouteMapPreviewWidget extends StatelessWidget {
  final Map<String, dynamic> routeData;

  const RouteMapPreviewWidget({super.key, required this.routeData});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      height: 25.h,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3.w),
        child: Stack(
          children: [
            CustomImageWidget(
              imageUrl: routeData['mapPreviewUrl'] as String,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              semanticLabel:
                  'Map preview showing delivery route from store to customer location with distance markers',
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'directions',
                          color: Colors.white,
                          size: 18,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          routeData['totalDistance'] as String,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'access_time',
                          color: Colors.white,
                          size: 18,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          routeData['travelTime'] as String,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
