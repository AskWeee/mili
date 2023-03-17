import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../utils/helper.dart';
import 'package:flutter_treeview/flutter_treeview.dart';

class DevopsRelease extends StatefulWidget {
  const DevopsRelease({super.key});

  @override
  State<DevopsRelease> createState() => _DevopsReleaseState();
}

class _DevopsReleaseState extends State<DevopsRelease> {
  final Logger _logger = Logger();
  final Helper _helper = Helper();

  final _colorBackgroundRoot = const Color.fromRGBO(49, 49, 49, 1);
  final _colorBorderRoot = const Color.fromRGBO(49, 149, 249, 1);
  late final BoxDecoration _boxDecorationRoot = BoxDecoration(
    color: _colorBackgroundRoot,
    border: Border.all(color: _colorBorderRoot, width: 1),
  );

  DevopsProductsViewNodeType _isNodeSelected = DevopsProductsViewNodeType.unknown;

  String versionsSelected = '1.0.1';

  Widget _layoutMain() {
    return Container(
      alignment: Alignment.topLeft,
      decoration: _boxDecorationRoot,
      child: Row(children: [
        Expanded(
          child: Column(children: [
            Container(
              alignment: Alignment.topLeft,
              decoration: _boxDecorationRoot,
              child: Row(
                children: [
                  const Expanded(
                    child: Card(
                      child: TextField(),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('搜索'),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('发布'),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('申请'),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                ],
              ),
            ),
            Expanded(
                child: Container(
              alignment: Alignment.topLeft,
              color: const Color.fromRGBO(255, 255, 255, 1),
              child: Card(
                child: TreeView(
                    controller: TreeViewController(children: [
                  const Node(key: '1', label: '新OSS', icon: Icons.folder, children: [
                    Node(key: '2', label: '【产品】智能监控', icon: Icons.folder, children: [
                      Node(key: '3', label: '【模块】告警流水监控', icon: Icons.folder, children: [
                        Node(key: '4', label: '【服务】后端告警流水服务', icon: Icons.folder, children: [
                          Node(
                            key: '5',
                            label: '【组件】告警模型定义',
                            icon: Icons.folder,
                          )
                        ])
                      ])
                    ])
                  ]),
                ])),
              ),
            ))
          ]),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            children: [
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(10),
                decoration: _boxDecorationRoot,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('申请列表：'),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.all(10),
                    decoration: _boxDecorationRoot,
                    child: Row(
                      children: [
                        const Text('广东项目经理 X 申请 V1.0.1'),
                        const Spacer(),
                        ElevatedButton(onPressed: () {}, child: const Text('同意')),
                        ElevatedButton(onPressed: () {}, child: const Text('拒绝')),
                      ],
                    ),
                  ),
                  Text('两个用户角色角色（增加系统用户管理）'),
                  Text('产品经理：主动发布产品；'),
                  Text('项目经理：看到发布信息后，申请产品包。'),
                  Text('产品经理看到申请后，推送产品包'),
                  Text('项目经理收到邮件后，到特定地址下载产品包。'),
                  Text('产品有版本，模块有版本，服务有版本，组件有版本'),
                  Text('产品有版本，由不同版本的模块构成'),
                  Text('模块有版本，由不同版本的服务构成'),
                  Text('服务有版本，由不同版本的组件构成'),
                  Text('只能推送特定版本的产品'),
                  Text('产品已增量包和全量包两种形式推送'),
                  Text('有可能需要申请者提供基础包版本'),
                  Text('也可以根据推送历史，获知基础版本'),
                  Text('点击同意后，进入推送状态，其推送历史为申请人的推送历史'),
                  Text('左侧列表只显示到产品一级'),
                ]),
              ),
              const SizedBox(
                height: 5,
              ),
              Expanded(
                  child: Container(
                alignment: Alignment.topLeft,
                decoration: _boxDecorationRoot,
                child: _isNodeSelected == DevopsProductsViewNodeType.unknown
                    ? makeWidgetWelcome()
                    : _isNodeSelected == DevopsProductsViewNodeType.product
                        ? const Text('product')
                        : makeWidgetWelcome(),
              )),
            ],
          ),
        ),
      ]),
    );
  }

  Widget makeWidgetWelcome() {
    return Container(
      padding: const EdgeInsets.all(5),
      alignment: Alignment.topLeft,
      decoration: _boxDecorationRoot,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('最新版本：V1.0.1'),
              const Spacer(),
              ElevatedButton(onPressed: () {}, child: const Text('推送')),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Text('版本列表：'),
              const Spacer(),
            ],
          ),
          Card(
            child: DropdownButton(
                isExpanded: true,
                value: versionsSelected,
                items: const [
                  DropdownMenuItem(
                    value: '1.0.0',
                    child: Text('1.0.0'),
                  ),
                  DropdownMenuItem(
                    value: '1.0.1',
                    child: Text('1.0.1'),
                  )
                ],
                onChanged: (value) {
                  setState(() {
                    versionsSelected = value!;
                  });
                }),
          ),
          Container(
            margin: const EdgeInsets.all(5),
            alignment: Alignment.topLeft,
            decoration: _boxDecorationRoot,
            height: 150,
            child: Card(
              child: TreeView(
                  controller: TreeViewController(children: [
                const Node(key: '1', label: '【模块】告警流水监控', icon: Icons.folder, children: [
                  Node(key: '2', label: '【服务】后端告警流水服务', icon: Icons.folder, children: [Node(key: '3', label: '【【组件】告警模型定义', icon: Icons.folder, children: [])])
                ]),
              ])),
            ),
          ),
          const Text('推送历史：'),
          Card(
            child: DropdownButton(
                isExpanded: true,
                value: versionsSelected,
                items: const [
                  DropdownMenuItem(
                    value: '1.0.0',
                    child: Text('项目经理 X 于 2022-01-01 申请'),
                  ),
                  DropdownMenuItem(
                    value: '1.0.1',
                    child: Text('项目经理 X 于 2022-01-01 申请'),
                  )
                ],
                onChanged: (value) {
                  setState(() {
                    versionsSelected = value!;
                  });
                }),
          ),
          Container(
              margin: const EdgeInsets.all(5),
              alignment: Alignment.topLeft,
              decoration: _boxDecorationRoot,
              height: 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('版本号'),
                  const Text('下载记录：'),
                ],
              )),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _layoutMain();
  }
}
