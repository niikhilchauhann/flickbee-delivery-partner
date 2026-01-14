// import 'dart:developer';
// import 'dart:io';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:shimmer/shimmer.dart';

// import '../../config/colors/app_colors.dart';

// class CustomImageWidget extends StatelessWidget {
//   const CustomImageWidget({
//     super.key,
//     required this.mediaPath,
//     this.height,
//     this.width,
//     this.fit = BoxFit.cover,
//     this.borderRadius = 16,
//     this.color,
//     this.errorWidget,
//     this.loadingWidget,
//   });

//   final String mediaPath;
//   final double? height;
//   final double? width;
//   final BoxFit fit;
//   final double borderRadius;
//   final Color? color;
//   final Widget? errorWidget;
//   final Widget? loadingWidget;

//   bool get isVideo =>
//       mediaPath.toLowerCase().endsWith('.mp4') ||
//       mediaPath.toLowerCase().endsWith('.mov');

//   bool get isNetwork => mediaPath.startsWith('http');
//   bool get isAsset => mediaPath.startsWith('assets/');
//   bool get isFile => File(mediaPath).existsSync();

//   @override
//   Widget build(BuildContext context) {
//     if (mediaPath.isEmpty) return _buildErrorWidget();

//     // if (isVideo) {
//     //   return GestureDetector(
//     //     onTap: () {
//     //       showDialog(
//     //         context: context,
//     //         builder: (_) => VideoPopupScreen(videoPath: mediaPath),
//     //       );
//     //     },
//     //     child: Stack(
//     //       alignment: Alignment.center,
//     //       children: [
//     //         ClipRRect(
//     //           borderRadius: BorderRadius.circular(borderRadius),
//     //           child: Image.asset(
//     //             'assets/images/video_placeholder.jpg',
//     //             height: height,
//     //             width: width,
//     //             fit: fit,
//     //           ),
//     //         ),
//     //         const CircleAvatar(
//     //           radius: 24,
//     //           child: Icon(Icons.play_arrow, color: Colors.white, size: 32),
//     //         ),
//     //       ],
//     //     ),
//     //   );
//     // }

//     if (isNetwork) {
//       return ClipRRect(
//         borderRadius: BorderRadius.circular(borderRadius),
//         child: CachedNetworkImage(
//           imageUrl: mediaPath,
//           height: height,
//           width: width,
//           fit: fit,
//           color: color,
//           errorWidget: (_, __, ___) => errorWidget ?? _buildErrorWidget(),
//           placeholder: (_, __) => loadingWidget ?? _buildLoadingWidget(),
//         ),
//       );
//     }

//     if (isAsset) {
//       return ClipRRect(
//         borderRadius: BorderRadius.circular(borderRadius),
//         child: Image.asset(
//           mediaPath,
//           height: height,
//           width: width,
//           fit: fit,
//           errorBuilder: (_, __, ___) => errorWidget ?? _buildErrorWidget(),
//         ),
//       );
//     }

//     if (isFile) {
//       return ClipRRect(
//         borderRadius: BorderRadius.circular(borderRadius),
//         child: Image.file(
//           File(mediaPath),
//           height: height,
//           width: width,
//           fit: fit,
//           errorBuilder: (_, error, ___) {
//             log(error.toString());
//             return _buildErrorWidget();
//           },
//         ),
//       );
//     }

//     return _buildErrorWidget();
//   }

//   Widget _buildErrorWidget() => Container(
//     height: height,
//     width: width,
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(borderRadius),
//       color: Colors.grey,
//     ),
//     child: const Icon(Icons.error_outline, color: AppColors.darkGreen),
//   );

