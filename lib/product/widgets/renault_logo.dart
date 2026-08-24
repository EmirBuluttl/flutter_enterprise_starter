import 'package:flutter/material.dart';

/// Custom Painter for the iconic Renault Diamond Emblem
class RenaultLogo extends StatelessWidget {
  final double size;
  final Color color;

  const RenaultLogo({
    super.key,
    this.size = 96.0,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size * 1.25),
      painter: _RenaultLogoPainter(color: color),
    );
  }
}

class _RenaultLogoPainter extends CustomPainter {
  final Color color;

  _RenaultLogoPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.08
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;

    // Outer Diamond Path
    final outerPath = Path()
      ..moveTo(w * 0.5, 0)
      ..lineTo(w, h * 0.42)
      ..lineTo(w * 0.5, h)
      ..lineTo(0, h * 0.42)
      ..close();

    // Inner Diamond Lines (Renault Parallel Diamond Lines)
    final innerPath1 = Path()
      ..moveTo(w * 0.5, h * 0.20)
      ..lineTo(w * 0.80, h * 0.45)
      ..lineTo(w * 0.5, h * 0.80)
      ..lineTo(w * 0.20, h * 0.45)
      ..close();

    canvas.drawPath(outerPath, paint);
    canvas.drawPath(innerPath1, paint);
  }

  @override
  bool shouldRepaint(covariant _RenaultLogoPainter oldDelegate) =>
      oldDelegate.color != color;
}
