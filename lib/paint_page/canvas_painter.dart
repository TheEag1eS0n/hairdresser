import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hairdresser/paint_page/tool.dart';
import 'package:hairdresser/paint_page/tools/text.dart';

class ShapesCanvas extends CustomPainter {
  List<Tool> shapes;
  ShapesCanvas({required this.shapes});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());
    if (shapes.isNotEmpty) {
      shapes.forEach((shape) {
        canvas.drawPath(shape.path, shape.paint);
      });
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
