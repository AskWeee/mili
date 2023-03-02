import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mili/widgets/devops_campboot.dart';
import 'package:mili/widgets/home_footer.dart';
import 'package:mili/widgets/home_navs.dart';
import 'package:mili/widgets/devops_products.dart';

import '../utils/helper.dart';

class AppRoot extends StatefulWidget {
  const AppRoot({super.key, required this.title});

  final String title;

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  var logger = Logger();
  final Helper _helper = Helper();

  final _colorMainBackground = const Color.fromRGBO(75, 75, 75, 1);

  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _onPressed() {
    _incrementCounter();
  }

  // left-right layout
  Row _layoutWorkspace() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
          width: 110,
          child: const HomeNavs(),
        ),
        Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(10),
              color: const Color.fromRGBO(49, 49, 49, 1),
              foregroundDecoration: BoxDecoration(
                  border: Border.all(
                color: const Color.fromRGBO(61, 61, 61, 1),
                width: 1.0,
              )),
              child: const DevopsProducts(),
              // child: const DevopsCampboot(),
            )),
      ],
    );
  }

  // top-bottom layout
  Column _layoutMain() {
    return Column(
      children: <Widget>[
        Expanded(flex: 1, child: _layoutWorkspace()),
        Container(
            height: 30,
            decoration: const BoxDecoration(
              color: Colors.redAccent,
            ),
            child: const HomeFooter()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _layoutMain();
  }
}
