import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../utils/helper.dart';
import 'package:flutter_treeview/flutter_treeview.dart';
import '../utils/events.dart';

class DevopsDevTools extends StatefulWidget {
  const DevopsDevTools({super.key});

  @override
  State<DevopsDevTools> createState() => _DevopsDevToolsState();
}

class _DevopsDevToolsState extends State<DevopsDevTools> {
  final Logger _logger = Logger();
  final Helper _helper = Helper();

  final Color _colorBorderRoot = const Color.fromRGBO(55, 155, 255, 1);
  final Color _colorBackgroundRoot = const Color.fromRGBO(55, 75, 95, 1);
  final TextStyle _textStyleNormal = const TextStyle(color: Color.fromRGBO(255, 255, 255, 1));

  late BoxDecoration _boxDecorationRoot;
  late BoxDecoration _boxDecorationContainer;

  SingingCharacter? _character = SingingCharacter.lafayette;
  String _campBootVersion = '1.0.0';

  bool _isNewProjectViewSelected = true;

  Widget getNewCampBootProject() {
    return Column(
      children: [
        Column(
          children: <Widget>[
            Card(
              child: ListTile(
                title: const Text('1.0.0'),
                leading: Radio<String>(
                  value: '1.0.0',
                  groupValue: _campBootVersion,
                  onChanged: (String? value) {
                    setState(() {
                      _campBootVersion = value!;
                    });
                  },
                ),
              ),
            ),
            Card(
              child: ListTile(
                title: const Text('1.0.2'),
                leading: Radio<String>(
                  value: '1.0.2',
                  groupValue: _campBootVersion,
                  onChanged: (String? value) {
                    setState(() {
                      _campBootVersion = value!;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        const Text('项目元数据：'),
        Row(
          children: [
            Container(
              alignment: Alignment.topRight,
              width: 125,
              child: const Text('Group ID:'),
            ),
            const Expanded(
              child: Card(
                child: TextField(),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              alignment: Alignment.topRight,
              width: 125,
              child: const Text('Artifact ID:'),
            ),
            const Expanded(
              child: Card(
                child: TextField(),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              alignment: Alignment.topRight,
              width: 125,
              child: const Text('Version:'),
            ),
            const Expanded(
              child: Card(
                child: TextField(),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              alignment: Alignment.topRight,
              width: 125,
              child: const Text('Description:'),
            ),
            const Expanded(
              child: Card(
                child: TextField(),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              alignment: Alignment.topRight,
              width: 125,
              child: const Text('Package Name:'),
            ),
            const Expanded(
              child: Card(
                child: TextField(),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            const Text('打包格式：'),
            Row(
              children: <Widget>[
                Container(
                  alignment: Alignment.topLeft,
                  width: 130,
                  child: Card(
                    child: ListTile(
                      title: const Text('Jar'),
                      leading: Radio<String>(
                        value: 'jar',
                        groupValue: _campBootVersion,
                        onChanged: (String? value) {
                          setState(() {
                            _campBootVersion = value!;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  width: 130,
                  child: Card(
                    child: ListTile(
                      title: const Text('War'),
                      leading: Radio<String>(
                        value: 'war',
                        groupValue: _campBootVersion,
                        onChanged: (String? value) {
                          setState(() {
                            _campBootVersion = value!;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  width: 130,
                  child: Card(
                    child: ListTile(
                      title: const Text('Pom'),
                      leading: Radio<String>(
                        value: 'pom',
                        groupValue: _campBootVersion,
                        onChanged: (String? value) {
                          setState(() {
                            _campBootVersion = value!;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            const Text('Java 版本：'),
            Row(
              children: <Widget>[
                Container(
                  alignment: Alignment.topLeft,
                  width: 130,
                  child: Card(
                    child: ListTile(
                      title: const Text('8'),
                      leading: Radio<String>(
                        value: '8',
                        groupValue: _campBootVersion,
                        onChanged: (String? value) {
                          setState(() {
                            _campBootVersion = value!;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  width: 130,
                  child: Card(
                    child: ListTile(
                      title: const Text('11'),
                      leading: Radio<String>(
                        value: '11',
                        groupValue: _campBootVersion,
                        onChanged: (String? value) {
                          setState(() {
                            _campBootVersion = value!;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        const Text('子模块列表：'),
        Expanded(
          child: Container(
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.all(5),
            decoration: _boxDecorationContainer,
            child: const Card(
              child: TextField(),
            ),
          ),
        ),
      ],
    );
  }

  Widget getHistoryCampBootProject() {
    return Container(
      alignment: Alignment.topLeft,
      child: const Text('history of projects'),
    );
  }

  void onButtonPressedNew() {}

  Container _layoutMain() {
    return Container(
      alignment: Alignment.topLeft,
      decoration: _boxDecorationRoot,
      child: Row(
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            //margin: const EdgeInsets.all(5),
            //decoration: _boxDecorationContainer,
            width: 500,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const Text('CampBoot 版本：'),
                  const Spacer(),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isNewProjectViewSelected = true;
                        });
                      },
                      child: const Text('创建')),
                  const SizedBox(
                    width: 5,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isNewProjectViewSelected = false;
                        });
                      },
                      child: const Text('历史')),
                ]),
                Expanded(
                  child: _isNewProjectViewSelected ? getNewCampBootProject() : getHistoryCampBootProject(),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.topLeft,
              //margin: const EdgeInsets.fromLTRB(0, 5, 5, 5),
              //decoration: _boxDecorationContainer,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    margin: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                    height: 30,
                    child: Row(children: [
                      Text(
                        'Demo.zip',
                        style: _textStyleNormal,
                      ),
                      const Spacer(),
                      ElevatedButton(onPressed: () {}, child: const Text('下载')),
                      const SizedBox(
                        width: 5,
                      ),
                      ElevatedButton(onPressed: () {}, child: const Text('推送')),
                      const SizedBox(
                        width: 5,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            eventBus.fire(EventOnNavigatorChanged('源码管理'));
                          },
                          child: const Text('跳转到【源码管理】')),
                      const SizedBox(
                        width: 5,
                      ),
                    ]),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.all(5),
                      decoration: _boxDecorationContainer,
                      child: Row(
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            width: 300,
                            //decoration: _boxDecorationContainer,
                            child: Card(
                              child: TreeView(
                                controller: TreeViewController(children: [
                                  const Node(key: '1com.boco.alarms', label: 'src', icon: Icons.folder, children: []),
                                ]),
                              ),
                            ),
                          ),
                          Expanded(
                            child: //Row(
                                //children: [
                                //Expanded(
                                //child:
                                Container(
                              alignment: Alignment.topLeft,
                              // decoration: _boxDecorationContainer,
                              child: Container(
                                alignment: Alignment.topLeft,
                                margin: const EdgeInsets.all(5),
                                //decoration: _boxDecorationContainer,
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                                  Card(
                                    child: TextField(),
                                  ),
                                ]),
                              ),
                            ),
                            //),
                            //],
                            //),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    _logger.d('...initState...');

    _boxDecorationRoot = BoxDecoration(
      color: _colorBackgroundRoot,
      border: Border.all(color: _colorBorderRoot, width: 1),
    );

    _boxDecorationContainer = BoxDecoration(
      color: _colorBackgroundRoot,
      border: Border.all(color: _colorBorderRoot, width: 1),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _logger.d('...build...');
    return _layoutMain();
  }
}
