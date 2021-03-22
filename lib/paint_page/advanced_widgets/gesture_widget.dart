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

  final Paint paint;
  final TextStyle textStyle;
  List<double> dashArray;

  final List<Tool> currentElements;

  GestureWidget({
    required this.currentTool,
    required this.paint,
    required this.textStyle,
    required this.createTool,
    required this.updateTool,
    required this.currentElements,
    required this.dashArray,
  });

  @override
  _GestureWidgetState createState() => _GestureWidgetState();
}

class _GestureWidgetState extends State<GestureWidget> {
  int checkTextZones(Offset point) {
    int checkZoneElement = -1;
    widget.currentElements.asMap().forEach((key, value) {
      checkZoneElement = value.hitZone(point) ? key : checkZoneElement;
    });

    return checkZoneElement;
  }

  int editingElement = -1;

  DrawingTool get currentTool => widget.currentTool;

  Widget get gestureForTool {
    if (currentTool == DrawingTool.Text) {
      return GestureDetector(
        onTapUp: (event) {
          if (editingElement != -1 && widget.currentElements.isNotEmpty)
            widget.updateTool(
                editedShape: widget.currentElements[editingElement],
                enable: false);
          setState(() {
            editingElement = checkTextZones(event.localPosition);
          });
          if (editingElement == -1) {
            widget.createTool(CanvasText(
              text: 'Введите текст',
              start: event.localPosition,
              paint: widget.paint,
              textStyle: widget.textStyle,
            ));
          }
          else {
            widget.updateTool(
                editedShape: widget.currentElements[editingElement],
                enable: true);
            widget.currentElements[editingElement].focusNode.requestFocus();
          }
        },
        onLongPressStart: (event) {
          setState(() {
            editingElement = checkTextZones(event.localPosition);
          });
          widget.updateTool(
              editedShape: widget.currentElements[editingElement],
              point: event.localPosition,
              enable: true
          );
        },
        onLongPressMoveUpdate: (event) {
          widget.updateTool(
              editedShape: widget.currentElements[editingElement],
              point: event.localPosition,
              enable: true
          );
        },
        onLongPressEnd: (event) {
          widget.updateTool(
              editedShape: widget.currentElements[editingElement],
              enable: false);
        },
      );
    } else {
      return GestureDetector(
        onPanStart: (event) {
          setState(() {
            editingElement = checkTextZones(event.localPosition);
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
                  dashedArray: widget.dashArray,
                ));
                break;
              case DrawingTool.Arrow:
                widget.createTool(new ArrowLine(
                  start: event.localPosition,
                  paint: widget.paint,
                  dashedArray: widget.dashArray,
                ));
                break;
            }
          } else {
            widget.updateTool(
                editedShape: widget.currentElements[editingElement],
                point: event.localPosition);
          }
        },
        onPanUpdate: (event) {
          widget.updateTool(
              editedShape: editingElement == -1
                  ? null
                  : widget.currentElements[editingElement],
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
