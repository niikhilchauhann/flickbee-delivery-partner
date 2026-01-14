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
class PhotoVerificationWidget extends StatefulWidget {
  final Function(XFile?) onPhotoChanged;

  const PhotoVerificationWidget({super.key, required this.onPhotoChanged});

  @override
  State<PhotoVerificationWidget> createState() =>
      _PhotoVerificationWidgetState();
}

class _PhotoVerificationWidgetState extends State<PhotoVerificationWidget> {
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  XFile? _capturedImage;
  bool _isCameraInitialized = false;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      if (!await _requestCameraPermission()) {
        return;
      }

      _cameras = await availableCameras();
      if (_cameras.isEmpty) return;

      final camera = kIsWeb
          ? _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.front,
              orElse: () => _cameras.first,
            )
          : _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.back,
              orElse: () => _cameras.first,
            );

      _cameraController = CameraController(
        camera,
        kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high,
      );

      await _cameraController!.initialize();
      await _applySettings();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Camera initialization error: $e');
    }
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  Future<void> _applySettings() async {
    if (_cameraController == null) return;
    try {
      await _cameraController!.setFocusMode(FocusMode.auto);
    } catch (e) {
      debugPrint('Focus mode error: $e');
    }
    if (!kIsWeb) {
      try {
        await _cameraController!.setFlashMode(FlashMode.auto);
      } catch (e) {
        debugPrint('Flash mode error: $e');
      }
    }
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      final XFile photo = await _cameraController!.takePicture();
      setState(() {
        _capturedImage = photo;
      });
      widget.onPhotoChanged(photo);
    } catch (e) {
      debugPrint('Photo capture error: $e');
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );
      if (image != null) {
        setState(() {
          _capturedImage = image;
        });
        widget.onPhotoChanged(image);
      }
    } catch (e) {
      debugPrint('Gallery pick error: $e');
    }
  }

  void _retakePhoto() {
    setState(() {
      _capturedImage = null;
    });
    widget.onPhotoChanged(null);
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
          Text(
            'Delivery Proof Photo',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          _capturedImage != null
              ? _buildCapturedImage(theme)
              : _buildCameraPreview(theme),
          SizedBox(height: 2.h),
          _buildActionButtons(theme),
        ],
      ),
    );
  }

  Widget _buildCameraPreview(ThemeData theme) {
    if (!_isCameraInitialized || _cameraController == null) {
      return Container(
        width: double.infinity,
        height: 30.h,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(2.w),
        ),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Container(
      width: double.infinity,
      height: 30.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2.w),
        child: CameraPreview(_cameraController!),
      ),
    );
  }

  Widget _buildCapturedImage(ThemeData theme) {
    return Container(
      width: double.infinity,
      height: 30.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(color: const Color(0xFF059669), width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2.w),
        child: kIsWeb
            ? Image.network(_capturedImage!.path, fit: BoxFit.cover)
            : CustomImageWidget(
                imageUrl: _capturedImage!.path,
                width: double.infinity,
                height: 30.h,
                fit: BoxFit.cover,
                semanticLabel: 'Delivery proof photo showing package placement',
              ),
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme) {
    if (_capturedImage != null) {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _retakePhoto,
              icon: CustomIconWidget(
                iconName: 'refresh',
                color: theme.colorScheme.primary,
                size: 5.w,
              ),
              label: Text('Retake'),
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _capturePhoto,
            icon: CustomIconWidget(
              iconName: 'camera_alt',
              color: theme.colorScheme.onPrimary,
              size: 5.w,
            ),
            label: Text('Capture Photo'),
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
            label: Text('Gallery'),
          ),
        ),
      ],
    );
  }
}
