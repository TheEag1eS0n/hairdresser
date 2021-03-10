import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hairdresser/paint_page/tools_list.dart';

class ColorPanel extends StatefulWidget {
  final setStyle;
  final currentTool;

  ColorPanel({this.setStyle, this.currentTool});


  @override
  _ColorPanelState createState() => _ColorPanelState();
}

class _ColorPanelState extends State<ColorPanel> {
  final fontSize = TextEditingController()..text = '16';

  List<bool> fontStyleSelected = List.generate(3, (index) => false);
  List<bool> selected = List.generate(18, (index) => index == 0);
  List<bool> brushSizeSelected = List.generate(5, (index) => index == 0);

  List<Color> colors = [
    Colors.black,
    Colors.red,
    Colors.blue,
    Colors.lime,
    Colors.indigo,
    Colors.cyan,
    Colors.green,
  ];

  get setStyle => widget.setStyle;
  DrawingTool get currentTool => widget.currentTool;

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
                      setState(() {
                        for (int i = 0; i < selected.length; i++)
                          selected[i] = i == index;
                        print(selected);
                      });
                      widget.setStyle(color: colors[index % colors.length]);
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
                          setState(() {
                            fontSize.text = value;
                          });
                          setStyle(fontSize: double.parse(value));
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
                  selectedColor: Colors.black.withOpacity(0.5),
                  onPressed: (index) {
                    setState(() {
                      fontStyleSelected[index] = !fontStyleSelected[index];
                    });
                    print(index);
                    setStyle(
                        fontWeight: fontStyleSelected[0]?FontWeight.bold:FontWeight.normal,
                        fontStyle: fontStyleSelected[1]?FontStyle.italic:FontStyle.normal,
                        decoration: fontStyleSelected[2]?TextDecoration.underline:TextDecoration.none,
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
