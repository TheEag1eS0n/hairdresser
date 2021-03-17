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

  late TextEditingController _text;

  TextEditingController get text => _text;

  TextStyle textStyle;

  CanvasText({
    required String text,
    required this.start,
    required this.paint,
    required this.textStyle,
  }) {
    _text = new TextEditingController()
      ..text = text;
  }

  @override
  bool hitZone(tap) {
    return path.contains(tap);
  }

  @override
  // TODO: implement path
  Path get path {
    paint.strokeWidth = 1;
    Path path = Path();
    path.addRRect(
        RRect.fromLTRBR(
            start.dx - textPainter.height - 5.0,
            start.dy, start.dx - 5, start.dy + textPainter.height, Radius.circular(5.0)));
    path.close();
    return path;
  }

  TextPainter get textPainter {
    TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    textPainter.text = TextSpan(
      text: _text.text,
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
