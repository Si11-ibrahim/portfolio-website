import 'dart:math' as math;

import 'package:flutter/material.dart';

class BackgroundPatternPainter extends CustomPainter {
  final double animationValue;
  final bool isDarkMode;

  BackgroundPatternPainter({
    required this.animationValue,
    required this.isDarkMode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDarkMode
            ? [
                const Color(0xFF08091A),
                const Color(0xFF10121F),
                const Color(0xFF191D32),
                const Color(0xFF242942),
              ]
            : [
                const Color(0xFFE3F2FD),
                const Color(0xFFBBDEFB),
                const Color(0xFF90CAF9),
                const Color(0xFF64B5F6),
              ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    final patternPaint = Paint()
      ..color = isDarkMode
          ? const Color(0xFF6D5CFF).withOpacity(0.05)
          : Colors.black.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    const patternStep = 30.0;
    final patternOffset = 20.0 * animationValue;

    for (double y = -patternOffset; y <= size.height; y += patternStep) {
      final path = Path();
      path.moveTo(0, y);
      for (double x = 0; x <= size.width; x += 5) {
        final yOffset = math.sin((x / size.width) * 5 * math.pi +
                (animationValue * 2 * math.pi)) *
            8;
        path.lineTo(x, y + yOffset);
      }
      canvas.drawPath(path, patternPaint);
    }

    if (isDarkMode) {
      final radialPaint = Paint()
        ..shader = RadialGradient(
          center: const Alignment(0.0, -0.5),
          radius: 1.0,
          colors: [
            const Color(0xFF6D5CFF).withOpacity(0.15),
            Colors.transparent,
          ],
          stops: const [0.0, 0.7],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
      canvas.drawRect(
          Rect.fromLTWH(0, 0, size.width, size.height), radialPaint);
    }
  }

  @override
  bool shouldRepaint(BackgroundPatternPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
