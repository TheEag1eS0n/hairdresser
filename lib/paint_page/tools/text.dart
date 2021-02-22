import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hairdresser/paint_page/tool.dart';

class CanvasText implements Tool {
  @override
  late Offset end;

  @override
  Paint paint;

  @override
  Offset start;

  late TextPainter _textPainter;

  CanvasText({required String text, required this.start, required this.paint}) {
    _textPainter = TextPainter(textDirection: TextDirection.ltr);
    _textPainter.text = TextSpan(
        text: text, style: TextStyle(fontSize: 16, color: paint.color));
    _textPainter.layout();
  }

  @override
  bool hitZone(tap) {
    return path.contains(tap);
  }

  @override
  // TODO: implement path
  Path get path {
    paint.strokeWidth = 1;
    paint.color = Colors.transparent;
    Path path = Path()..moveTo(start.dx, start.dy);
    path.addRect(Rect.fromPoints(start,
        Offset(start.dx + textPainter.width, start.dy + textPainter.height)));
    return path;
  }

  @override
  void update(Offset point, UpdateType updateType) {
    start = point;
  }

  @override
  // TODO: implement textPainter
  TextPainter get textPainter => _textPainter;
}
