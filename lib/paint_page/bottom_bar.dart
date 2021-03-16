import 'package:flutter/material.dart';
import 'package:hairdresser/paint_page/tools_list.dart';

class BottomBar extends StatelessWidget {
  final setTool;
  final DrawingTool currentTool;

  final undoMethod;
  final redoMethod;

  BottomBar({this.setTool, required this.currentTool, required this.undoMethod, required this.redoMethod});

  List<bool> get selected {
    var buttons = List.generate(5, (_) => false);
    buttons[currentTool.index] = true;
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
              Image(
                image: AssetImage('icons/brush.png'),
                height: 20,
                width: 20,
              ),
              Image(
                image: AssetImage('icons/line_curve.png'),
                height: 20,
                width: 20,
              ),
              Image(
                image: AssetImage('icons/eraser.png'),
                height: 20,
                width: 20,
              ),
              Image(
                image: AssetImage('icons/text.png'),
                height: 20,
                width: 20,
              ),
              Image(
                image: AssetImage('icons/arrow.png'),
                height: 20,
                width: 20,
              ),
            ],
            isSelected: selected,
            color: Color(0xff4D53E0),
            onPressed: (int index) {
              setTool(DrawingTool.values[index]);
            },
            constraints: BoxConstraints(minHeight: 50, minWidth: 50),
            renderBorder: false,
          ),
          ButtonBar(
            children: [
              IconButton(
                icon: Icon(
                  Icons.undo,
                  color: Colors.white,
                ),
                splashRadius: 15,
                disabledColor: Colors.black.withOpacity(0.1),
                padding: new EdgeInsets.all(0),
                constraints: BoxConstraints(minHeight: 30, minWidth: 30),
                onPressed: undoMethod,
              ),
              IconButton(
                icon: Icon(
                  Icons.redo,
                  color: Colors.white,
                ),
                splashRadius: 20,
                disabledColor: Colors.black.withOpacity(0.1),
                padding: new EdgeInsets.all(0),
                constraints: BoxConstraints(minHeight: 40, minWidth: 40),
                onPressed: redoMethod,
              ),
            ],
          )
        ],
      ),
    );
  }
}
