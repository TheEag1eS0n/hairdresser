import 'dart:ui';

enum UpdateType {
  AddPoint,
  SetEndPoint,
  SetCenterPoint,
}

abstract class Tool {
  late Offset start;
  late Offset end;

  late Paint paint;

  Tool({required this.start, required this.paint});

  void update(Offset point, UpdateType updateType);

  Path get path;

  bool hitZone(tap);
}