import 'package:flutter/material.dart';
import '../models/home_models.dart';

class StarfieldPainter extends CustomPainter {
  final List<Star> stars;
  StarfieldPainter(this.stars);

  @override
  void paint(Canvas canvas, Size size) {
    for (final s in stars) {
      canvas.drawCircle(
        Offset(s.x * size.width, s.y * size.height),
        s.r,
        Paint()
          ..color = const Color(0xFFb4d2f0).withValues(alpha: s.alpha * 0.5),
      );
    }
  }

  @override
  bool shouldRepaint(StarfieldPainter old) => true;
}
