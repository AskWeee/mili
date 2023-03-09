import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../utils/helper.dart';

class DevopsRelease extends StatefulWidget {
  const DevopsRelease({super.key});

  @override
  State<DevopsRelease> createState() => _DevopsReleaseState();
}

class _DevopsReleaseState extends State<DevopsRelease> {
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
            color: const Color.fromRGBO(125, 125, 125, 1),
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
          alignment: Alignment.topLeft,
          color: const Color.fromRGBO(175, 175, 175, 1),
          height: 100,
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
