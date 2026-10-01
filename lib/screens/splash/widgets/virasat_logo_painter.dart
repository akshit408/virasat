import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class VirasatLogoPainter extends CustomPainter {
  final double outlineProgress;
  final double leafProgress;
  final double artisanProgress;
  final double glowProgress;
  final double sunMonumentProgress;
  final bool isMonochrome;
  final bool isDarkMode;

  VirasatLogoPainter({
    required this.outlineProgress,
    required this.leafProgress,
    required this.artisanProgress,
    required this.glowProgress,
    required this.sunMonumentProgress,
    this.isMonochrome = false,
    this.isDarkMode = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final usableSize = math.min(size.width, size.height);
    final scaleFactor = usableSize / 300.0;

    // Palette Resolution
    final greenColor = isMonochrome
        ? (isDarkMode ? Colors.white : AppColors.darkBrown)
        : (isDarkMode ? const Color(0xFF4E8D71) : AppColors.forestGreen);

    final terracottaColor = isMonochrome
        ? (isDarkMode ? Colors.white.withValues(alpha: 0.8) : AppColors.darkBrown.withValues(alpha: 0.8))
        : (isDarkMode ? const Color(0xFFD96345) : AppColors.primaryTerracotta);

    final goldColor = isMonochrome
        ? (isDarkMode ? Colors.white : AppColors.darkBrown)
        : AppColors.saffronGold;

    // 1. Soft Golden Glow Aura
    if (glowProgress > 0.0 && !isMonochrome) {
      final glowRadius = (usableSize * 0.55) * glowProgress;
      final glowPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            goldColor.withValues(alpha: 0.35 * glowProgress),
            goldColor.withValues(alpha: 0.12 * glowProgress),
            Colors.transparent,
          ],
          stops: const [0.0, 0.6, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: glowRadius));

      canvas.drawCircle(center, glowRadius, glowPaint);
    }

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.scale(scaleFactor);

    // 2. Rising Golden Sun & Heritage Monument Silhouette
    if (sunMonumentProgress > 0.0) {
      final sunOpacity = sunMonumentProgress.clamp(0.0, 1.0);
      
      final sunPaint = Paint()
        ..color = goldColor.withValues(alpha: sunOpacity)
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(const Offset(0, -60), 32 * sunMonumentProgress, sunPaint);

      // Sun Outer Ring Accent
      final ringPaint = Paint()
        ..color = goldColor.withValues(alpha: 0.4 * sunOpacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;
      canvas.drawCircle(const Offset(0, -60), 40 * sunMonumentProgress, ringPaint);

      // Heritage Monument Silhouette (Dome & Archway)
      final monumentPath = Path();
      monumentPath.moveTo(-20, -30);
      monumentPath.lineTo(-20, -55);
      monumentPath.lineTo(-12, -55);
      monumentPath.lineTo(-12, -68);
      monumentPath.lineTo(0, -78); // Dome apex
      monumentPath.lineTo(12, -68);
      monumentPath.lineTo(12, -55);
      monumentPath.lineTo(20, -55);
      monumentPath.lineTo(20, -30);
      // Arch cutout inside
      monumentPath.lineTo(12, -30);
      monumentPath.arcToPoint(
        const Offset(-12, -30),
        radius: const Radius.circular(12),
        clockwise: false,
      );
      monumentPath.lineTo(-20, -30);
      monumentPath.close();

      final monumentPaint = Paint()
        ..color = (isDarkMode ? const Color(0xFF1C1714) : AppColors.darkBrown).withValues(alpha: sunOpacity)
        ..style = PaintingStyle.fill;
      canvas.drawPath(monumentPath, monumentPaint);
    }

    // 3. Left Wing: Forest Green Organic Leaf (Lotus & Veining Details)
    if (leafProgress > 0.0) {
      final slideX = -50.0 * (1.0 - leafProgress);
      final leafOpacity = leafProgress.clamp(0.0, 1.0);

      final leafPath = Path();
      leafPath.moveTo(0 + slideX, 90);
      leafPath.cubicTo(-20 + slideX, 60, -65 + slideX, 20, -100 + slideX, -60);
      leafPath.cubicTo(-90 + slideX, -65, -70 + slideX, -50, -40 + slideX, -20);
      leafPath.cubicTo(-20 + slideX, 10, -5 + slideX, 50, 0 + slideX, 65);
      leafPath.close();

      final leafPaint = Paint()
        ..color = greenColor.withValues(alpha: leafOpacity)
        ..style = PaintingStyle.fill;

      canvas.drawPath(leafPath, leafPaint);

      // Lotus Flower Vein Details
      final veinPath = Path();
      veinPath.moveTo(-80 + slideX, -45);
      veinPath.cubicTo(-50 + slideX, -10, -25 + slideX, 25, -5 + slideX, 55);

      final veinPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.35 * leafOpacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round;

      canvas.drawPath(veinPath, veinPaint);
    }

    // 4. Right Wing: Terracotta Artisan & Potter Wheel Half
    if (artisanProgress > 0.0) {
      final slideX = 50.0 * (1.0 - artisanProgress);
      final artisanOpacity = artisanProgress.clamp(0.0, 1.0);

      final artisanPath = Path();
      artisanPath.moveTo(0 + slideX, 90);
      artisanPath.cubicTo(20 + slideX, 60, 65 + slideX, 20, 100 + slideX, -60);
      artisanPath.cubicTo(90 + slideX, -65, 70 + slideX, -50, 40 + slideX, -20);
      artisanPath.cubicTo(20 + slideX, 10, 5 + slideX, 50, 0 + slideX, 65);
      artisanPath.close();

      final artisanPaint = Paint()
        ..color = terracottaColor.withValues(alpha: artisanOpacity)
        ..style = PaintingStyle.fill;

      canvas.drawPath(artisanPath, artisanPaint);

      // Artisan Silhouette & Wheel Details
      final artisanDetailPath = Path();
      artisanDetailPath.moveTo(80 + slideX, -45);
      artisanDetailPath.cubicTo(50 + slideX, -10, 25 + slideX, 25, 5 + slideX, 55);

      final detailPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.4 * artisanOpacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round;

      canvas.drawPath(artisanDetailPath, detailPaint);
    }

    // 5. Glowing Golden Stroke-by-Stroke Drawing (Scene 3)
    if (outlineProgress > 0.0 && outlineProgress < 1.0) {
      final outlinePath = Path();
      outlinePath.moveTo(0, 95);
      outlinePath.cubicTo(-40, 50, -90, -10, -105, -65);
      outlinePath.cubicTo(-60, -45, -25, 0, 0, 65);
      outlinePath.cubicTo(25, 0, 60, -45, 105, -65);
      outlinePath.cubicTo(90, -10, 40, 50, 0, 95);

      final outlinePaint = Paint()
        ..color = goldColor.withValues(alpha: 1.0 - outlineProgress * 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.5
        ..strokeCap = StrokeCap.round;

      final metrics = outlinePath.computeMetrics().toList();
      for (final metric in metrics) {
        final extractPath = metric.extractPath(0, metric.length * outlineProgress);
        canvas.drawPath(extractPath, outlinePaint);
      }
    }

    // 6. Convergence Jewel (Center Base)
    final jewelProgress = math.max(leafProgress, artisanProgress);
    if (jewelProgress > 0.0) {
      final jewelPath = Path();
      jewelPath.moveTo(0, 98);
      jewelPath.lineTo(-12, 78);
      jewelPath.lineTo(0, 65);
      jewelPath.lineTo(12, 78);
      jewelPath.close();

      final jewelPaint = Paint()
        ..color = terracottaColor.withValues(alpha: jewelProgress)
        ..style = PaintingStyle.fill;

      canvas.drawPath(jewelPath, jewelPaint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant VirasatLogoPainter oldDelegate) {
    return oldDelegate.outlineProgress != outlineProgress ||
        oldDelegate.leafProgress != leafProgress ||
        oldDelegate.artisanProgress != artisanProgress ||
        oldDelegate.glowProgress != glowProgress ||
        oldDelegate.sunMonumentProgress != sunMonumentProgress ||
        oldDelegate.isMonochrome != isMonochrome ||
        oldDelegate.isDarkMode != isDarkMode;
  }
}
