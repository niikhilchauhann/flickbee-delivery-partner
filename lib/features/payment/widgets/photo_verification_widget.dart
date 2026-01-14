import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../../core/exports.dart';
import '../../../core/global_widgets/custom_icon_widget.dart';

/// Photo verification widget for delivery proof
/// Captures package placement or customer receipt photo
class PhotoVerificationWidget extends StatelessWidget {
  final ValueChanged<XFile?> onPhotoChanged;

  PhotoVerificationWidget({super.key, required this.onPhotoChanged}) {
    _initializeCamera();
  }

  final CameraController? _cameraController = null;
  final ImagePicker _imagePicker = ImagePicker();

  final ValueNotifier<CameraController?> _controller =
      ValueNotifier<CameraController?>(null);

  final ValueNotifier<bool> _isCameraInitialized = ValueNotifier<bool>(false);

  final ValueNotifier<XFile?> _capturedImage = ValueNotifier<XFile?>(null);

  Future<void> _initializeCamera() async {
    try {
      if (!await _requestCameraPermission()) return;

      final cameras = await availableCameras();
      if (cameras.isEmpty) return;

      final camera = kIsWeb
          ? cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.front,
              orElse: () => cameras.first,
            )
          : cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.back,
              orElse: () => cameras.first,
            );

      final controller = CameraController(
        camera,
        kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high,
      );

      await controller.initialize();

      try {
        await controller.setFocusMode(FocusMode.auto);
        if (!kIsWeb) {
          await controller.setFlashMode(FlashMode.auto);
        }
      } catch (_) {}

      _controller.value = controller;
      _isCameraInitialized.value = true;

      // Auto-dispose when GC runs
      Finalizer((CameraController c) => c.dispose()).attach(this, controller);
    } catch (e) {
      debugPrint('Camera initialization error: $e');
    }
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  Future<void> _capturePhoto() async {
    final controller = _controller.value;
    if (controller == null || !controller.value.isInitialized) return;

    try {
      final photo = await controller.takePicture();
      _capturedImage.value = photo;
      onPhotoChanged(photo);
    } catch (e) {
      debugPrint('Photo capture error: $e');
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final image = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        _capturedImage.value = image;
        onPhotoChanged(image);
      }
    } catch (e) {
      debugPrint('Gallery pick error: $e');
    }
  }

  void _retakePhoto() {
    _capturedImage.value = null;
    onPhotoChanged(null);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ValueListenableBuilder<XFile?>(
      valueListenable: _capturedImage,
      builder: (context, capturedImage, _) {
        return ValueListenableBuilder<bool>(
          valueListenable: _isCameraInitialized,
          builder: (context, isReady, __) {
            final controller = _controller.value;

            return Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(3.w),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Delivery Proof Photo',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),

                  /// PREVIEW / IMAGE (INLINE)
                  Container(
                    width: double.infinity,
                    height: 30.h,
                    decoration: BoxDecoration(
                      color: capturedImage == null && !isReady
                          ? theme.colorScheme.surfaceContainerHighest
                          : null,
                      borderRadius: BorderRadius.circular(2.w),
                      border: Border.all(
                        color: capturedImage != null
                            ? const Color(0xFF059669)
                            : theme.colorScheme.outline.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2.w),
                      child: capturedImage != null
                          ? (kIsWeb
                                ? Image.network(
                                    capturedImage.path,
                                    fit: BoxFit.cover,
                                  )
                                : CustomImageWidget(
                                    imageUrl: capturedImage.path,
                                    width: double.infinity,
                                    height: 30.h,
                                    fit: BoxFit.cover,
                                    semanticLabel:
                                        'Delivery proof photo showing package placement',
                                  ))
                          : (!isReady || controller == null
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : CameraPreview(controller)),
                    ),
                  ),

                  SizedBox(height: 2.h),

                  /// ACTION BUTTONS (INLINE)
                  capturedImage != null
                      ? Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _retakePhoto,
                                icon: CustomIconWidget(
                                  iconName: 'refresh',
                                  color: theme.colorScheme.primary,
                                  size: 5.w,
                                ),
                                label: const Text('Retake'),
                              ),
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _capturePhoto,
                                icon: CustomIconWidget(
                                  iconName: 'camera_alt',
                                  color: theme.colorScheme.onPrimary,
                                  size: 5.w,
                                ),
                                label: const Text('Capture Photo'),
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _pickFromGallery,
                                icon: CustomIconWidget(
                                  iconName: 'photo_library',
                                  color: theme.colorScheme.primary,
                                  size: 5.w,
                                ),
                                label: const Text('Gallery'),
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
