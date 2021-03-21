import 'package:flutter/material.dart';
import 'package:hairdresser/paint_page/tool.dart';
import 'package:hairdresser/paint_page/tools/arrow.dart';
import 'package:hairdresser/paint_page/tools/brush.dart';
import 'package:hairdresser/paint_page/tools/curve.dart';
import 'package:hairdresser/paint_page/tools/erase.dart';
import 'package:hairdresser/paint_page/tools/text.dart';
import 'package:hairdresser/paint_page/tools_list.dart';

class GestureWidget extends StatefulWidget {
  final DrawingTool currentTool;
  final createTool;
  final updateTool;

  Paint paint;
  final TextStyle textStyle;

  List<Tool> currentElements;

  GestureWidget({
    required this.currentTool,
    required this.paint,
    required this.textStyle,
    required this.createTool,
    required this.updateTool,
    required this.currentElements,
  });

  @override
  _GestureWidgetState createState() => _GestureWidgetState();
}

class _GestureWidgetState extends State<GestureWidget> {
  int checkTextZones(Offset point) {
    int checkZoneElement = -1;
    widget.currentElements.asMap().forEach((key, value) {
      print('$key => ${value.hitZone(point)}');
      checkZoneElement = value.hitZone(point) ? key : checkZoneElement;
    });

    return checkZoneElement;
  }

  late int editingElement;

  DrawingTool get currentTool => widget.currentTool;

  Widget get gestureForTool {
    if (currentTool == DrawingTool.Text) {
      return GestureDetector(
        onTapDown: (event) {
          widget.createTool(CanvasText(
            text: 'Введите текст',
            start: event.localPosition,
            paint: widget.paint,
            textStyle: widget.textStyle,
          ));
        },
        onDoubleTapDown: (event) {},
        onLongPressStart: (event) {},
        onLongPressMoveUpdate: (event) {},
        onLongPressEnd: (event) {},
      );
    } else {
      return GestureDetector(
        onPanStart: (event) {
          setState(() {
            editingElement = checkTextZones(event.localPosition);
            print(editingElement);
          });
          if (editingElement == -1) {
            switch (currentTool) {
              case DrawingTool.Brush:
                widget.createTool(
                    Brush(start: event.localPosition, paint: widget.paint));
                break;
              case DrawingTool.Eraser:
                widget.createTool(Erase(start: event.localPosition));
                break;
              case DrawingTool.Curve:
                widget.createTool(CurveLine(
                  start: event.localPosition,
                  paint: widget.paint,
                  dashedArray: [1.0],
                ));
                break;
              case DrawingTool.Arrow:
                widget.createTool(ArrowLine(
                  start: event.localPosition,
                  paint: widget.paint,
                  dashedArray: [1.0],
                ));
            }
          }
          else {
            widget.updateTool(
                editedShape: widget.currentElements[editingElement],
                point: event.localPosition
            );
          }
        },
        onPanUpdate: (event) {
          widget.updateTool(
              editedShape: editingElement == -1 ? null : widget.currentElements[editingElement],
              point: event.localPosition);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          style: BorderStyle.solid,
        ),
      ),
      child: gestureForTool,
    );
  }
}
