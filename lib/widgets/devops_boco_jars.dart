import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../utils/helper.dart';

class DevopsBocoJars extends StatefulWidget {
  const DevopsBocoJars({super.key});

  @override
  State<DevopsBocoJars> createState() => _DevopsBocoJarsState();
}

class _DevopsBocoJarsState extends State<DevopsBocoJars> {
  var logger = Logger();
  final Helper _helper = Helper();

  void _onPressedA() {
    _helper.testDirectoryCreate();
  }

  void _onPressedB() {
    _helper.testHttpGet().then((value) {
      logger.d(value);
    });
  }

  Column _layoutMain() {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(
            alignment: Alignment.topLeft,
            color: const Color.fromRGBO(75, 75, 75, 1),
            width: 60,
            child: Wrap(
              children: [
                TextButton(onPressed: _onPressedA, child: const Text('CAMP')),
                TextButton(onPressed: _onPressedA, child: const Text('A')),
                TextButton(onPressed: _onPressedB, child: const Text('b')),
              ],
            ),
          ),
        ),
        Container(
          width: 60,
          alignment: Alignment.topLeft,
          color: const Color.fromRGBO(255, 75, 75, 1),
          child: Wrap(
            children: [
              TextButton(onPressed: _onPressedA, child: const Text('User')),
              TextButton(onPressed: _onPressedB, child: const Text('Setting')),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _layoutMain();
  }
}
