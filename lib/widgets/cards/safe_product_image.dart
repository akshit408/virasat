import 'dart:io';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/craft_image_helper.dart';

/// Priority-based safe image loader for VIRASAT product and craft cards.
/// Priority 1: Product uploaded image path / imageUrl.
/// Priority 2: Local device file path (`Image.file`).
/// Priority 3: Network URL (`Image.network`).
/// Priority 4: VIRASAT placeholder card with craft icon (never throws exception).
class SafeProductImage extends StatelessWidget {
  final String? imagePath;
  final String? productId;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final IconData placeholderIcon;
  final String? placeholderText;

  const SafeProductImage({
    super.key,
    required this.imagePath,
    this.productId,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholderIcon = Icons.palette_outlined,
    this.placeholderText,
  });

  @override
  Widget build(BuildContext context) {
    Widget applyBorderRadius(Widget child) {
      if (borderRadius != null) {
        return ClipRRect(
          borderRadius: borderRadius!,
          child: child,
        );
      }
      return child;
    }

    Widget buildPlaceholder() {
      final fallbackAsset = getCraftImagePath(placeholderText ?? productId ?? 'woodcraft');
      return applyBorderRadius(
        Image.asset(
          fallbackAsset,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) => Container(
            width: width,
            height: height,
            color: AppColors.primary.withValues(alpha: 0.08),
            child: const Center(
              child: Icon(Icons.brush_outlined, color: AppColors.primary, size: 28),
            ),
          ),
        ),
      );
    }

    final rawPath = imagePath?.trim() ?? '';
    final cleanPath = rawPath.split('#').first.split('?').first;
    final imgKey = productId != null && productId!.isNotEmpty
        ? Key('product_$productId')
        : Key('product_${rawPath.hashCode}');

    // Priority 4: No image provided
    if (rawPath.isEmpty) {
      return buildPlaceholder();
    }

    // Priority 3: Network URL (http / https)
    if (cleanPath.startsWith('http://') || cleanPath.startsWith('https://')) {
      return applyBorderRadius(
        Image.network(
          cleanPath,
          key: imgKey,
          width: width,
          height: height,
          fit: fit,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: width,
              height: height,
              color: AppColors.primary.withValues(alpha: 0.06),
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                      : null,
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) => buildPlaceholder(),
        ),
      );
    }

    // Priority 2: Local Gallery / Camera / Device File Path
    if (cleanPath.startsWith('/') ||
        cleanPath.startsWith('file://') ||
        cleanPath.contains(':\\') ||
        cleanPath.contains(':/') ||
        cleanPath.startsWith('data/')) {
      try {
        final filePath = cleanPath.startsWith('file://') ? Uri.parse(cleanPath).toFilePath() : cleanPath;
        final file = File(filePath);
        if (file.existsSync()) {
          return applyBorderRadius(
            Image.file(
              file,
              key: imgKey,
              width: width,
              height: height,
              fit: fit,
              errorBuilder: (context, error, stackTrace) => buildPlaceholder(),
            ),
          );
        }
      } catch (_) {}
    }

    // Asset Image Check: Flutter asset path if explicitly provided
    if (cleanPath.startsWith('assets/')) {
      return applyBorderRadius(
        Image.asset(
          cleanPath,
          key: imgKey,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) => buildPlaceholder(),
        ),
      );
    }

    // Fallback placeholder widget
    return buildPlaceholder();
  }
}
