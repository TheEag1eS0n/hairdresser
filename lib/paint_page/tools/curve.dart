import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hairdresser/paint_page/tool.dart';

class CurveLine implements Tool {
  @override
  late Offset start;
  @override
  late Offset end;
  late Offset center;

  @override
  CurveLine({required this.start, required this.paint}) {
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
  Path get path => Path()
    ..moveTo(start.dx, start.dy)
    ..quadraticBezierTo(advancedPoint.dx, advancedPoint.dy, end.dx, end.dy);

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

/*
Offset start, center, end;
  Paint paint;
  DrawCurve({required this.start, required this.center, required this.end, required this.paint});

  void update(Offset point) {
    end = point;
  }

  // <----------------------------->

  Offset delta = Offset(0, 0);

  Offset get centerOfBaseLine => (start + end) / 2;

  Offset get advancedPoint {
    return centerOfBaseLine + (center - centerOfBaseLine) * 2;
  }

  Path get curvePath {
    Path path = Path()..moveTo(start.dx, start.dy);
    if (advancedPoint.isFinite)
      path.quadraticBezierTo(
          advancedPoint.dx, advancedPoint.dy, end.dx, end.dy);
    else
      path.quadraticBezierTo(center.dx, center.dy, end.dx, end.dy);
    return path;
  }

  Path pointAround(Offset point) => Path()
    ..moveTo(point.dx, point.dy)
    ..addRRect(RRect.fromRectAndRadius(
        Rect.fromCenter(center: point, width: 10.0, height: 10.0),
        Radius.circular(10.0)))
    ..close();

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

  bool hitZone(tap) => distanceToLine(tap) <= paint.strokeWidth;
 */
