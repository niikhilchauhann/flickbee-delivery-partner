import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
class AvailabilitySectionWidget extends StatelessWidget {
  AvailabilitySectionWidget({super.key});

  final ValueNotifier<Map<String, Map<String, bool>>> schedule =
      ValueNotifier({
    'Monday': {'Morning': true, 'Afternoon': true, 'Evening': false},
    'Tuesday': {'Morning': true, 'Afternoon': true, 'Evening': true},
    'Wednesday': {'Morning': true, 'Afternoon': false, 'Evening': false},
    'Thursday': {'Morning': true, 'Afternoon': true, 'Evening': true},
    'Friday': {'Morning': true, 'Afternoon': true, 'Evening': true},
    'Saturday': {'Morning': false, 'Afternoon': true, 'Evening': true},
    'Sunday': {'Morning': false, 'Afternoon': false, 'Evening': false},
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ValueListenableBuilder(
      valueListenable: schedule,
      builder: (context, value, _) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(3.w),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Availability Schedule",
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 2.h),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        final updated = Map.of(value);
                        updated.forEach(
                          (_, slots) => slots.updateAll((_, __) => true),
                        );
                        schedule.value = updated;
                      },
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        side: BorderSide(
                          color: theme.colorScheme.primary,
                          width: 0.3.w,
                        ),
                      ),
                      child: Text(
                        'Full Time',
                        style: theme.textTheme.labelMedium
                            ?.copyWith(color: theme.colorScheme.primary),
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        final updated = Map.of(value);
                        updated.forEach((_, slots) {
                          slots['Morning'] = true;
                          slots['Afternoon'] = true;
                          slots['Evening'] = false;
                        });
                        schedule.value = updated;
                      },
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        side: BorderSide(
                          color: theme.colorScheme.primary,
                          width: 0.3.w,
                        ),
                      ),
                      child: Text(
                        'Part Time',
                        style: theme.textTheme.labelMedium
                            ?.copyWith(color: theme.colorScheme.primary),
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        final updated = Map.of(value);
                        updated.forEach((day, slots) {
                          final enabled =
                              day == 'Saturday' || day == 'Sunday';
                          slots.updateAll((_, __) => enabled);
                        });
                        schedule.value = updated;
                      },
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        side: BorderSide(
                          color: theme.colorScheme.primary,
                          width: 0.3.w,
                        ),
                      ),
                      child: Text(
                        'Weekends Only',
                        style: theme.textTheme.labelMedium
                            ?.copyWith(color: theme.colorScheme.primary),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3.h),

              ...value.entries.map((dayEntry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dayEntry.key,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      children: dayEntry.value.entries.map((slot) {
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: 2.w),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    slot.key,
                                    style:
                                        theme.textTheme.bodyMedium,
                                  ),
                                ),
                                Switch(
                                  value: slot.value,
                                  onChanged: (v) {
                                    final updated = Map.of(value);
                                    updated[dayEntry.key]![slot.key] = v;
                                    schedule.value = updated;
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 2.h),
                  ],
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
