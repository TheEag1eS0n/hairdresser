import 'package:flutter/material.dart';
import 'package:hairdresser/paint_page/paint_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: PaintPage(),
      ),
    );
  }
}
