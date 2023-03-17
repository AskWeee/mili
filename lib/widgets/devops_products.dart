import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../utils/helper.dart';
import 'package:flutter_treeview/flutter_treeview.dart';

class DevopsProducts extends StatefulWidget {
  const DevopsProducts({super.key});

  @override
  State<DevopsProducts> createState() => _DevopsProductsState();
}

class _DevopsProductsState extends State<DevopsProducts> {
  final Logger _logger = Logger();
  final Helper _helper = Helper();

  final _colorBackgroundRoot = const Color.fromRGBO(49, 49, 49, 1);
  final _colorBorderRoot = const Color.fromRGBO(49, 149, 249, 1);
  late BoxDecoration _boxDecorationRoot;

  DevopsProductsViewNodeType _isNodeSelected = DevopsProductsViewNodeType.unknown;

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
                  Expanded(
                    child: Card(
                      child: const TextField(),
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
                    child: const Text('添加目录'),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('添加产品'),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('添加模块'),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('添加服务'),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('添加组件'),
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
                decoration: _boxDecorationRoot,
                child: const Text('新OSS：'),
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
      alignment: Alignment.topCenter,
      decoration: _boxDecorationRoot,
      child: const Text('welcome'),
    );
  }

  @override
  void initState() {
    _boxDecorationRoot = BoxDecoration(
      color: _colorBackgroundRoot,
      border: Border.all(color: _colorBorderRoot, width: 1),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _layoutMain();
  }
}
