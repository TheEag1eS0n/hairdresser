import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hairdresser/custom_arrow_path.dart';
import 'package:hairdresser/paint_page/tool.dart';
import 'package:path_drawing/path_drawing.dart';

class ArrowLine implements Tool {
  @override
  Offset start;
  @override
  late Offset end;
  @override
  late TextStyle textStyle;

  late Offset center;

  List<double> dashedArray;

  @override
  ArrowLine({required this.start, required this.paint, required this.dashedArray}) {
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

    Path dashedPath = dashPath(path, dashArray: CircularIntervalList<double>(dashedArray));

    return ArrowPath.make(path: dashedPath);
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
  bool hitZone(tap) {
    if (paint.strokeWidth < 4)
      return distanceToLine(tap) <= 5;
    return distanceToLine(tap) <= paint.strokeWidth;
  }

  @override
  void update({Offset? point, UpdateType? updateType, Paint? paint, TextStyle? textStyle, bool enabled = false}) {
    switch (updateType) {
      case UpdateType.SetCenterPoint:
        center = point!;
        break;
      default:
        end = point!;
        center = (start + end) / 2;
        break;
    }
  }

  @override
  // TODO: implement text
  TextEditingController get text => throw UnimplementedError();

  @override
  bool enabled = false;

  @override
  late FocusNode focusNode;

  @override
  // TODO: implement textPainter
  TextPainter get textPainter => throw UnimplementedError();
}