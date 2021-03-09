import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hairdresser/paint_page/canvas_painter.dart';
import 'package:hairdresser/paint_page/tool.dart';
import 'package:hairdresser/paint_page/tools/arrow.dart';
import 'package:hairdresser/paint_page/tools/brush.dart';
import 'package:hairdresser/paint_page/tools/curve.dart';
import 'package:hairdresser/paint_page/tools/erase.dart';
import 'package:hairdresser/paint_page/tools/text.dart';
import 'package:hairdresser/paint_page/tools_list.dart';

import 'bottom_bar_v2.dart';

class PaintPage extends StatefulWidget {
  @override
  _PaintPageState createState() => _PaintPageState();
}

class _PaintPageState extends State<PaintPage> {
  final textController = TextEditingController();
  final fontSize = TextEditingController()..text = '16';

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  DrawingTool _currentTool = DrawingTool.Brush;

  void setCurrentTool(DrawingTool tool) {
    setState(() {
      _currentTool = tool;
    });
  }

  UpdateType updateType = UpdateType.AddPoint;
  List<Tool> _shapeList = [];
  List<Tool> _shapeUndoCache = [];
  List<Tool> _shapeTextList = [];

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
  List<bool> _fontStyleButtons = List<bool>.generate(3, (index) => false);

  Color _currentColor = Colors.black;
  double _colorPanelHeight = 0;
  double _stWidth = 0;

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
                ..blendMode = BlendMode.src
                ..style = PaintingStyle.stroke
                ..strokeWidth = _stWidth
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
                          ..strokeWidth = _stWidth
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

                case DrawingTool.Arrow:
                  if (_shapeList.isEmpty ||
                      (_shapeList.last.runtimeType != ArrowLine ||
                          !_shapeList.last.hitZone(event.localPosition))) {
                    updateType = UpdateType.SetEndPoint;
                    _shapeList.add(ArrowLine(
                        start: event.localPosition,
                        paint: Paint()
                          ..color = _currentColor
                          ..blendMode = BlendMode.color
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = _stWidth
                          ..strokeCap = StrokeCap.round));
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
          child: BottomBar(setTool: setCurrentTool, currentTool: _currentTool),
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
                if (_currentTool == DrawingTool.Text)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            alignment: AlignmentDirectional.centerStart,
                            height: 40,
                            width: 20,
                            child: Text(
                              'Aa',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                            width: 75,
                            child: TextField(
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              controller: fontSize,
                              maxLines: 1,
                              decoration: InputDecoration(
                                focusColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: BorderSide(
                                    width: 1,
                                    style: BorderStyle.solid,
                                    color: Colors.white,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: BorderSide(
                                    width: 1,
                                    style: BorderStyle.solid,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              onSubmitted: (_) {
                                setState(() {
                                  if (_shapeList.last.runtimeType ==
                                      CanvasText) {
                                    // _shapeList.last.update(
                                    //   null,
                                    //   UpdateType.AddPoint,
                                    //   null,
                                    //   TextStyle(
                                    //     fontSize: double.parse(fontSize.text),
                                    //     fontWeight: _fontStyleButtons[0]
                                    //         ? FontWeight.bold
                                    //         : FontWeight.normal,
                                    //     fontStyle: _fontStyleButtons[1]
                                    //         ? FontStyle.italic
                                    //         : FontStyle.normal,
                                    //     decoration: _fontStyleButtons[2]
                                    //         ? TextDecoration.underline
                                    //         : TextDecoration.none,
                                    //   ),
                                    // );
                                    _shapeTextList.last.update(
                                      null,
                                      UpdateType.AddPoint,
                                      null,
                                      TextStyle(
                                        fontSize: double.parse(fontSize.text),
                                        fontWeight: _fontStyleButtons[0]
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        fontStyle: _fontStyleButtons[1]
                                            ? FontStyle.italic
                                            : FontStyle.normal,
                                        decoration: _fontStyleButtons[2]
                                            ? TextDecoration.underline
                                            : TextDecoration.none,
                                      ),
                                    );
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      ToggleButtons(
                        children: [
                          Icon(
                            Icons.format_bold,
                            size: 20,
                            color: Colors.white,
                          ),
                          Icon(
                            Icons.format_italic,
                            size: 20,
                            color: Colors.white,
                          ),
                          Icon(
                            Icons.format_underline,
                            size: 20,
                            color: Colors.white,
                          ),
                        ],
                        constraints:
                            BoxConstraints(minHeight: 20, minWidth: 20),
                        renderBorder: false,
                        isSelected: _fontStyleButtons,
                        onPressed: (int index) {
                          setState(() {
                            _fontStyleButtons[index] =
                                !_fontStyleButtons[index];
                            if (_shapeList.last.runtimeType == CanvasText) {
                              _shapeList.last.update(
                                null,
                                UpdateType.AddPoint,
                                null,
                                TextStyle(
                                  fontSize: double.parse(fontSize.text),
                                  fontWeight: _fontStyleButtons[0]
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  fontStyle: _fontStyleButtons[1]
                                      ? FontStyle.italic
                                      : FontStyle.normal,
                                  decoration: _fontStyleButtons[2]
                                      ? TextDecoration.underline
                                      : TextDecoration.none,
                                ),
                              );
                            }
                          });
                        },
                      )
                    ],
                  )
                else
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
                                _stWidth = pow(2, index).toDouble();
                              });
                            },
                            child: Ink(
                              child: Image(
                                color: _strokeWidth[index]
                                    ? Color(0xff4D53E0)
                                    : null,
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
                    paint: Paint()
                      ..color = _currentColor
                      ..blendMode = BlendMode.color
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 5
                      ..strokeCap = StrokeCap.round));
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
