import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mili/widgets/devops_boco_jars.dart';
import 'package:mili/widgets/devops_open_jars.dart';
import 'package:mili/widgets/home_footer.dart';
import 'package:mili/widgets/home_navs.dart';
import 'devops_products.dart';
import '../utils/events.dart';

class AppRoot extends StatefulWidget {
  const AppRoot({super.key, required this.title});

  final String title;

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  final _logger = Logger();
  String _navigaotr = 'hello world';
  Widget _navigatorClient = Container();

  void navigatorChanged(String navigator, Widget navigatorClient) {
    _logger.d('set state');
    setState(() {
      _navigaotr = navigator;
      _navigatorClient = navigatorClient;
    });
  }

  // LR layout
  Row _layoutWorkspace() {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.start,
      // mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
          alignment: Alignment.topLeft,
          width: 110,
          child: const HomeNavs(),
        ),
        Expanded(
          flex: 1,
          child: Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(10),
              color: const Color.fromRGBO(49, 49, 49, 1),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      '开发平台 > $_navigaotr',
                      style: const TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 1),
                          decoration: TextDecoration.none,
                          fontSize: 16),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    flex: 1,
                    child: _navigatorClient,
                  )
                ],
              )),
        ),
      ],
    );
  }

  // TB layout
  Column _layoutMain() {
    return Column(
      children: <Widget>[
        Expanded(flex: 1, child: _layoutWorkspace()),
        const SizedBox(height: 30, child: HomeFooter()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    eventBus.on().listen((event) {
      _logger.d(event.runtimeType);
      switch (event.runtimeType) {
        case EventOnNavigatorChanged:
          var navigator = (event as EventOnNavigatorChanged).navigator;
          switch (navigator) {
            case '产品管理':
              _logger.d("loading product console.");
              navigatorChanged(navigator, const DevopsProducts());
              break;
            case '开源组件':
              _logger.d("loading open jar console.");
              navigatorChanged(navigator, const DevopsOpenJars());
              break;
            case '自研组件':
              _logger.d("loading jar console.");
              navigatorChanged(navigator, const DevopsBocoJars());
              break;
            case '安全管理':
              _logger.d("loading security console.");
              break;
          }
          break;
      }
    });

    return _layoutMain();
  }
}
