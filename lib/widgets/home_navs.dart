import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mili/utils/events.dart';

class HomeNavs extends StatefulWidget {
  const HomeNavs({super.key});

  @override
  State<HomeNavs> createState() => _HomeNavsState();
}

class _HomeNavsState extends State<HomeNavs> {
  final _logger = Logger();

  void _onNavigatorPressed(String navigator) {
    _logger.d('_onNavigatorPressed');
    eventBus.fire(EventOnNavigatorChanged(navigator));
  }

  final _colorLogoBackground = const Color.fromRGBO(0, 122, 204, 1);
  final _colorMainBackground = const Color.fromRGBO(75, 75, 75, 1);
  final _colorNavigatorSelected = const Color.fromRGBO(255, 255, 255, 1);
  final _colorNavigatorUnselected = const Color.fromRGBO(175, 175, 175, 1);

  Stack _layoutMain() {
    return Stack(children: [
      Container(
        alignment: Alignment.topLeft,
        color: _colorMainBackground,
      ),
      Column(
        children: [
          Container(
            height: 60,
            alignment: Alignment.topLeft,
            color: _colorLogoBackground,
            child: Stack(
              children: const [
                Align(
                  alignment: Alignment.center,
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
              child: Wrap(
                runSpacing: 5,
                children: [
                  TextButton(
                      onPressed: null,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          '开发平台',
                          style: TextStyle(color: _colorNavigatorSelected, fontSize: 16),
                        ),
                      )),
                  TextButton(
                      onPressed: () => {_onNavigatorPressed('流程看板')},
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            '流程看板',
                            style: TextStyle(color: _colorNavigatorUnselected),
                          ))),
                  TextButton(
                      onPressed: () => {_onNavigatorPressed('产品管理')},
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            '产品管理',
                            style: TextStyle(color: _colorNavigatorUnselected),
                          ))),
                  TextButton(
                      onPressed: () => {_onNavigatorPressed('发布管理')},
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            '发布管理',
                            style: TextStyle(color: _colorNavigatorUnselected),
                          ))),
                  TextButton(
                      onPressed: () => {_onNavigatorPressed('源码管理')},
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            '源码管理',
                            style: TextStyle(color: _colorNavigatorUnselected),
                          ))),
                  TextButton(
                      onPressed: () => {_onNavigatorPressed('开源组件')},
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            '开源组件',
                            style: TextStyle(color: _colorNavigatorUnselected),
                          ))),
                  TextButton(
                      onPressed: () => {_onNavigatorPressed('自研组件')},
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            '自研组件',
                            style: TextStyle(color: _colorNavigatorUnselected),
                          ))),
                  TextButton(
                      onPressed: () => {_onNavigatorPressed('开发工具')},
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            '开发工具',
                            style: TextStyle(color: _colorNavigatorUnselected),
                          ))),
                  TextButton(
                    onPressed: () => {_onNavigatorPressed('安全管理')},
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        '安全管理',
                        style: TextStyle(color: _colorNavigatorUnselected),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: null,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        '运维平台',
                        style: TextStyle(color: _colorNavigatorSelected, fontSize: 16),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => {_onNavigatorPressed('运维平台流程看板')},
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        '流程看板',
                        style: TextStyle(color: _colorNavigatorUnselected),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => {_onNavigatorPressed('运维平台主机管理')},
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        '主机管理',
                        style: TextStyle(color: _colorNavigatorUnselected),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => {_onNavigatorPressed('运维平台环境管理')},
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        '环境管理',
                        style: TextStyle(color: _colorNavigatorUnselected),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => {_onNavigatorPressed('运维平台应用管理')},
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        '应用管理',
                        style: TextStyle(color: _colorNavigatorUnselected),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => {_onNavigatorPressed('运维平台自身监控')},
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        '自身监控',
                        style: TextStyle(color: _colorNavigatorUnselected),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: null,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        '核心能力',
                        style: TextStyle(color: _colorNavigatorSelected, fontSize: 16),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => {_onNavigatorPressed('核心能力脚本管理')},
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        '脚本管理',
                        style: TextStyle(color: _colorNavigatorUnselected),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            // width: _containerWidth,
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
