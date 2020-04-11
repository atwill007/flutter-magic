import 'package:flutter/material.dart';

import './statefullWidgets/RandomWords.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Welcome to Flutter',
      // 主题控制您应用程序的外观和风格, 可以通过配置ThemeData类轻松更改应用程序的主题
      theme: new ThemeData(
        primaryColor: Colors.amber, // 更改应用程序的主题颜色
        // accentColor: Colors.green,
        // textTheme: TextTheme(body1: TextStyle(color: Colors.purple)),
      ),
      home: new RandomWords(),
    );
  }
}