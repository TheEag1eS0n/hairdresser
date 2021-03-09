import 'package:flutter/material.dart';

class ColorPanel extends StatelessWidget {

  final setColor;
  final Color currentColor;

  const ColorPanel({this.setColor, required this.currentColor});

  List<Color> get colors => [
    Colors.black,
    Colors.red,
    Colors.blue,
    Colors.lime,
    Colors.indigo,
    Colors.cyan,
    Colors.green,
  ];

  List<bool> get selected {
    var buttons = List.generate(18, (_) => false);
    buttons[0] = true;
    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      alignment: Alignment.centerLeft,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOut,
      height: 300,
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
                  selected.length,
                      (index) => InkWell(
                    onTap: () => setColor(colors[index]),
                    child: Ink(
                      child: Container(
                        decoration: BoxDecoration(
                          color: colors[index % colors.length],
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(
                              color: selected[index]
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
    );
  }
}