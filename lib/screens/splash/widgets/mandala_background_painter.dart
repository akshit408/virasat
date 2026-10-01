import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class MandalaBackgroundPainter extends CustomPainter {
  final double animationValue; // Continuous particle loop
  final double mandalaOpacity;
  final double particleOpacity;
  final double motifDrawProgress; // Scene 2 lotus & Ajrakh motif drawing (0..1)

  MandalaBackgroundPainter({
    required this.animationValue,
    required this.mandalaOpacity,
    required this.particleOpacity,
    this.motifDrawProgress = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width == 0 || size.height == 0) return;

    // 1. Heritage Terracotta Corner Mandalas (Scene 1)
    if (mandalaOpacity > 0.0) {
      final cornerRadius = math.min(size.width, size.height) * 0.45;
      final rotationAngle = animationValue * math.pi * 0.15;

      // Top Left Corner Mandala
      canvas.save();
      canvas.translate(0, 0);
      canvas.rotate(rotationAngle);
      _drawMandalaPattern(canvas, cornerRadius, AppColors.primaryTerracotta.withValues(alpha: 0.08 * mandalaOpacity));
      canvas.restore();

      // Top Right Corner Mandala
      canvas.save();
      canvas.translate(size.width, 0);
      canvas.rotate(-rotationAngle);
      _drawMandalaPattern(canvas, cornerRadius, AppColors.primaryTerracotta.withValues(alpha: 0.08 * mandalaOpacity));
      canvas.restore();

      // Bottom Left Corner Mandala
      canvas.save();
      canvas.translate(0, size.height);
      canvas.rotate(-rotationAngle);
      _drawMandalaPattern(canvas, cornerRadius, AppColors.primaryTerracotta.withValues(alpha: 0.07 * mandalaOpacity));
      canvas.restore();

      // Bottom Right Corner Mandala
      canvas.save();
      canvas.translate(size.width, size.height);
      canvas.rotate(rotationAngle);
      _drawMandalaPattern(canvas, cornerRadius, AppColors.primaryTerracotta.withValues(alpha: 0.07 * mandalaOpacity));
      canvas.restore();
    }

    // 2. Scene 2: Particle Motif Drawing (Lotus Petals & Ajrakh Geometry)
    if (motifDrawProgress > 0.0) {
      final center = Offset(size.width / 2, size.height / 2);
      final motifRadius = math.min(size.width, size.height) * 0.35 * motifDrawProgress;

      final motifPaint = Paint()
        ..color = AppColors.saffronGold.withValues(alpha: (0.4 * (1.0 - motifDrawProgress)).clamp(0.0, 1.0))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;

      // Ajrakh Geometric Star Motifs
      for (int i = 0; i < 8; i++) {
        final angle = (i * math.pi) / 4;
        final x1 = center.dx + motifRadius * math.cos(angle);
        final y1 = center.dy + motifRadius * math.sin(angle);

        canvas.drawCircle(Offset(x1, y1), 8.0 * motifDrawProgress, motifPaint);
      }
    }

    // 3. Glowing Golden Floating Dust Particles
    if (particleOpacity > 0.0) {
      final particlePaint = Paint()..style = PaintingStyle.fill;
      const numParticles = 28;

      for (int i = 0; i < numParticles; i++) {
        final seedX = (i * 73 + 19) % 100 / 100.0;
        final seedY = (i * 37 + 41) % 100 / 100.0;
        final radius = 2.0 + (i % 4) * 1.2;

        final speed = 0.2 + (i % 3) * 0.15;
        final posY = ((seedY - animationValue * speed) % 1.0 + 1.0) % 1.0;
        final posX = seedX + math.sin(animationValue * math.pi * 2 + i) * 0.02;

        final px = posX * size.width;
        final py = posY * size.height;

        final particleAlpha = (0.3 + 0.4 * math.sin(animationValue * math.pi * 3 + i)) * particleOpacity;

        particlePaint.color = AppColors.saffronGold.withValues(alpha: particleAlpha.clamp(0.0, 1.0));
        canvas.drawCircle(Offset(px, py), radius, particlePaint);
      }
    }

    // 4. Heritage Architectural Arches Silhouette near Bottom
    final archPaint = Paint()
      ..color = AppColors.primaryTerracotta.withValues(alpha: 0.05 * mandalaOpacity)
      ..style = PaintingStyle.fill;

    final archPath = Path();
    archPath.moveTo(0, size.height);
    final archWidth = size.width / 6;

    for (int i = 0; i < 6; i++) {
      final startX = i * archWidth;
      final endX = (i + 1) * archWidth;
      final midX = (startX + endX) / 2;

      archPath.lineTo(startX, size.height - 15);
      archPath.quadraticBezierTo(midX, size.height - 45, endX, size.height - 15);
    }
    archPath.lineTo(size.width, size.height);
    archPath.close();

    canvas.drawPath(archPath, archPaint);
  }

  void _drawMandalaPattern(Canvas canvas, double radius, Color color) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (int r = 1; r <= 4; r++) {
      final currentR = (radius / 4) * r;
      canvas.drawCircle(Offset.zero, currentR, paint);

      final numPetals = 8 * r;
      for (int p = 0; p < numPetals; p++) {
        final angle = (p * 2 * math.pi) / numPetals;
        final px = currentR * math.cos(angle);
        final py = currentR * math.sin(angle);

        canvas.drawCircle(Offset(px, py), 6.0, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant MandalaBackgroundPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.mandalaOpacity != mandalaOpacity ||
        oldDelegate.particleOpacity != particleOpacity ||
        oldDelegate.motifDrawProgress != motifDrawProgress;
  }
}
