import 'dart:math';
import 'package:arrow_path/arrow_path.dart';
import 'package:flutter/material.dart';
import 'package:hairdresser/paint_page/tool.dart';

class ArrowLine implements Tool {
  @override
  late Offset start;
  @override
  late Offset end;
  late Offset center;

  @override
  ArrowLine({required this.start, required this.paint}) {
    end = start;
    center = (start + end) / 2;
  }

  @override
  late Paint paint;

  @override
  void update(Offset point, UpdateType updateType) {
    switch (updateType) {
      case UpdateType.SetEndPoint:
        end = point;
        center = (start + end) / 2;
        break;
      case UpdateType.SetCenterPoint:
        center = point;
    }
  }

  Offset get centerOfBaseLine => (start + end) / 2;
  Offset get advancedPoint => centerOfBaseLine + (center - centerOfBaseLine) * 2;

  @override
  Path get path {
    Path path = Path()
      ..moveTo(start.dx, start.dy)
      ..quadraticBezierTo(advancedPoint.dx, advancedPoint.dy, end.dx, end.dy);
    path = ArrowPath.make(path: path, isDoubleSided: false, isAdjusted: false);
    return path;
  }
  double distanceToLine(Offset p) {
    double dx = (p.dx - start.dx) * (end.dx - start.dx);
    double dy = (p.dy - start.dy) * (end.dy - start.dy);

    num powX = pow((end.dx - start.dx), 2);
    num powY = pow((end.dy - start.dy), 2);

    double t = min(max((dx + dy) / (powX + powY), 0), 1);

    double distance = sqrt(pow((start.dx - p.dx + (end.dx - start.dx) * t), 2) +
        pow((start.dy - p.dy + (end.dy - start.dy) * t), 2));
    return distance;
  }

  @override
  bool hitZone(tap) => distanceToLine(tap) <= paint.strokeWidth;

  @override
  // TODO: implement textPainter
  TextPainter get textPainter => throw UnimplementedError();

}