import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../utils/helper.dart';
import 'package:flutter_treeview/flutter_treeview.dart';

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
            width: 400,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                  height: 30,
                  child: Row(children: [
                    Text(
                      '自研组件 Maven 工程列表：',
                      style: _textStyleNormal,
                    ),
                    const Spacer(),
                    ElevatedButton(onPressed: () {}, child: const Text('刷新')),
                    const SizedBox(
                      width: 5,
                    ),
                    ElevatedButton(onPressed: () {}, child: const Text('开仓')),
                  ]),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.topLeft,
                    margin: const EdgeInsets.all(5),
                    decoration: _boxDecorationContainer,
                    child: Card(
                      child: TreeView(
                        controller: TreeViewController(children: [
                          const Node(key: 'com.boco.alarms', label: '亿阳信通故障管理', icon: Icons.folder, children: [
                            Node(key: 'ucmp', label: '集中配置', icon: Icons.folder, children: [
                              Node(key: 'ucmp-client', label: '集中配置客户端API服务', icon: Icons.folder, children: []),
                            ]),
                          ]),
                        ]),
                      ),
                    ),
                  ),
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
                        '亿阳信通故障管理 > 集中配置 > 集中配置客户端 API 服务：',
                        style: _textStyleNormal,
                      ),
                      const Spacer(),
                      ElevatedButton(onPressed: () {}, child: const Text('刷新')),
                      const SizedBox(
                        width: 5,
                      ),
                      ElevatedButton(onPressed: () {}, child: const Text('审查')),
                      const SizedBox(
                        width: 5,
                      ),
                      ElevatedButton(onPressed: () {}, child: const Text('构建')),
                      const SizedBox(
                        width: 5,
                      ),
                      ElevatedButton(onPressed: () {}, child: const Text('拉取')),
                      const SizedBox(
                        width: 5,
                      ),
                      ElevatedButton(onPressed: () {}, child: const Text('推送')),
                      const SizedBox(
                        width: 5,
                      ),
                      ElevatedButton(onPressed: () {}, child: const Text('创建分支')),
                      const SizedBox(
                        width: 5,
                      ),
                      ElevatedButton(onPressed: () {}, child: const Text('合并分支')),
                      const SizedBox(
                        width: 5,
                      ),
                      ElevatedButton(onPressed: () {}, child: const Text('删除分支')),
                      // const SizedBox(
                      //   width: 5,
                      // ),
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
                                  const Node(key: '1com.boco.alarms', label: '分支 - CAMP 端', icon: Icons.folder, children: [
                                    Node(key: '1working-copy', label: 'master', icon: Icons.folder, children: []),
                                    Node(key: '1istory', label: 'branch-1', icon: Icons.folder, children: []),
                                    Node(key: '1stashes', label: 'branch-2', icon: Icons.folder, children: []),
                                    Node(key: '1branches-review', label: 'branch-3', icon: Icons.folder, children: []),
                                  ]),
                                  const Node(key: '2com.boco.alarms', label: '分支 - GitLab 端', icon: Icons.folder, children: [
                                    Node(key: '2working-copy', label: 'origin', icon: Icons.folder, children: [
                                      Node(key: '2working-copy', label: 'master', icon: Icons.folder, children: []),
                                      Node(key: '2istory', label: 'branch-1', icon: Icons.folder, children: []),
                                      Node(key: '2stashes', label: 'branch-2', icon: Icons.folder, children: []),
                                      Node(key: '2branches-review', label: 'branch-3', icon: Icons.folder, children: []),
                                    ]),
                                  ]),
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
                              child: DefaultTabController(
                                length: 2,
                                child: Column(children: [
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      alignment: Alignment.topLeft,
                                      margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                                      decoration: BoxDecoration(border: Border.all(color: _colorBorderRoot, width: 1)),
                                      child: TabBarView(
                                        children: [
                                          Container(
                                            alignment: Alignment.topLeft,
                                            margin: const EdgeInsets.all(5),
                                            //decoration: _boxDecorationContainer,
                                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                                              Text('关联任务（通常为一个任务一个分支）'),
                                              Card(
                                                child: TextField(),
                                              ),
                                              Text('关联需求（通常为一个需求一个分支）'),
                                              Card(
                                                child: TextField(),
                                              ),
                                              Text('关联BUG（通常为一个 BUG 一个分支）'),
                                              Card(
                                                child: TextField(),
                                              ),
                                              Text('所属服务：（可能多个，服务由组件构成）'),
                                              Card(
                                                child: TextField(),
                                              ),
                                              Text('所属模块：（可能多个，模块由服务构成）'),
                                              Card(
                                                child: TextField(),
                                              ),
                                              Text('所属产品：（可能多个，产品由模块构成）'),
                                              Card(
                                                child: TextField(),
                                              ),
                                            ]),
                                          ),
                                          Container(
                                            alignment: Alignment.topLeft,
                                            child: Row(children: [
                                              Container(
                                                alignment: Alignment.topLeft,
                                                margin: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                                                decoration: _boxDecorationContainer,
                                                child: const Text('Working Copy'),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  alignment: Alignment.topLeft,
                                                  margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                                                  decoration: _boxDecorationContainer,
                                                  child: const Text('Source Code'),
                                                ),
                                              ),
                                            ]),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    child: const SizedBox(
                                      width: 300,
                                      child: Card(
                                        child: TabBar(
                                          labelColor: Color.fromRGBO(0, 0, 0, 1),
                                          tabs: [
                                            Tab(
                                              text: '产品关联信息',
                                            ),
                                            Tab(
                                              text: '分支历史信息',
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
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
