import 'package:flutter/material.dart';
import 'package:hairdresser/paint_page/canvasPainter.dart';
import 'package:hairdresser/paint_page/tool.dart';
import 'package:hairdresser/paint_page/tools/brush.dart';
import 'package:hairdresser/paint_page/tools/curve.dart';
import 'package:hairdresser/paint_page/tools/erase.dart';

class PaintPage extends StatefulWidget {
  @override
  _PaintPageState createState() => _PaintPageState();
}

enum DrawingTool { Brush, Curve, Eraser }

class _PaintPageState extends State<PaintPage> {
  DrawingTool _currentTool = DrawingTool.Brush;
  UpdateType updateType = UpdateType.AddPoint;
  List<Tool> _shapeList = [];
  List<Tool> _shapeUndoCahce = [];
  int step = 0;

  List<bool> get selected {
    var buttons = List.generate(3, (_) => false);
    buttons[_currentTool.index] = true;
    return buttons;
  }

  void addRedoCache () {
    setState(() {
      _shapeList.add(_shapeUndoCahce.removeLast());
    });
  }

  Color currentColor = Colors.red;

  double _brushSize = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onPanStart: (event) {
              setState(() {
                _shapeUndoCahce = [];
                switch (_currentTool) {
                  case DrawingTool.Brush:
                    updateType = UpdateType.AddPoint;
                    _shapeList.add(Brush(
                        start: event.localPosition,
                        paint: Paint()
                          ..color = currentColor
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 5
                          ..strokeCap = StrokeCap.round));
                    break;
                  case DrawingTool.Curve:
                    if (_shapeList.isEmpty ||
                        (_shapeList.last.runtimeType != CurveLine ||
                            !_shapeList.last.hitZone(event.localPosition))) {
                      updateType = UpdateType.SetEndPoint;
                      _shapeList.add(CurveLine(
                          start: event.localPosition,
                          paint: Paint()
                            ..color = currentColor
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 5
                            ..strokeCap = StrokeCap.round));
                    } else {
                      // print('Can curve');
                      updateType = UpdateType.SetCenterPoint;
                    }

                    break;
                  case DrawingTool.Eraser:
                    print('eraser');
                    _shapeList.add(Erase(start: event.localPosition));
                    break;
                }
                // print(_shapeList.last.runtimeType);
              });
            },
            onPanUpdate: (event) {
              setState(() {
                _shapeList.last.update(event.localPosition, updateType);
              });
            },
            onPanEnd: (event) {},
            child: CustomPaint(
              foregroundPainter: ShapesCanvas(shapes: _shapeList),
              child: Center(
                child: Image.asset('images/bg-head.png'),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
                padding: EdgeInsets.all(0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ToggleButtons(
                      children: <Widget>[
                        Icon(
                          Icons.brush,
                          size: 20,
                        ),
                        Icon(
                          Icons.call,
                          size: 20,
                        ),
                        Icon(
                          Icons.cake,
                          size: 20,
                        ),
                      ],
                      isSelected: selected,
                      onPressed: (int index) {
                        setState(() {
                          _currentTool = DrawingTool.values[index];
                        });
                      },
                      constraints: BoxConstraints(minHeight: 50, minWidth: 50),
                      renderBorder: false,
                      splashColor: currentColor.withOpacity(0.25),
                      highlightColor: currentColor.withOpacity(0.5),
                      selectedColor: currentColor,
                      fillColor: currentColor.withOpacity(0.1),
                    ),
                    ButtonBar(
                      children: [
                        IconButton(
                            icon: Icon(Icons.undo),
                            splashRadius: 15,
                            disabledColor: Colors.black.withOpacity(.5),
                            padding: new EdgeInsets.all(0),
                            constraints:
                                BoxConstraints(minHeight: 30, minWidth: 30),
                            onPressed: () {
                              setState(() {
                                _shapeUndoCahce.add(_shapeList.removeLast());
                              });
                            }),
                        IconButton(
                          icon: Icon(Icons.redo),
                          splashRadius: 20,
                          disabledColor: Colors.black.withOpacity(.5),
                          padding: new EdgeInsets.all(0),
                          constraints:
                              BoxConstraints(minHeight: 40, minWidth: 40),
                          onPressed: _shapeUndoCahce.isEmpty ? null : addRedoCache,
                        ),
                      ],
                    )
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
