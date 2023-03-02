import 'package:flutter/material.dart';
import 'package:mili/widgets/app_root.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '开发者营地',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'NotoSansSC',
      ),
      home: const AppRoot(title: 'Hello World'),
    );
  }
}
