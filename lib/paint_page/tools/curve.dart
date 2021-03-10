import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hairdresser/paint_page/tool.dart';
import 'package:path_drawing/path_drawing.dart';

class CurveLine implements Tool {
  @override
  Offset start;
  @override
  late Offset end;
  @override
  late TextStyle textStyle;

  late Offset center;

  List<double> dashedArray;

  @override
  CurveLine({required this.start, required this.paint, required this.dashedArray}) {
    end = start;
    center = (start + end) / 2;
  }

  @override
  Paint paint;

  Offset get centerOfBaseLine => (start + end) / 2;
  Offset get advancedPoint => centerOfBaseLine + (center - centerOfBaseLine) * 2;

  @override
  Path get path {
    Path path = Path()
      ..moveTo(start.dx, start.dy)
      ..quadraticBezierTo(advancedPoint.dx, advancedPoint.dy, end.dx, end.dy);

    return dashPath(path, dashArray: CircularIntervalList<double>(dashedArray));
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
  void update([Offset? point, UpdateType? updateType, Paint? paint, TextStyle? textStyle]) {
    switch (updateType) {
      case UpdateType.SetEndPoint:
        end = point!;
        center = (start + end) / 2;
        break;
      case UpdateType.SetCenterPoint:
        center = point!;
    }
  }

  @override
  // TODO: implement text
  String get text => throw UnimplementedError();
}