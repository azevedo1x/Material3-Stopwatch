import 'package:flutter/material.dart';
import 'dart:math';

class AnimatedStopwatch extends StatelessWidget {
  final Duration elapsed;

  const AnimatedStopwatch({super.key, required this.elapsed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 260,
      height: 260,
      child: CustomPaint(
        painter: StopwatchPainter(
          elapsed: elapsed,
          primaryColor: theme.colorScheme.primary,
          surfaceColor: theme.colorScheme.surface,
          onSurfaceColor: theme.colorScheme.onSurface,
          outlineColor: theme.colorScheme.outline,
        ),
      ),
    );
  }
}

class StopwatchPainter extends CustomPainter {
  final Duration elapsed;
  final Color primaryColor;
  final Color surfaceColor;
  final Color onSurfaceColor;
  final Color outlineColor;

  StopwatchPainter({
    required this.elapsed,
    required this.primaryColor,
    required this.surfaceColor,
    required this.onSurfaceColor,
    required this.outlineColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;

    final ringPaint = Paint()
      ..color = outlineColor.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(center, radius, ringPaint);

    final fillPaint = Paint()
      ..color = outlineColor.withValues(alpha: 0.03)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, fillPaint);

    for (int i = 0; i < 60; i++) {
      final angle = i * (2 * pi / 60) - pi / 2;
      final isMajor = i % 5 == 0;
      final outerR = radius - 2;
      final innerR = isMajor ? radius - 16 : radius - 8;

      final outerPoint = Offset(
        center.dx + outerR * cos(angle),
        center.dy + outerR * sin(angle),
      );
      final innerPoint = Offset(
        center.dx + innerR * cos(angle),
        center.dy + innerR * sin(angle),
      );

      final tickPaint = Paint()
        ..color = isMajor
            ? onSurfaceColor.withValues(alpha: 0.5)
            : outlineColor.withValues(alpha: 0.25)
        ..strokeWidth = isMajor ? 2.0 : 1.0
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(outerPoint, innerPoint, tickPaint);
    }

    final totalMs = elapsed.inMilliseconds;
    final secondAngle = (totalMs % 60000) / 60000.0 * 2 * pi - pi / 2;
    final minuteAngle = (totalMs % 3600000) / 3600000.0 * 2 * pi - pi / 2;
    final hourAngle = (totalMs % 43200000) / 43200000.0 * 2 * pi - pi / 2;

    _drawHand(canvas, center, hourAngle, radius * 0.45, 4.0,
        onSurfaceColor.withValues(alpha: 0.35));
    _drawHand(canvas, center, minuteAngle, radius * 0.65, 3.0,
        onSurfaceColor.withValues(alpha: 0.6));
    _drawHand(canvas, center, secondAngle, radius * 0.85, 1.5, primaryColor);

    final dotPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 5, dotPaint);

    final dotBorderPaint = Paint()
      ..color = surfaceColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, 5, dotBorderPaint);
  }

  void _drawHand(Canvas canvas, Offset center, double angle, double length,
      double width, Color color) {
    final end = Offset(
      center.dx + length * cos(angle),
      center.dy + length * sin(angle),
    );
    final tail = Offset(
      center.dx - 12 * cos(angle),
      center.dy - 12 * sin(angle),
    );

    final paint = Paint()
      ..color = color
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(tail, end, paint);
  }

  @override
  bool shouldRepaint(covariant StopwatchPainter oldDelegate) {
    return oldDelegate.elapsed != elapsed;
  }
}
