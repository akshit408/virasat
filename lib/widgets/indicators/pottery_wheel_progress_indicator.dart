import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class PotteryWheelProgressIndicator extends StatefulWidget {
  final double size;
  final Color wheelColor;
  final Color clayColor;
  final String? loadingText;

  const PotteryWheelProgressIndicator({
    super.key,
    this.size = 48.0,
    this.wheelColor = AppColors.darkBrown,
    this.clayColor = AppColors.primaryTerracotta,
    this.loadingText,
  });

  @override
  State<PotteryWheelProgressIndicator> createState() => _PotteryWheelProgressIndicatorState();
}

class _PotteryWheelProgressIndicatorState extends State<PotteryWheelProgressIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return SizedBox(
              width: widget.size,
              height: widget.size,
              child: CustomPaint(
                painter: _PotteryWheelPainter(
                  progress: _controller.value,
                  wheelColor: widget.wheelColor,
                  clayColor: widget.clayColor,
                ),
              ),
            );
          },
        ),
        if (widget.loadingText != null) ...[
          const SizedBox(height: 8),
          Text(
            widget.loadingText!,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ],
    );
  }
}

class _PotteryWheelPainter extends CustomPainter {
  final double progress;
  final Color wheelColor;
  final Color clayColor;

  _PotteryWheelPainter({
    required this.progress,
    required this.wheelColor,
    required this.clayColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    // 1. Spinning Pottery Wheel Base Disc
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(progress * 2 * math.pi);

    final wheelPaint = Paint()
      ..color = wheelColor.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset.zero, radius * 0.9, wheelPaint);

    final rimPaint = Paint()
      ..color = wheelColor.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(Offset.zero, radius * 0.88, rimPaint);

    // Spokes on wheel disc
    for (int i = 0; i < 6; i++) {
      final angle = (i * math.pi) / 3;
      final dx = radius * 0.8 * math.cos(angle);
      final dy = radius * 0.8 * math.sin(angle);
      canvas.drawLine(Offset.zero, Offset(dx, dy), rimPaint..strokeWidth = 1.0);
    }
    canvas.restore();

    // 2. Center Clay Pot Being Hand-Formed (Morphing shape pulse)
    final potHeight = radius * (0.8 + 0.1 * math.sin(progress * 2 * math.pi));
    final potWidth = radius * (0.5 + 0.08 * math.cos(progress * 2 * math.pi));

    final potPath = Path();
    potPath.moveTo(-potWidth * 0.6, potHeight * 0.4);
    potPath.quadraticBezierTo(
      -potWidth * 0.9, 0,
      -potWidth * 0.4, -potHeight * 0.4,
    );
    potPath.lineTo(potWidth * 0.4, -potHeight * 0.4);
    potPath.quadraticBezierTo(
      potWidth * 0.9, 0,
      potWidth * 0.6, potHeight * 0.4,
    );
    potPath.close();

    canvas.save();
    canvas.translate(center.dx, center.dy);

    final clayPaint = Paint()
      ..color = clayColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(potPath, clayPaint);

    // Golden Highlight Ridge
    final highlightPaint = Paint()
      ..color = AppColors.saffronGold
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawPath(potPath, highlightPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _PotteryWheelPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.wheelColor != wheelColor ||
        oldDelegate.clayColor != clayColor;
  }
}
