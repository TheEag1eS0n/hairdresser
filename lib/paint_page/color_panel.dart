import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hairdresser/paint_page/tools_list.dart';

class ColorPanel extends StatelessWidget {
  final setStyle;
  final currentTool;
  final currentStyle;

  ColorPanel({this.setStyle, this.currentStyle, this.currentTool});

  List<Color> get colors => [
        Colors.black,
        Colors.red,
        Colors.blue,
        Colors.lime,
        Colors.indigo,
        Colors.cyan,
        Colors.green,
      ];

  final fontSize = TextEditingController()..text = '16';

  List<bool> get fontStyleSelected => List.generate(3, (_) => false);
  List<bool> get selected => List.generate(18, (index) => colors.indexOf(currentStyle.color) == index);
  List<bool> get brushSizeSelected => List.generate(5, (index) => currentStyle.strokeWidth == pow(2, index));

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
                    onTap: () {
                      setStyle(colors[index % colors.length]);
                    },
                    child: Ink(
                      child: Container(
                        decoration: BoxDecoration(
                          color: colors[index % colors.length],
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(
                              color:
                                  selected[index] ? Colors.amber : Colors.white,
                              width: 1),
                        ),
                        width: 10,
                        height: 10,
                      ),
                    ),
                  ),
                ),
              )),
          if (currentTool == DrawingTool.Text)
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
                        onSubmitted: (value) {
                          // setStyle(double.parse(source));
                          print(value);
                        },
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
                  constraints: BoxConstraints(minHeight: 20, minWidth: 20),
                  renderBorder: false,
                  isSelected: fontStyleSelected,
                  onPressed: (int index) {
                    fontStyleSelected[index] = !fontStyleSelected[index];
                    setStyle(
                      fontStyleSelected[0]?FontWeight.bold:null,
                      fontStyleSelected[1]?FontStyle.italic:null,
                      fontStyleSelected[0]?TextDecoration.underline:null,
                    );
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
                    5,
                    (index) => InkWell(
                      onTap: () {
                        setStyle(pow(2, index));
                      },
                      child: Ink(
                        child: Image(
                          color: Color(0xff4D53E0),
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
