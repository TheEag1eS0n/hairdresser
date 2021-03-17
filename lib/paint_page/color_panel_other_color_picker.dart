import 'dart:math';

import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hairdresser/paint_page/stroke_width.dart';
import 'package:hairdresser/paint_page/tools_list.dart';

class ColorPanel extends StatefulWidget {
  final setStyle;
  final currentTool;
  StrokeWidth currentWidth;

  ColorPanel({this.setStyle, this.currentTool, required this.currentWidth});

  @override
  _ColorPanelState createState() => _ColorPanelState();
}

class _ColorPanelState extends State<ColorPanel> {
  final fontSize = TextEditingController()..text = '16';

  List<bool> fontStyleSelected = List.generate(3, (index) => false);
  List<bool> selected = List.generate(18, (index) => false);
  List<bool> get brushSizeSelected =>
      List.generate(5, (index) => index == widget.currentWidth.index);
  List<bool> dashedBrushSizeSelected = List.generate(2, (index) => false);

  List<Color> colors = [
    Colors.white,
    Color(0xffF6B480),
    Color(0xffFEE99E),
    Color(0xffB8FFAC),
    Color(0xffBEE9ED),
    Color(0xffFF97A2),
    Color(0xffBDBDBD),
    Color(0xffFF8E36),
    Color(0xffFFDF37),
    Color(0xff68C548),
    Color(0xff41D5E2),
    Color(0xffFF5668),
    Color(0x0),
    Color(0x0),
    Color(0x0),
    Color(0x0),
    Color(0x0),
    Color(0x0),
    Color(0x0),
  ];

  Color customColor = Colors.transparent;
  int item = 0;

