import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hairdresser/paint_page/canvas_painter.dart';
import 'package:hairdresser/paint_page/color_panel_other_color_picker.dart';
import 'package:hairdresser/paint_page/stroke_width.dart';
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

  StrokeWidth _currentWidth = StrokeWidth.Light;
  DrawingTool _currentTool = DrawingTool.Brush;
  List<double> _currentDashArray = [1.0, 0.0];

  Paint _currentPaint = Paint()
    ..color = Colors.black
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 2
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
        color: color ?? _currentPaint.color,
        fontStyle: fontStyle,
        fontWeight: fontWeight,
        decoration: decoration,
      ));
      _currentPaint.color = color ?? _currentPaint.color;
      if (_shapeList.isNotEmpty && _shapeList.last.runtimeType == CanvasText)
        _shapeList.last.update(null, null, null, _textStyle);
    });
  }

  void setCurrentPaint({
    Color? color,
    StrokeWidth? strokeWidth,
    List<double>? dashArray,
  }) {
    setState(() {
      _currentWidth = strokeWidth??_currentWidth;
      _currentPaint.color = color ?? _currentPaint.color;
      _textStyle = _textStyle.merge(TextStyle(
        color: color,
      ));
      _currentPaint.strokeWidth = strokeWidth?.index.toDouble() ?? _currentPaint.strokeWidth;

      if (dashArray != null) {
        dashArray[0] *= _currentPaint.strokeWidth;
        dashArray[1] *= _currentPaint.strokeWidth;
      }
      _currentDashArray = dashArray ?? _currentDashArray;
    });
  }

  UpdateType updateType = UpdateType.AddPoint;
  List<Tool> _shapeList = [];
  List<Tool> _shapeUndoCache = [];
  List<Tool> _shapeTextList = [];

  void redo() {
    setState(() {
      _shapeList.add(_shapeUndoCache.removeLast());
      if (_shapeList.last.runtimeType == CanvasText)
        _shapeTextList.add(_shapeList.last);
    });
  }

  void undo() {
    setState(() {
        if (_shapeTextList.isNotEmpty && _shapeList.last == _shapeTextList.last)
          _shapeTextList.removeLast();
        _shapeUndoCache.add(_shapeList.removeLast());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onPanStart: (event) {
            setState(() {
              Paint paint = Paint()
                ..color = _currentPaint.color
                ..strokeWidth = (pow(_currentWidth.index.toInt() + 1, 2)).toDouble()
                ..blendMode = BlendMode.modulate
                ..strokeCap = StrokeCap.round
                ..style = PaintingStyle.stroke;
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
                    _shapeList.add(CurveLine(
                      start: event.localPosition,
                      paint: paint,
                      dashedArray: _currentDashArray,
                    ));
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
                          !_shapeList.last.hitZone(event.localPosition))) {
                    Paint paint = Paint()
                      ..color = Colors.transparent
                      ..strokeWidth = (pow(_currentWidth.index.toInt() + 1, 2)).toDouble()
                      ..blendMode = BlendMode.modulate
                      ..strokeCap = StrokeCap.round
                      ..style = PaintingStyle.stroke;
                    _shapeList.add(
                      CanvasText(
                        text: 'Введите текст',
                        start: event.localPosition,
                        paint: paint,
                        textStyle: _textStyle,
                      ),
                    );
                    _shapeTextList.add(_shapeList.last);
                  } else
                    _shapeList.last.start = event.localPosition;
                  break;

                case DrawingTool.Arrow:
                  if (_shapeList.isEmpty ||
                      (_shapeList.last.runtimeType != ArrowLine ||
                          !_shapeList.last.hitZone(event.localPosition))) {
                    updateType = UpdateType.SetEndPoint;
                    _shapeList.add(ArrowLine(
                      start: event.localPosition,
                      paint: paint,
                      dashedArray: _currentDashArray,
                    ));
                  } else {
                    updateType = UpdateType.SetCenterPoint;
                  }
                  break;
              }
            });
          },
          onPanUpdate: (event) {
            setState(() {
              if (_shapeList.last.runtimeType != CanvasText) {
                _shapeList.last.update(event.localPosition, updateType);
              }
            });
          },
          onPanEnd: (event) {},
          child: Container(
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
                      child: GestureDetector(
                        onLongPressStart: (event) {
                          setState(() {
                            _shapeTextList[index].paint.color = Colors.black;
                          });
                        },
                        onLongPressMoveUpdate: (event) {
                          setState(() {
                            _shapeTextList[index].update(event.globalPosition);
                          });
                        },
                        onLongPressEnd: (event) {
                          setState(() {
                            _shapeTextList[index].paint.color = Colors.transparent;
                          });
                        },
                        onDoubleTap: () {
                          setState(() {
                            _shapeTextList[index].enabled = true;
                          });
                          return _shapeTextList[index].focusNode.requestFocus();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: _shapeTextList[index].enabled ? Border.all(
                              width: 1,
                              style: BorderStyle.solid,
                            ) : null,
                          ),
                          width: 175,
                          child: TextField(
                            controller: _shapeTextList[index].text,
                            enabled: _shapeTextList[index].enabled,
                            focusNode: _shapeTextList[index].focusNode,
                            maxLength: 16,
                            onTap: () {
                              setState(() {
                                _shapeTextList[index].text.selection = TextSelection(
                                  baseOffset: 0,
                                  extentOffset: _shapeTextList[index].text.text.length,
                                );
                              });
                            },
                            onSubmitted: (value) {
                              setState(() {
                                _shapeTextList[index].enabled = false;
                                if (value.length == 0) {
                                  _shapeList.remove(_shapeTextList[index]);
                                  _shapeTextList.remove(_shapeTextList[index]);
                                }
                              });
                            },
                            style: _shapeTextList[index].textStyle,
                            decoration: InputDecoration.collapsed(
                              hintText: '',
                            ),
                            // _shapeTextList[index].text,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: BottomBar(
            setTool: setCurrentTool,
            currentTool: _currentTool,
            redoMethod: _shapeUndoCache.isEmpty ? null : redo,
            undoMethod: _shapeList.isEmpty ? null : undo,
          ),
        ),
        Positioned(
          bottom: 50,
          left: 0,
          child: ColorPanel(
            currentTool: _currentTool,
            setStyle: _currentTool != DrawingTool.Text
                ? setCurrentPaint
                : setCurrentTextStyle,
            currentWidth: _currentWidth,
          ),
        ),
        Positioned(
          top: 30,
          right: 15,
          child: FloatingActionButton(
            backgroundColor: Color(0xFFFF5668),
            child: Image(
              image: AssetImage('icons/help.png'),
              height: 60.0,
            ),
            onPressed: null,
          ),
        ),
      ],
    );
  }
}