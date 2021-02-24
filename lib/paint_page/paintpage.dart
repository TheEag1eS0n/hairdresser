import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:hairdresser/paint_page/canvasPainter.dart';
import 'package:hairdresser/paint_page/tool.dart';
import 'package:hairdresser/paint_page/tools/brush.dart';
import 'package:hairdresser/paint_page/tools/curve.dart';
import 'package:hairdresser/paint_page/tools/erase.dart';
import 'package:hairdresser/paint_page/tools/text.dart';

class PaintPage extends StatefulWidget {
  @override
  _PaintPageState createState() => _PaintPageState();
}

enum DrawingTool { Brush, Curve, Eraser, Text }

class _PaintPageState extends State<PaintPage> {
  final textController = TextEditingController();
  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  DrawingTool _currentTool = DrawingTool.Brush;
  UpdateType updateType = UpdateType.AddPoint;
  List<Tool> _shapeList = [];
  List<Tool> _shapeUndoCache = [];

  List<Color> _colors = [
    Colors.black,
    Colors.red,
    Colors.blue,
    Colors.lime,
    Colors.indigo,
    Colors.cyan,
    Colors.green,
  ];
  List<bool> _colorSelected = List<bool>.generate(18, (index) => index == 0);
  List<bool> _strokeWidth = List<bool>.generate(5, (index) => index == 0);

  Color _currentColor = Colors.black;
  double _colorPanelHeight = 0;

  List<bool> get selected {
    var buttons = List.generate(4, (_) => false);
    buttons[_currentTool.index] = true;
    return buttons;
  }

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
              Paint paint = Paint()
                ..color = _currentColor
                ..blendMode = BlendMode.color
                ..style = PaintingStyle.stroke
                ..strokeWidth = 5
                ..strokeCap = StrokeCap.round;
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
                        paint: Paint()
                          ..color = _currentColor
                          ..blendMode = BlendMode.color
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 5
                          ..strokeCap = StrokeCap.round));
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
              }
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
                color: Color(0xff3d3d3d),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ToggleButtons(
                    children: <Widget>[
                      Icon(
                        Icons.brush,
                        size: 20,
                        color: Colors.white,
                      ),
                      Icon(
                        Icons.call,
                        size: 20,
                        color: Colors.white,
                      ),
                      Icon(
                        Icons.cake,
                        size: 20,
                        color: Colors.white,
                      ),
                      Icon(
                        Icons.text_fields,
                        size: 20,
                        color: Colors.white,
                      ),
                    ],
                    isSelected: selected,
                    onPressed: (int index) {
                      setState(() {
                        _colorPanelHeight =
                            DrawingTool.values[index] == _currentTool ? 150 : 0;
                        _currentTool = DrawingTool.values[index];
                      });
                    },
                    constraints: BoxConstraints(minHeight: 50, minWidth: 50),
                    renderBorder: false,
                    splashColor: _currentColor.withOpacity(0.25),
                    highlightColor: _currentColor.withOpacity(0.5),
                    selectedColor: _currentColor,
                    fillColor: _currentColor.withOpacity(0.1),
                  ),
                  ButtonBar(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.undo,
                          color: Colors.white,
                        ),
                        splashRadius: 15,
                        disabledColor: Colors.black.withOpacity(.5),
                        padding: new EdgeInsets.all(0),
                        constraints:
                            BoxConstraints(minHeight: 30, minWidth: 30),
                        onPressed: _shapeList.isEmpty
                            ? null
                            : () {
                                setState(() {
                                  _shapeUndoCache.add(_shapeList.removeLast());
                                });
                              },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.redo,
                          color: Colors.white,
                        ),
                        splashRadius: 20,
                        disabledColor: Colors.black.withOpacity(.5),
                        padding: new EdgeInsets.all(0),
                        constraints:
                            BoxConstraints(minHeight: 40, minWidth: 40),
                        onPressed:
                            _shapeUndoCache.isEmpty ? null : addRedoCache,
                      ),
                    ],
                  )
                ],
              )),
        ),
        Positioned(
          bottom: 50,
          left: 0,
          width: 200,
          child: AnimatedContainer(
            alignment: Alignment.centerLeft,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeOut,
            height: _colorPanelHeight,
            color: Color(0xff3d3d3d),
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Ink(
                    height: 100,
                    child: GridView.count(
                      crossAxisCount: 6,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      children: List.generate(
                        _colorSelected.length,
                        (index) => InkWell(
                          onTap: () {
                            setState(() {
                              _colorPanelHeight = 0;
                              for (int indexBtn = 0;
                                  indexBtn < _colorSelected.length;
                                  indexBtn++) {
                                _colorSelected[indexBtn] = indexBtn == index;
                              }
                              _currentColor = _colors[index % _colors.length];
                            });
                          },
                          child: Ink(
                            child: Container(
                              decoration: BoxDecoration(
                                color: _colors[index % _colors.length],
                                borderRadius: BorderRadius.circular(3),
                                border: Border.all(
                                    color: _colorSelected[index]
                                        ? Colors.white
                                        : Colors.white,
                                    width: 1),
                              ),
                              width: 10,
                              height: 10,
                            ),
                          ),
                        ),
                      ),
                    )),
                Ink(
                    height: 30,
                    child: GridView.count(
                      crossAxisCount: 5,
                      children: List.generate(
                        _strokeWidth.length,
                        (index) => InkWell(
                          onTap: () {
                            setState(() {
                              for (int indexBtn = 0;
                                  indexBtn < _strokeWidth.length;
                                  indexBtn++) {
                                _strokeWidth[indexBtn] = indexBtn == index;
                              }
                            });
                          },
                          child: Ink(
                            child: Image(
                              image: AssetImage('icons/line${index + 1}.png'),
                              height: 30,
                              width: 30,
                            ),
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _showDialog(Offset position) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Что хотите написать'),
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
                    paint: Paint()
                      ..color = _currentColor
                      ..blendMode = BlendMode.color
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 5
                      ..strokeCap = StrokeCap.round));
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
