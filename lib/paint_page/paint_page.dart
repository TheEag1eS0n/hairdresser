import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hairdresser/paint_page/advanced_widgets/gesture_widget.dart';
import 'package:hairdresser/paint_page/canvas_painter.dart';
import 'package:hairdresser/paint_page/color_panel_other_color_picker.dart';
import 'package:hairdresser/paint_page/stroke_width.dart';
import 'package:hairdresser/paint_page/tool.dart';
import 'package:hairdresser/paint_page/tools/arrow.dart';
import 'package:hairdresser/paint_page/tools/curve.dart';
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
    ..strokeWidth = 1
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
        color: color,
        fontStyle: fontStyle,
        fontWeight: fontWeight,
        decoration: decoration,
      ));
      _currentPaint.color = color ?? _currentPaint.color;
    });
  }

  void setCurrentPaint({
    Color? color,
    StrokeWidth? strokeWidth,
    List<double>? dashArray,
  }) {
    setState(() {
      _currentWidth = strokeWidth ?? _currentWidth;
      _currentPaint = new Paint()
        ..color = color ?? _currentPaint.color
        ..strokeWidth = (_currentWidth.index + 1).toDouble()
        ..style = PaintingStyle.stroke
        ..blendMode = BlendMode.color
        ..strokeCap = StrokeCap.round;

      _textStyle = _textStyle.merge(TextStyle(
        color: color,
      ));

      if (dashArray != null) {
        dashArray[0] *= _currentPaint.strokeWidth;
        dashArray[1] *= _currentPaint.strokeWidth;
      }
      _currentDashArray = dashArray ?? _currentDashArray;
    });
  }

  UpdateType updateType = UpdateType.AddPoint;

  List<Tool> _shapeAllList = [];
  List<Tool> _shapeLineList = [];
  List<Tool> _shapeArrowList = [];
  List<Tool> _shapeTextList = [];

  List<Tool> _shapeUndoCache = [];

  void addToList(Tool tool) {
    setState(() {
      switch (tool.runtimeType) {
        case CanvasText:
          _shapeTextList.add(tool);
          break;
        case ArrowLine:
          _shapeArrowList.add(tool);
          break;
        case CurveLine:
          _shapeLineList.add(tool);
          break;
      }
    });
  }

  void redo() {
    setState(() {
      _shapeAllList.add(_shapeUndoCache.removeLast());
      addToList(_shapeAllList.last);
    });
  }

  void undo() {
    setState(() {
      if (_shapeTextList.isNotEmpty &&
          _shapeAllList.last == _shapeTextList.last)
        _shapeTextList.removeLast();
      _shapeUndoCache.add(_shapeAllList.removeLast());
    });
  }

  void clearRedoCache() {
    setState(() {
      _shapeUndoCache = [];
    });
  }

  void create(Tool tool) {
    setState(() {
      _shapeAllList.add(tool);
      clearRedoCache();
      switch (_currentTool) {
        case DrawingTool.Curve:
          _shapeLineList.add(_shapeAllList.last);
          break;
        case DrawingTool.Arrow:
          _shapeArrowList.add(_shapeAllList.last);
          break;
        case DrawingTool.Text:
          _shapeTextList.add(_shapeAllList.last);
          break;
      }
    });
  }

  void update({Tool? editedShape, Offset? point, bool? enable }) {
    setState(() {
      editedShape?.update(point: point, updateType: UpdateType.SetCenterPoint, enabled: enable ?? false);
      if (editedShape == null) _shapeAllList.last.update(point: point);
    });
  }

  List<Tool> get currentList {
    switch (_currentTool) {
      case DrawingTool.Curve:
        return _shapeLineList;
      case DrawingTool.Arrow:
        return _shapeArrowList;
      case DrawingTool.Text:
        return _shapeTextList;
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomPaint(
            foregroundPainter: ShapesCanvas(shapes: _shapeAllList),
            child: Center(
              child: Image.asset('./assets/images/bg-head.png'),
            ),
          ),
          Stack(
            children: List.generate(
              _shapeTextList.length,
              (index) => Positioned(
                left: _shapeTextList[index].start.dx,
                top: _shapeTextList[index].start.dy,
                child: Container(
                  decoration: BoxDecoration(
                    border: _shapeTextList[index].enabled
                        ? Border.all(
                            width: 1,
                            style: BorderStyle.solid,
                          )
                        : null,
                    borderRadius: BorderRadius.all(Radius.circular(5.0))
                  ),
                  width: _shapeTextList[index].textPainter.size.width + 20,
                  child: TextField(
                    minLines: 1,
                    maxLines: 1,
                    maxLength: 16,
                    controller: _shapeTextList[index].text,
                    enabled: _shapeTextList[index].enabled,
                    focusNode: _shapeTextList[index].focusNode,
                    onSubmitted: (value) {
                      setState(() {
                        _shapeTextList[index].enabled = false;
                        if (value.length == 0) {
                          _shapeAllList.remove(_shapeTextList[index]);
                          _shapeTextList.remove(_shapeTextList[index]);
                        }
                      });
                    },
                    style: _shapeTextList[index].textStyle,
                    decoration: InputDecoration.collapsed(
                      hintText: '',
                      border: InputBorder.none,
                    ),
                    // _shapeTextList[index].text,
                  ),
                ),
              ),
            ),
          ),
          GestureWidget(
            currentTool: _currentTool,
            paint: _currentPaint,
            textStyle: _textStyle,
            createTool: create,
            updateTool: update,
            currentElements: currentList,
            dashArray: _currentDashArray,
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
            bottom: 0,
            left: 0,
            right: 0,
            child: BottomBar(
              setTool: setCurrentTool,
              currentTool: _currentTool,
              redoMethod: _shapeUndoCache.isEmpty ? null : redo,
              undoMethod: _shapeAllList.isEmpty ? null : undo,
            ),
          ),
        ],
      ),
    );
  }
}
