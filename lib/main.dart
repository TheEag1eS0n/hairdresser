import 'package:flutter/material.dart';
import 'package:hairdresser/paint_page/paintpage.dart';

void  main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PaintPage(),
    );
  }
}