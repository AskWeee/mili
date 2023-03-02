import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../utils/helper.dart';

class HomeNavs extends StatefulWidget {
  const HomeNavs({super.key});

  @override
  State<HomeNavs> createState() => _HomeNavsState();
}

class _HomeNavsState extends State<HomeNavs> {
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

  final _containerWidth = 80.0;
  final _colorLogoBackground = const Color.fromRGBO(0, 122, 204, 1);
  final _colorMainBackground = const Color.fromRGBO(75, 75, 75, 1);
  var _colorNavigatorSelected = const Color.fromRGBO(255, 255, 255, 1);
  var _colorNavigatorUnselected = const Color.fromRGBO(175, 175, 175, 1);

  Stack _layoutMain() {
    return Stack(children: [
      Container(
        alignment: Alignment.topLeft,
        color: _colorMainBackground,
      ),
      Column(
        children: [
          Container(
            // width: _containerWidth,
            height: 60,
            alignment: Alignment.topLeft,
            color: _colorLogoBackground,
            child: Stack(
              children: const [
                Align(
                  alignment: FractionalOffset(0.5, 0.5),
                  child: Image(
                    image: AssetImage("assets/icons/icon-mm-2-white.png"),
                    width: 48,
                    height: 48,
                    alignment: Alignment(50, 100),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.topLeft,
              color: _colorMainBackground,
              width: _containerWidth,
              child: Wrap(
                runSpacing: 10,
                children: [
                  TextButton(
                      onPressed: _onPressedA,
                      child: Align(
                        alignment: const FractionalOffset(0.5, 0.5),
                        child: Text(
                          '开发平台',
                          style: TextStyle(
                              color: _colorNavigatorSelected, fontSize: 16),
                        ),
                      )),
                  TextButton(
                      onPressed: _onPressedA,
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            '工程管理',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: _colorNavigatorUnselected),
                          ))),
                  TextButton(
                      onPressed: _onPressedA,
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            '组件管理',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: _colorNavigatorUnselected),
                          ))),
                  TextButton(
                      onPressed: _onPressedA,
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            '产品管理',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: _colorNavigatorSelected),
                          ))),
                  TextButton(
                      onPressed: _onPressedA,
                      child: Align(
                          alignment: const FractionalOffset(0.5, 0.5),
                          child: Text(
                            '融合调度',
                            style: TextStyle(
                                color: _colorNavigatorUnselected, fontSize: 16),
                          ))),
                  TextButton(
                      onPressed: _onPressedA,
                      child: Text(
                        '拓扑中心',
                        style: TextStyle(
                            color: _colorNavigatorUnselected, fontSize: 16),
                      )),
                ],
              ),
            ),
          ),
          Container(
            width: _containerWidth,
            alignment: Alignment.topLeft,
            color: _colorMainBackground,
            child: Wrap(
              runSpacing: 10,
              children: const [
                Align(
                    alignment: Alignment.center,
                    child: Card(
                        child: IconButton(
                      onPressed: null,
                      icon: Icon(Icons.person),
                      tooltip: '当前登录用户',
                      isSelected: false,
                    ))),
                Align(
                    alignment: Alignment.center,
                    child: Card(
                        child: IconButton(
                      onPressed: null,
                      icon: Icon(Icons.settings),
                      tooltip: '设置系统参数',
                      isSelected: false,
                    ))),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
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
