import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hairdresser/paint_page/tool.dart';

class Erase implements Tool {
  @override
  Offset start;

  @override
  Paint paint = Paint()
    ..color = Colors.transparent
    ..blendMode = BlendMode.clear
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 20;

  @override
  late TextStyle textStyle;

  @override
  Erase({required this.start}) {
    points.add(start);
  }

  @override
  late Offset end;

  late List<Offset> points = [];

  @override
  // TODO: implement path
  Path get path {
    Path path = Path()..moveTo(start.dx, start.dy);
    points.forEach((point) {
      path.lineTo(point.dx, point.dy);
    });
    return path;
  }

  @override
  bool hitZone(tap) {
    // TODO: implement hitZone
    return false;
  }

  @override
  void update([Offset? point, UpdateType? updateType, Paint? paint, TextStyle? textStyle]) {
    points.add(point!);
  }

  @override
  // TODO: implement text
  String get text => throw UnimplementedError();
}
