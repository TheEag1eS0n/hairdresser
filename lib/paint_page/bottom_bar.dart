import 'package:flutter/material.dart';

enum DrawingTool { Brush, Curve, Eraser, Text, Arrow }

class BottomBar extends StatefulWidget {
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  DrawingTool get currentTool => _currentTool;

  Color _currentColor = Colors.black;
  DrawingTool _currentTool = DrawingTool.Brush;

  Paint _paint = Paint()
    ..color = Colors.black
    ..strokeCap = StrokeCap.round;

  List<bool> get selected {
    var buttons = List.generate(5, (_) => false);
    buttons[_currentTool.index] = true;
    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
              Icon(
                Icons.arrow_upward,
                size: 20,
                color: Colors.white,
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
                constraints: BoxConstraints(minHeight: 30, minWidth: 30),
                onPressed: null,
              ),
              IconButton(
                icon: Icon(
                  Icons.redo,
                  color: Colors.white,
                ),
                splashRadius: 20,
                disabledColor: Colors.black.withOpacity(.5),
                padding: new EdgeInsets.all(0),
                constraints: BoxConstraints(minHeight: 40, minWidth: 40),
                onPressed: null,
              ),
            ],
          )
        ],
      ),
    );
  }
}