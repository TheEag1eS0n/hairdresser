import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hairdresser/paint_page/tool.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:arrow_path/arrow_path.dart';
import 'package:path_drawing/path_drawing.dart';

class ArrowLine implements Tool {
  @override
  Offset start;
  @override
  late Offset end;

  @override
  late TextStyle textStyle;

  late Offset center;

  @override
  ArrowLine({required this.start, required this.paint, required this.dashedArray}) {
    end = start;
    center = (start + end) / 2;
  }

  @override
  Paint paint;

  List<double> dashedArray;

  Offset get centerOfBaseLine => (start + end) / 2;
  Offset get advancedPoint => centerOfBaseLine + (center - centerOfBaseLine) * 2;

  @override
  Path get path {
    Path path = Path()
      ..moveTo(start.dx, start.dy)
      ..quadraticBezierTo(advancedPoint.dx, advancedPoint.dy, end.dx, end.dy);
    Path dashedPath = dashPath(path, dashArray: CircularIntervalList<double>(dashedArray));
        ArrowPath.make(path: dashedPath, isDoubleSided: false, isAdjusted: false);
    return dashedPath;
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

  @override
  void update([Offset? point, UpdateType? updateType, Paint? paint, TextStyle? textStyle]) {
    switch (updateType) {
      case UpdateType.SetEndPoint:
        end = point ?? end;
        center = (start + end) / 2;
        break;
      case UpdateType.SetCenterPoint:
        center = point ?? center;
    }
  }

  @override
  // TODO: implement text
  TextEditingController get text => throw UnimplementedError();
}