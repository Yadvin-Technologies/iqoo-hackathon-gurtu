import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Minimal line + fill sparkline. Null values leave gaps.
class Sparkline extends StatelessWidget {
  const Sparkline({
    super.key,
    required this.values,
    required this.color,
    this.min,
    this.max,
    this.height = 36,
  });

  final List<double?> values;
  final Color color;
  final double? min;
  final double? max;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(painter: _SparkPainter(values, color, min, max)),
    );
  }
}

class _SparkPainter extends CustomPainter {
  _SparkPainter(this.values, this.color, this.min, this.max);

  final List<double?> values;
  final Color color;
  final double? min;
  final double? max;

  @override
  void paint(Canvas canvas, Size size) {
    final present = values.whereType<double>();
    if (present.length < 2) return;
    final lo = min ?? present.reduce(math.min);
    var hi = max ?? present.reduce(math.max);
    if (hi - lo < 1e-6) hi = lo + 1;

    final dx = size.width / (values.length - 1);
    final line = Path();
    final fill = Path();
    var started = false;
    double? lastX;
    for (var i = 0; i < values.length; i++) {
      final v = values[i];
      if (v == null) continue;
      final x = i * dx;
      final y = size.height - ((v - lo) / (hi - lo)).clamp(0.0, 1.0) * size.height;
      if (!started) {
        line.moveTo(x, y);
        fill.moveTo(x, size.height);
        fill.lineTo(x, y);
        started = true;
      } else {
        line.lineTo(x, y);
        fill.lineTo(x, y);
      }
      lastX = x;
    }
    fill
      ..lineTo(lastX!, size.height)
      ..close();

    canvas.drawPath(
      fill,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withValues(alpha: 0.35), color.withValues(alpha: 0.0)],
        ).createShader(Offset.zero & size),
    );
    canvas.drawPath(
      line,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant _SparkPainter old) => true;
}
