import 'package:flutter/material.dart';
import 'package:hairdresser/paint_page/tools_list.dart';

class BottomBar extends StatelessWidget {
  final setTool;
  final DrawingTool currentTool;

  const BottomBar({this.setTool, required this.currentTool});

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
