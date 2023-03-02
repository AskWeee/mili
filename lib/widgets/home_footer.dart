import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../utils/helper.dart';

class HomeFooter extends StatefulWidget {
  const HomeFooter({super.key});

  @override
  State<HomeFooter> createState() => _HomeFooterState();
}

class _HomeFooterState extends State<HomeFooter> {
  var logger = Logger();
  final Helper _helper = Helper();

  final _colorMainBackground = const Color.fromRGBO(0, 122, 204, 1);

  void _onPressedA() {
    _helper.testDirectoryCreate();
  }

  void _onPressedB() {
    _helper.testHttpGet().then((value) {
      logger.d(value);
    });
  }

  Stack _layoutMain() {
    return Stack(children: [
      Container(
        alignment: Alignment.topLeft,
        color: _colorMainBackground,
      ),
      Row(
        children: <Widget>[
          const SizedBox(
            width: 10,
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.topLeft,
              color: _colorMainBackground,
              child: Wrap(
                children: [
                  TextButton(
                      onPressed: _onPressedA,
                      child: const Text(
                        '系统提示：',
                        style: TextStyle(color: Colors.white),
                      )),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return _layoutMain();
  }
}
