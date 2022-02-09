import 'package:flutter/material.dart';

class AnalyticsPaint extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    Paint paint = Paint();

    Path mainBackground = Path();
    mainBackground.addRect(Rect.fromLTRB(0, 0, width, height));
    paint.color = const Color(0xff6952ED);
    canvas.drawPath(mainBackground, paint);

    Path ovalPath = Path();
    // Start paint from 20% height to the left
    ovalPath.moveTo(0, 0);

    // paint a curve from current position to middle of the screen
    ovalPath.quadraticBezierTo(
        width * 0.9, height * 0, width * 0.9, height * 0);
    ovalPath.quadraticBezierTo(
        width * 0.8, height * 0.5, width * 0.4, height * 0.4);

    // Paint a curve from current position to bottom left of screen at width * 0.1
    ovalPath.quadraticBezierTo(
        width * 0.28, height * 0.7, width * 0, height * 0.8);

    // draw remaining line to bottom left side
    ovalPath.lineTo(0, height);

    // Close line to reset it back
    ovalPath.close();

    paint.color = Colors.indigo.shade900;
    canvas.drawPath(ovalPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
