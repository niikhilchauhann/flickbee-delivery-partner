import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:sizer/sizer.dart';

import '../../../core/global_widgets/custom_icon_widget.dart';

/// Customer signature capture widget
/// Allows touch drawing with clear/retry functionality
class SignatureCaptureWidget extends StatefulWidget {
  final Function(bool) onSignatureChanged;

  const SignatureCaptureWidget({super.key, required this.onSignatureChanged});

  @override
  State<SignatureCaptureWidget> createState() => _SignatureCaptureWidgetState();
}

class _SignatureCaptureWidgetState extends State<SignatureCaptureWidget> {
  late SignatureController _signatureController;
  bool _hasSignature = false;

  @override
  void initState() {
    super.initState();
    _signatureController = SignatureController(
      penStrokeWidth: 2,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
    );

    _signatureController.addListener(() {
      final hasPoints = _signatureController.points.isNotEmpty;
      if (hasPoints != _hasSignature) {
        setState(() {
          _hasSignature = hasPoints;
          widget.onSignatureChanged(hasPoints);
        });
      }
    });
  }

  @override
  void dispose() {
    _signatureController.dispose();
    super.dispose();
  }

  void _clearSignature() {
    _signatureController.clear();
    setState(() {
      _hasSignature = false;
      widget.onSignatureChanged(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Customer Signature',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (_hasSignature)
                TextButton.icon(
                  onPressed: _clearSignature,
                  icon: CustomIconWidget(
                    iconName: 'refresh',
                    color: theme.colorScheme.primary,
                    size: 5.w,
                  ),
                  label: Text('Clear'),
                  style: TextButton.styleFrom(
                    foregroundColor: theme.colorScheme.primary,
                  ),
                ),
            ],
          ),
          SizedBox(height: 2.h),
          Container(
            width: double.infinity,
            height: 25.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2.w),
              border: Border.all(
                color: _hasSignature
                    ? const Color(0xFF059669)
                    : theme.colorScheme.outline.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2.w),
              child: Signature(
                controller: _signatureController,
                backgroundColor: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Please sign above to confirm delivery',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
