import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/global_widgets/custom_icon_widget.dart';

class CustomerRatingWidget extends StatelessWidget {
  final Function(int rating, String feedback) onSubmitRating;

  CustomerRatingWidget({super.key, required this.onSubmitRating});

  // int _selectedRating = 0;
  final TextEditingController _feedbackController = TextEditingController();

  final ValueNotifier<int> _selectedRating = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rate Your Experience',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'How was your delivery experience?',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 3.h),
          ValueListenableBuilder(
            valueListenable: _selectedRating,
            builder: (context, value, child) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final starIndex = index + 1;
                return GestureDetector(
                  onTap: () {
                    _selectedRating.value = starIndex;
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 1.w),
                    child: CustomIconWidget(
                      iconName: value >= starIndex
                          ? 'star'
                          : 'star_border',
                      color: value >= starIndex
                          ? const Color(0xFFFBBF24)
                          : theme.colorScheme.outline,
                      size: 10.w,
                    ),
                  ),
                );
              }),
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'Additional Feedback (Optional)',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          TextField(
            controller: _feedbackController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Share your thoughts about this delivery...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.3),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: theme.colorScheme.primary,
                  width: 2,
                ),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedRating.value > 0
                  ? () {
                      onSubmitRating(
                        _selectedRating.value,
                        _feedbackController.text,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Thank you for your feedback!'),
                          backgroundColor: const Color(0xFF059669),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Submit Rating',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
