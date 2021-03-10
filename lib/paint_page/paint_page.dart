import 'package:flutter/material.dart';
import 'package:hairdresser/paint_page/canvas_painter.dart';
import 'package:hairdresser/paint_page/color_panel.dart';
import 'package:hairdresser/paint_page/tool.dart';
import 'package:hairdresser/paint_page/tools/arrow.dart';
import 'package:hairdresser/paint_page/tools/brush.dart';
import 'package:hairdresser/paint_page/tools/curve.dart';
import 'package:hairdresser/paint_page/tools/erase.dart';
import 'package:hairdresser/paint_page/tools/text.dart';
import 'package:hairdresser/paint_page/tools_list.dart';

import 'bottom_bar.dart';

class PaintPage extends StatefulWidget {
  @override
  _PaintPageState createState() => _PaintPageState();
}

class _PaintPageState extends State<PaintPage> {
  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  DrawingTool _currentTool = DrawingTool.Brush;
  Paint _currentPaint = Paint()
    ..color = Colors.black
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 4
    ..style = PaintingStyle.stroke;

  TextStyle _textStyle = TextStyle(
    color: Colors.black,
    fontSize: 16,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
    fontWeight: FontWeight.normal,
  );

  void setCurrentTool(DrawingTool tool) {
    setState(() {
      _currentTool = tool;
    });
  }

  void setCurrentTextStyle(
      {Color? color,
      double? fontSize,
      FontWeight? fontWeight,
      FontStyle? fontStyle,
      TextDecoration? decoration}) {
    setState(() {
      _textStyle = _textStyle.merge(TextStyle(
        fontSize: fontSize,
        color: color?? _currentPaint.color,
        fontStyle: fontStyle,
        fontWeight: fontWeight,
        decoration: decoration,
      ));
      _currentPaint.color = color?? _currentPaint.color;
      if (_shapeList.isNotEmpty && _shapeList.last.runtimeType == CanvasText)
        _shapeList.last.update(null, null, null, _textStyle);
    });
  }

  void setCurrentPaint({Color? color, double? strokeWidth}) {
    setState(() {
      _currentPaint.color = color!;
      _textStyle = _textStyle.merge(TextStyle(
        color: color,
      ));
      _currentPaint.strokeWidth = strokeWidth ?? _currentPaint.strokeWidth;
    });
  }

  UpdateType updateType = UpdateType.AddPoint;
  List<Tool> _shapeList = [];
  List<Tool> _shapeUndoCache = [];
  List<Tool> _shapeTextList = [];

  void addRedoCache() {
    setState(() {
      _shapeList.add(_shapeUndoCache.removeLast());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onPanStart: (event) {
            setState(() {
              Paint paint = _currentPaint;
              _shapeUndoCache = [];
              switch (_currentTool) {
                case DrawingTool.Brush:
                  updateType = UpdateType.AddPoint;
                  _shapeList
                      .add(Brush(start: event.localPosition, paint: paint));
                  break;
                case DrawingTool.Curve:
                  if (_shapeList.isEmpty ||
                      (_shapeList.last.runtimeType != CurveLine ||
                          !_shapeList.last.hitZone(event.localPosition))) {
                    updateType = UpdateType.SetEndPoint;
                    _shapeList.add(
                        CurveLine(start: event.localPosition, paint: paint));
                  } else {
                    updateType = UpdateType.SetCenterPoint;
                  }

                  break;
                case DrawingTool.Eraser:
                  updateType = UpdateType.AddPoint;
                  _shapeList.add(Erase(start: event.localPosition));
                  break;
                case DrawingTool.Text:
                  if (_shapeList.isEmpty ||
                      (_shapeList.last.runtimeType != CanvasText ||
                          !_shapeList.last.hitZone(event.localPosition)))
                    _showDialog(event.localPosition);
                  else
                    _shapeList.last.start = event.localPosition;
                  break;

                case DrawingTool.Arrow:
                  if (_shapeList.isEmpty ||
                      (_shapeList.last.runtimeType != ArrowLine ||
                          !_shapeList.last.hitZone(event.localPosition))) {
                    updateType = UpdateType.SetEndPoint;
                    _shapeList.add(
                        ArrowLine(start: event.localPosition, paint: paint));
                  } else {
                    updateType = UpdateType.SetCenterPoint;
                  }
                  break;
              }
            });
          },
          onPanUpdate: (event) {
            setState(() {
              _shapeList.last.update(event.localPosition, updateType);
            });
          },
          onPanEnd: (event) {},
          child: Stack(
            children: [
              CustomPaint(
                foregroundPainter: ShapesCanvas(shapes: _shapeList),
                child: Center(
                  child: Image.asset('images/bg-head.png'),
                ),
              ),
              Stack(
                children: List.generate(
                  _shapeTextList.length,
                  (index) => Positioned(
                    left: _shapeTextList[index].start.dx,
                    top: _shapeTextList[index].start.dy,
                    child: Text(
                      _shapeTextList[index].text,
                      style: _shapeTextList[index].textStyle,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: BottomBar(
            setTool: setCurrentTool,
            currentTool: _currentTool,
          ),
        ),
        Positioned(
          bottom: 50,
          left: 0,
          width: 200,
          height: 200,
          child: ColorPanel(
            currentTool: _currentTool,
            setStyle: _currentTool != DrawingTool.Text
                ? setCurrentPaint
                : setCurrentTextStyle,
          ),
        ),
      ],
    );
  }

  _showDialog(Offset position) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Что хотите написать?'),
        content: Form(
          child: TextFormField(
            controller: textController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Напишите что-нибудь :)';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _shapeList.add(CanvasText(
                    text: textController.text,
                    start: position,
                    paint: _currentPaint,
                    textStyle: _textStyle));
                _shapeTextList.add(_shapeList.last);
              });
            },
            child: Text('SUBMIT'),
          ),
        ],
      ),
    );
  }
}

class BottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 200,
        color: Colors.amber,
      ),
      onTap: () => Navigator.pop(context),
    );
  }
}
