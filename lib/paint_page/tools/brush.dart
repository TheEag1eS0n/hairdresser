import 'package:flutter/material.dart';
import 'package:hairdresser/paint_page/tool.dart';

class Brush implements Tool {
  @override
  Offset start;
  @override
  Paint paint;
  @override
  late TextStyle textStyle;

  @override
  Brush({required this.start, required this.paint}) {
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
    throw UnimplementedError();
  }

  @override
  void update([Offset? point, UpdateType? updateType, Paint? paint, TextStyle? textStyle]) {
    points.add(point!);
  }

  @override
  // TODO: implement text
  TextEditingController get text => throw UnimplementedError();
}