  get setStyle => widget.setStyle;
  DrawingTool get currentTool => widget.currentTool;
  bool showColorPicker = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Color(0xff3d3d3d),
        boxShadow: [
          BoxShadow(
            offset: Offset(1, 4),
            blurRadius: 10.0,
            spreadRadius: 1.0,
          )
        ],
      ),
      width: 200,
      child: Column(
        children: [
          AnimatedContainer(
              duration: Duration(milliseconds: 500),
              height: currentTool != DrawingTool.Eraser ? 100 : 0,
              child: GridView.count(
                crossAxisCount: 6,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                children: List.generate(
                  selected.length,
                  (index) => InkWell(
                    onDoubleTap: () {
                      setState(() {
                        for (int i = 0; i < selected.length; i++)
                          selected[i] = i == index;
                        showColorPicker = true;
                        item = index;
                        customColor = colors[index];
                      });
                    },
                    onTap: () {
                      setState(() {
                        for (int i = 0; i < selected.length; i++)
                          selected[i] = i == index;
                        showColorPicker = colors[index] == Colors.transparent;
                        item = showColorPicker ? index : 0;
                        customColor = Colors.red;
                      });
                      setStyle(
                          color: colors[index] != Colors.transparent
                              ? colors[index]
                              : null);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: index < colors.length
                            ? colors[index]
                            : Colors.transparent,
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
              )),
          if (currentTool == DrawingTool.Text)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        alignment: AlignmentDirectional.centerStart,
                        height: 25,
                        width: 25,
                        child: Text(
                          'Aa',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        height: 25,
                        width: 40,
                        alignment: AlignmentDirectional.centerStart,
                        padding: EdgeInsets.symmetric(
                          horizontal: 3,
                        ),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              style: BorderStyle.solid,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(3)),
                        child: TextField(
                          onSubmitted: (value) {
                            setState(() {
                              fontSize.text = value;
                            });
                            setStyle(fontSize: double.parse(value));
                          },
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          controller: fontSize,
                          maxLines: 1,
                          decoration: InputDecoration.collapsed(
                            hintText: '',
                          ),
                        ),
                      ),
                    ],
                  ),
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
                    setStyle(
                      fontWeight: fontStyleSelected[0]
                          ? FontWeight.bold
                          : FontWeight.normal,
                      fontStyle: fontStyleSelected[1]
                          ? FontStyle.italic
                          : FontStyle.normal,
                      decoration: fontStyleSelected[2]
                          ? TextDecoration.underline
                          : TextDecoration.none,
                    );
                  },
                )
              ],
            )
          else if (currentTool == DrawingTool.Curve ||
              currentTool == DrawingTool.Arrow)
            Row(
              children: [
                SizedBox(
                  height: 40,
                  width: 105,
                  child: GridView.count(
                    crossAxisCount: 3,
                    children: List.generate(
                      3,
                      (index) => InkWell(
                        child: Image(
                          color: brushSizeSelected[index]
                              ? Color(0xff4D53E0)
                              : Colors.white,
                          image: AssetImage('icons/line${index + 1}.png'),
                          height: 20,
                          width: 20,
                        ),
                        onTap: () {
                          setState(() {
                            for (int i = 0; i < brushSizeSelected.length; i++) {
                              brushSizeSelected[i] = i == index;
                            }
                          });
                          setStyle(strokeWidth: StrokeWidth.values[index]);
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                  width: 75,
                  child: GridView.count(
                    crossAxisCount: 2,
                    children: List.generate(
                      2,
                      (index) => InkWell(
                        child: Image(
                          color: dashedBrushSizeSelected[index]
                              ? Color(0xff4D53E0)
                              : Colors.white,
                          image: AssetImage(
                              'icons/${index == 0 ? 'dotted' : 'dashed'}.png'),
                          height: 20,
                          width: 20,
                        ),
                        onTap: () {
                          setState(() {
                            for (int i = 0;
                                i < dashedBrushSizeSelected.length;
                                i++) {
                              dashedBrushSizeSelected[i] =
                                  i == index && !dashedBrushSizeSelected[i];
                            }
                          });
                          setStyle(
                              dashArray: dashedBrushSizeSelected[0]
                                  ? [1.0, 2.0]
                                  : dashedBrushSizeSelected[1]
                                      ? [5.0, 5.0]
                                      : [1.0, 0.0]);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            )
          else
            Ink(
              height: 40,
              child: GridView.count(
                crossAxisCount: 5,
                children: List.generate(
                  5,
                  (index) => InkWell(
                    onTap: () {
                      setState(() {
                        for (int i = 0; i < brushSizeSelected.length; i++) {
                          brushSizeSelected[i] = i == index;
                        }
                      });
                      setStyle(strokeWidth: StrokeWidth.values[index]);
                    },
                    child: Image(
                      color: brushSizeSelected[index]
                          ? Color(0xff4D53E0)
                          : Colors.white,
                      image: AssetImage('icons/line${index + 1}.png'),
                      height: 30,
                      width: 30,
                    ),
                  ),
                ),
              ),
            ),
          AnimatedContainer(
            duration: Duration(milliseconds: 500),
            height:
                showColorPicker && currentTool != DrawingTool.Eraser ? 275 : 0,
            child: ListView(
              children: [
                ColorPicker(
                  onColorChanged: (color) {
                    setState(() {
                      customColor = color;
                    });
                  },
                  pickersEnabled: {
                    ColorPickerType.custom: false,
                    ColorPickerType.accent: false,
                    ColorPickerType.both: false,
                    ColorPickerType.bw: false,
                    ColorPickerType.primary: false,
                    ColorPickerType.wheel: true,
                  },
                  wheelDiameter: 180.0,
                  wheelWidth: 10,
                  enableShadesSelection: false,
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      colors[item] = customColor == Colors.transparent
                          ? Colors.red
                          : customColor;
                      showColorPicker = false;
                      customColor = Colors.transparent;
                      setStyle(color: colors[item]);
                    });
                  },
                  child: Center(
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        ColorIndicator(
                          width: 100,
                          color: customColor,
                        ),
                        Text('SUBMIT'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
