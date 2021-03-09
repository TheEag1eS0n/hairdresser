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

  late String _text;

  String get text => _text;

  set text(String text) {
    _text = text;
  }

  TextStyle textStyle = TextStyle(
    fontWeight: FontWeight.normal,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
    fontSize: 16,
    color: Colors.black,
  );

  CanvasText({
    required text,
    required this.start,
    required this.paint,
  }) {
    _text = text;
  }

  @override
  bool hitZone(tap) {
    return path.contains(tap);
  }

  @override
  // TODO: implement path
  Path get path {
    paint.strokeWidth = 1;
    Path path = Path()..moveTo(start.dx, start.dy);
    path.addRect(Rect.fromPoints(start,
        Offset(start.dx + textPainter.width, start.dy + textPainter.height)));
    return path;
  }

  @override
  // TODO: implement textPainter
  TextPainter get textPainter {
    TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    textPainter.text = TextSpan(
      text: text,
      style: textStyle,
    );
    textPainter.layout();
    return textPainter;
  }

  @override
  void update([Offset? point, UpdateType? updateType, Paint? paint, TextStyle? textStyle]) {
    this.start = point ?? this.start;
    this.textStyle = textStyle ?? this.textStyle;
  }
}
