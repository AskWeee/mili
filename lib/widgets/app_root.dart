import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mili/widgets/core_scripts.dart';
import 'package:mili/widgets/devops_boco_jars.dart';
import 'package:mili/widgets/devops_dashboard.dart';
import 'package:mili/widgets/devops_open_jars.dart';
import 'package:mili/widgets/devops_release.dart';
import 'package:mili/widgets/devops_security.dart';
import 'package:mili/widgets/devops_src.dart';
import 'package:mili/widgets/devops_dev_tools.dart';
import 'package:mili/widgets/home_footer.dart';
import 'package:mili/widgets/home_navs.dart';
import 'package:mili/widgets/devops_products.dart';
import 'package:mili/utils/events.dart';
import 'package:mili/widgets/oncloud_hosts.dart';

class AppRoot extends StatefulWidget {
  const AppRoot({super.key, required this.title});

  final String title;

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  final _logger = Logger();
  String _navigaotr = '欢迎使用';
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
                      style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1), decoration: TextDecoration.none, fontSize: 16),
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
        DefaultTextStyle(style: const TextStyle(fontSize: 16, color: Color.fromRGBO(255, 255, 255, 1)), child: Expanded(flex: 1, child: _layoutWorkspace())),
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
            case '流程看板':
              navigatorChanged(navigator, const DevopsDashboard());
              break;
            case '产品管理':
              navigatorChanged(navigator, const DevopsProducts());
              break;
            case '发布管理':
              navigatorChanged(navigator, const DevopsRelease());
              break;
            case '源码管理':
              navigatorChanged(navigator, const DevopsSrc());
              break;
            case '开源组件':
              navigatorChanged(navigator, const DevopsOpenJars());
              break;
            case '自研组件':
              navigatorChanged(navigator, const DevopsBocoJars());
              break;
            case '开发工具':
              navigatorChanged(navigator, const DevopsDevTools());
              break;
            case '安全管理':
              navigatorChanged(navigator, const DevopsSecurity());
              break;
            case '运维平台主机管理':
              navigatorChanged(navigator, const OnCloudHosts());
              break;
            case '核心能力脚本管理':
              navigatorChanged(navigator, const CoreScripts());
              break;
          }
          break;
      }
    });

    return _layoutMain();
  }
}
