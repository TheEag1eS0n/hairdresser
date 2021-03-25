import 'package:flutter/material.dart';
import 'package:hairdresser/layout_page/layout_page.dart';
import 'package:hairdresser/paint_page/paint_page.dart';
// import 'package:hairdresser/paint_page/paint_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => LayoutPage(),
        '/paint': (context) => PaintPage(),
      },
      // home: Scaffold(
      //   body: LayoutPage(),
      // ),
    );
  }
}
