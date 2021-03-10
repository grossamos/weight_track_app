import 'package:flutter/material.dart';
import 'package:weight_track_app/components/main_page/main_content_pane.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Weight Track App",
      home: MainContentPane(),
    );
  }
}