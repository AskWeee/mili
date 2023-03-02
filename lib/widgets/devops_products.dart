import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../utils/helper.dart';

class DevopsProducts extends StatefulWidget {
  const DevopsProducts({super.key});

  @override
  State<DevopsProducts> createState() => _DevopsProductsState();
}

class _DevopsProductsState extends State<DevopsProducts> {
  var logger = Logger();
  final Helper _helper = Helper();
  final _colorMainBackground = const Color.fromRGBO(49, 49, 49, 1);

  void _onPressed() {
    _helper.testDirectoryCreate();
  }

  void _onPressedA() {
    _helper.testDirectoryCreate();
  }

  void _onPressedB() {
    _helper.testHttpGet().then((value) {
      logger.d(value);
    });
  }

  Stack _layoutMain() {
    return Stack(children: <Widget>[
      Container(
        alignment: Alignment.topLeft,
        color: _colorMainBackground,
      ),
      Container(
        alignment: Alignment.topLeft,
        child: Wrap(direction: Axis.vertical, children: [
          const Text(
            "开发平台 > 产品管理",
            style: TextStyle(
              color: Color.fromRGBO(255, 255, 255, 1),
              fontSize: 16,
              decoration: TextDecoration.none,
            ),
          ),
          Wrap(
            spacing: 5,
            children: [
              const SizedBox(
                width: 0,
              ),
              ElevatedButton(
                onPressed: _onPressed,
                child: const Text('添加目录'),
              ),
              ElevatedButton(
                onPressed: _onPressed,
                child: const Text('添加产品'),
              ),
              ElevatedButton(
                onPressed: _onPressed,
                child: const Text('添加模块'),
              ),
              ElevatedButton(
                onPressed: _onPressed,
                child: const Text('添加制品'),
              ),
            ],
          ),
        ]),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return _layoutMain();
  }
}
