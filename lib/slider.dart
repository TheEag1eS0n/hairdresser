import 'package:flutter/material.dart';

class BrushSize extends StatefulWidget {
  BrushSize({required this.initialSize});
  final double initialSize;

  @override
  _BrushSizeState createState() => _BrushSizeState();
}

class _BrushSizeState extends State<BrushSize> {
  late double _brushSize;

  @override
  void initState() {
    _brushSize = widget.initialSize;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Brush Size :)"),
      content: Column(
        children: [
          Container(
            child: Text(_brushSize.toString()),
          ),
          Slider(
            min: 1,
            max: 51,
            value: _brushSize,
            onChanged: (value) {
              setState(() {
                _brushSize = value.roundToDouble();
              });
            },
          ),
        ],
      ),
      actions: [
        FlatButton(
          onPressed: () {
            Navigator.pop(context, _brushSize);
          },
          child: Text('Select'),
        )
      ],
    );
  }
}