//   Widget _buildLoadingWidget() => Shimmer.fromColors(
//     baseColor: Colors.grey,
//     highlightColor: Colors.white,
//     child: Container(
//       height: height,
//       width: width,
//       decoration: BoxDecoration(
//         color: Colors.grey,
//         borderRadius: BorderRadius.circular(borderRadius),
//       ),
//     ),
//   );
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
extension ImageTypeExtension on String {
  ImageType get imageType {
    if (startsWith('http') || startsWith('https')) {
      return ImageType.network;
    } else if (endsWith('.svg')) {
      return ImageType.svg;
    } else if (startsWith('file: //')) {
      return ImageType.file;
    } else {
      return ImageType.png;
    }
  }
}

enum ImageType { svg, png, network, file, unknown }

// ignore_for_file: must_be_immutable
class CustomImageWidget extends StatelessWidget {
  const CustomImageWidget({super.key, 
    this.imageUrl,
    this.height,
    this.width,
    this.color,
    this.fit,
    this.alignment,
    this.onTap,
    this.radius,
    this.margin,
    this.border,
    this.placeHolder = 'assets/images/no-image.jpg',
    this.errorWidget,
    this.semanticLabel,
  });

  ///[imageUrl] is required parameter for showing image
  final String? imageUrl;

  final double? height;

  final double? width;

  final BoxFit? fit;

  final String placeHolder;

  final Color? color;

  final Alignment? alignment;

  final VoidCallback? onTap;

  final BorderRadius? radius;

  final EdgeInsetsGeometry? margin;

  final BoxBorder? border;

  /// Optional widget to show when the image fails to load.
  /// If null, a default asset image is shown.
  final Widget? errorWidget;

  /// Semantic label for the image to improve accessibility
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(alignment: alignment!, child: _buildWidget())
        : _buildWidget();
  }

  Widget _buildWidget() {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: InkWell(onTap: onTap, child: _buildCircleImage()),
    );
  }

  ///build the image with border radius
  dynamic _buildCircleImage() {
    if (radius != null) {
      return ClipRRect(
        borderRadius: radius ?? BorderRadius.zero,
        child: _buildImageWithBorder(),
      );
    } else {
      return _buildImageWithBorder();
    }
  }

  ///build the image with border and border radius style
  Widget _buildImageWithBorder() {
    if (border != null) {
      return Container(
        decoration: BoxDecoration(border: border, borderRadius: radius),
        child: _buildImageView(),
      );
    } else {
      return _buildImageView();
    }
  }

  Widget _buildImageView() {
    if (imageUrl != null) {
      switch (imageUrl!.imageType) {
        case ImageType.svg:
          return SizedBox(
            height: height,
            width: width,
            child: SvgPicture.asset(
              imageUrl!,
              height: height,
              width: width,
              fit: fit ?? BoxFit.contain,
              colorFilter: color != null
                  ? ColorFilter.mode(
                      color ?? Colors.transparent,
                      BlendMode.srcIn,
                    )
                  : null,
              semanticsLabel: semanticLabel,
            ),
          );
        case ImageType.file:
          return Image.file(
            File(imageUrl!),
            height: height,
            width: width,
            fit: fit ?? BoxFit.cover,
            color: color,
            semanticLabel: semanticLabel,
          );
        case ImageType.network:
          return CachedNetworkImage(
            height: height,
            width: width,
            fit: fit,
            imageUrl: imageUrl!,
            color: color,
            placeholder: (context, url) => SizedBox(
              height: 30,
              width: 30,
              child: LinearProgressIndicator(
                color: Colors.grey.shade200,
                backgroundColor: Colors.grey.shade100,
              ),
            ),
            errorWidget: (context, url, error) =>
                errorWidget ??
                Image.asset(
                  placeHolder,
                  height: height,
                  width: width,
                  fit: fit ?? BoxFit.cover,
                  semanticLabel: semanticLabel,
                ),
          );
        case ImageType.png:
        default:
          return Image.asset(
            imageUrl!,
            height: height,
            width: width,
            fit: fit ?? BoxFit.cover,
            color: color,
            semanticLabel: semanticLabel,
          );
      }
    }
    return SizedBox();
  }
}
