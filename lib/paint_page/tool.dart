import 'dart:ui';

import 'package:flutter/cupertino.dart';

enum UpdateType {
  AddPoint,
  SetEndPoint,
  SetCenterPoint,
}

abstract class Tool {
  Offset start;
  Paint paint;

  late Offset end;
  late TextStyle textStyle;
  late bool enabled;

  late FocusNode focusNode;

  Tool({required this.start, required this.paint});

  void update({Offset? point, UpdateType? updateType, Paint? paint, TextStyle? textStyle, bool enabled = false});

  Path get path;
  TextEditingController get text;
  TextPainter get textPainter;

  bool hitZone(tap);
}
