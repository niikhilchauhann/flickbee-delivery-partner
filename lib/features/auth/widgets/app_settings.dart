import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../core/global_widgets/custom_icon_widget.dart';
import '../domain/settings_model.dart';
class AppSettingsWidget extends StatelessWidget {
  AppSettingsWidget({super.key});

  final ValueNotifier<AppSettingState> state =
      ValueNotifier(const AppSettingState(
    locationSharing: true,
    navigationApp: 'Google Maps',
    language: 'English',
  ));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ValueListenableBuilder(
      valueListenable: state,
      builder: (_, value, __) {
        return Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(3.w),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'App Settings',
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 2.h),

              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'location_on',
                    color: theme.colorScheme.primary,
                    size: 6.w,
                  ),
                  SizedBox(width: 3.w),
                  const Expanded(child: Text('Location Sharing')),
                  Switch(
                    value: value.locationSharing,
                    onChanged: (v) =>
                        state.value = value.copyWith(locationSharing: v),
                  ),
                ],
              ),
              Divider(height: 3.h),

              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'navigation',
                    color: theme.colorScheme.primary,
                    size: 6.w,
                  ),
                  SizedBox(width: 3.w),
                  const Expanded(child: Text('Navigation App')),
                  DropdownButton<String>(
                    value: value.navigationApp,
                    underline: const SizedBox(),
                    items: ['Google Maps', 'Waze', 'Apple Maps']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) =>
                        state.value = value.copyWith(navigationApp: v),
                  ),
                ],
              ),
              Divider(height: 3.h),

              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'language',
                    color: theme.colorScheme.primary,
                    size: 6.w,
                  ),
                  SizedBox(width: 3.w),
                  const Expanded(child: Text('Language')),
                  DropdownButton<String>(
                    value: value?.language,
                    underline: const SizedBox(),
                    items: ['English', 'Spanish', 'French']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) =>
                        state.value = value.copyWith(language: v),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

