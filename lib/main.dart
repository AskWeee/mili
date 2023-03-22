import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mili/utils/doraemon.dart';
import 'package:mili/widgets/app_root.dart';

void main() {
  Doraemon.init().then((e) {
    runApp(const MyApp());
  });
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {PointerDeviceKind.touch, PointerDeviceKind.mouse};
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
      debugShowCheckedModeBanner: false,
      // scrollBehavior: MyCustomScrollBehavior(),
    );
  }
}
