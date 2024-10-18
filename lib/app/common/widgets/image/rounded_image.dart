import 'package:flutter/material.dart';
import 'package:laundry_mobile/app/utils/constants/colors.dart';
import 'package:laundry_mobile/app/utils/constants/enums.dart';
import 'package:laundry_mobile/app/utils/constants/sizes.dart';
import 'package:laundry_mobile/app/utils/helpers/helper_functions.dart';
import 'dart:io';
import 'dart:typed_data';

class TRoundedImage extends StatelessWidget {
  const TRoundedImage({
    super.key,
    this.width,
    this.height,
    required this.image,
    required this.imageType,
    this.applyImageRadius = true,
    this.border,
    this.backgroundColor,
    this.fit = BoxFit.cover,
    this.padding,
    this.isNetworkImage = false,
    this.onPressed,
    this.borderRadius = TSizes.md,
    this.backgroundOpacity = 1.0,
  });

  final double? width, height;
  final dynamic image;
  final ImageType imageType;
  final bool applyImageRadius;
  final BoxBorder? border;
  final Color? backgroundColor;
  final BoxFit fit;
  final EdgeInsetsGeometry? padding;
  final bool isNetworkImage;
  final VoidCallback? onPressed;
  final double borderRadius;
  final double backgroundOpacity;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          border: border,
          
          color: backgroundColor ??
              (isDark ? TColors.darkGrey : Colors.transparent),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: ClipRRect(
          borderRadius: applyImageRadius
              ? BorderRadius.circular(borderRadius)
              : BorderRadius.zero,
          child: _buildImageWidget(),
        ),
      ),
    );
  }

  Widget _buildImageWidget() {
    Widget imageWidget;

    if (imageType == ImageType.network) {
      imageWidget = _buildNetworkImage();
    } else if (imageType == ImageType.memory) {
      imageWidget = _buildMemoryImage();
    } else if (imageType == ImageType.file) {
      imageWidget = _buildFileImage();
    } else if (imageType == ImageType.asset) {
      imageWidget = _buildAssetImage();
    } else {
      throw Exception('Unsupported image type');
    }

    return imageWidget;
  }

  Widget _buildNetworkImage() {
    return Image.network(
      image as String,
      fit: fit,
    );
  }

  Widget _buildMemoryImage() {
    return Image.memory(
      Uint8List.fromList((image as String).codeUnits),
      fit: fit,
    );
  }

  Widget _buildFileImage() {
    return Image.file(
      File(image as String),
      fit: fit,
    );
  }

  Widget _buildAssetImage() {
    return Image.asset(
      image as String,
      fit: fit,
    );
  }
}
