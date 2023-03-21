import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../utils/helper.dart';
import 'package:intl/intl.dart';

class DevopsSecurity extends StatefulWidget {
  const DevopsSecurity({super.key});

  @override
  State<DevopsSecurity> createState() => _DevopsSecurityState();
}

class _DevopsSecurityState extends State<DevopsSecurity> {
  final Logger _logger = Logger();
  final Helper _helper = Helper();

  final Color _colorBorderRoot = const Color.fromRGBO(49, 149, 249, 1);
  final BoxDecoration _boxDecorationRoot = BoxDecoration(border: Border.all(color: const Color.fromRGBO(49, 149, 249, 1), width: 1));
  final BoxDecoration _boxDecorationContainer = BoxDecoration(border: Border.all(color: const Color.fromRGBO(49, 149, 249, 1), width: 1));

  final List _listBocoJars = [
    [1, '重大故障', 'fastjson', '1.0.1', '<dependency></dependency>', '2023-01-01', '有害', '无解', '无依赖', false],
    [2, '重大故障', 'fastjson', '1.0.1', '<dependency></dependency>', '2023-01-01', '有害', '无解', '无依赖', false],
    [3, '重大故障', 'fastjson', '1.0.1', '<dependency></dependency>', '2023-01-01', '有害', '无解', '无依赖', false],
    [4, '重大故障', 'fastjson', '1.0.1', '<dependency></dependency>', '2023-01-01', '有害', '无解', '无依赖', false],
    [5, '重大故障', 'fastjson', '1.0.1', '<dependency></dependency>', '2023-01-01', '有害', '无解', '无依赖', false],
    [6, '重大故障', 'fastjson', '1.0.1', '<dependency></dependency>', '2023-01-01', '有害', '无解', '无依赖', false],
  ];

  final List<Map> _commands = [
    {"cmd": '', "arguments": [], "dir": '', "title": "请选择指令"},
    {
      "cmd": 'nerdctl',
      "arguments": ['--namespace=k8s.io', 'image', 'ls'],
      "dir": '',
      "title": "获取k8s.io命名空间下的镜像列表"
    },
    {
      "cmd": 'kubectl',
      "arguments": ['get', 'pods'],
      "dir": '',
      "title": "获取所有的 Pod 资源"
    },
    {
      "cmd": 'git',
      "arguments": ['branch'],
      "dir": '/Users/eric/dev/flutter/mili',
      "title": "获取分支列表"
    },
    {
      "cmd": 'git',
      "arguments": ['log'],
      "dir": '/Users/eric/dev/flutter/mili',
      "title": "获取提交日志"
    },
    {
      "cmd": 'ansible',
      "arguments": ['all', '-m', 'ping'],
      "dir": '/Users/eric/.local/bin',
      "title": "测试主机存活"
    },
    {
      "cmd": 'mvn',
      "arguments": ['dependency:tree'],
      "dir": '/Users/eric/dev/gitlab/mamo/src/jargon',
      "title": "显示依赖树"
    },
  ];

  List<DropdownMenuItem> getCommands() {
    List<DropdownMenuItem> myResult = [];

    int i = 0;
    for (var element in _commands) {
      myResult.add(DropdownMenuItem(
        value: i++,
        child: Text("${element['cmd']} - ${element['title']}"),
      ));
    }

    return myResult;
  }

  int _rowSelectedLast = -1;
  int statusSelected = 0;

  final TextEditingController _controllerCmdResult = TextEditingController();

  Widget makeWidgetOpenJarsBlackList() {
    return Container(
        alignment: Alignment.topLeft,
        child: Column(
          children: [
            Container(
                alignment: Alignment.topLeft,
                // decoration: _boxDecorationContainer,
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Row(
                  children: [
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('新增'),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('删除'),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('依赖核查'),
                    )
                  ],
                )),
            Expanded(
              child: Container(
                alignment: Alignment.topLeft,
                decoration: _boxDecorationContainer,
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: makeJarsDataTable(),
              ),
            ),
            Container(
              //padding: const EdgeInsets.all(5),
              alignment: Alignment.topLeft,
              // decoration: _boxDecorationContainer,
              height: 500,
              margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Column(
                children: [
                  Row(children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        //decoration: _boxDecorationContainer,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                //decoration: _boxDecorationContainer,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text('标题：'),
                                    Card(child: TextField()),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Container(
                              //decoration: _boxDecorationContainer,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text('发现时间：'),
                                  SizedBox(
                                    width: 200,
                                    child: Card(child: TextField()),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          Container(
                            //decoration: _boxDecorationContainer,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text('危害等级：'),
                                SizedBox(
                                  width: 200,
                                  child: Card(child: TextField()),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Container(
                              //decoration: _boxDecorationContainer,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text('依赖核查结果：'),
                                  Card(child: TextField()),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
                  const SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    child: Row(children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Container(
                              //decoration: _boxDecorationContainer,
                              child: Container(
                                alignment: Alignment.topLeft,
                                //decoration: _boxDecorationContainer,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        //decoration: _boxDecorationContainer,
                                        child: Container(
                                          alignment: Alignment.topLeft,
                                          //decoration: _boxDecorationContainer,
                                          child: Column(
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: const [
                                                  SizedBox(
                                                    height: 20,
                                                    child: Text('组标识：'),
                                                  ),
                                                  SizedBox(
                                                    height: 35,
                                                    child: Card(child: TextField()),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: const [
                                                  SizedBox(
                                                    height: 20,
                                                    child: Text('制品标识：'),
                                                  ),
                                                  SizedBox(
                                                    height: 35,
                                                    child: Card(child: TextField()),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: const [
                                                  SizedBox(
                                                    height: 20,
                                                    child: Text('版本：'),
                                                  ),
                                                  SizedBox(
                                                    height: 35,
                                                    child: Card(child: TextField()),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.topLeft,
                                        //decoration: _boxDecorationContainer,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: const [
                                            SizedBox(
                                              height: 20,
                                              child: Text('坐标：'),
                                            ),
                                            SizedBox(
                                              height: 155,
                                              child: Card(
                                                  child: TextField(
                                                maxLines: 10,
                                              )),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.topLeft,
                                //decoration: _boxDecorationContainer,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        //decoration: _boxDecorationContainer,
                                        child: Container(
                                          alignment: Alignment.topLeft,
                                          //decoration: _boxDecorationContainer,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: const [
                                              Text('危害描述：'),
                                              Expanded(
                                                child: Card(
                                                  child: TextField(
                                                    maxLines: 20,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.topLeft,
                                        //decoration: _boxDecorationContainer,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: const [
                                            Text('解决方案：'),
                                            Expanded(
                                              child: Card(
                                                child: TextField(
                                                  maxLines: 20,
                                                ),
                                              ),
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
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.topLeft,
                          //decoration: _boxDecorationContainer,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('依赖核查详情：'),
                              Expanded(
                                child: Card(
                                  child: TextField(
                                    maxLines: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
              //),
            ),
          ],
        ));
  }

  Card makeJarsDataTable() {
    List<DataColumn> columns = [];
    var colorHeader = const Color.fromRGBO(255, 255, 255, 1);
    var colorHeaderBackground = const Color.fromRGBO(75, 175, 255, 1);

    columns.add(
      const DataColumn(
        label: Text(
          '序号',
        ),
      ),
    );
    columns.add(
      const DataColumn(
          label: Text(
            '标题',
          ),
          tooltip: ''),
    );
    columns.add(
      const DataColumn(
          label: Text(
            '开源组件名称',
          ),
          tooltip: ''),
    );
    columns.add(
      const DataColumn(
        label: Text(
          '开源组件版本',
        ),
      ),
    );
    columns.add(
      const DataColumn(
        label: Text(
          '开源组件坐标',
        ),
      ),
    );
    columns.add(
      const DataColumn(
        label: Text(
          '发现时间',
        ),
      ),
    );
    columns.add(
      const DataColumn(
        label: Text(
          '问题描述',
        ),
      ),
    );
    columns.add(
      const DataColumn(
        label: Text(
          '解决方案',
        ),
      ),
    );
    columns.add(
      const DataColumn(
        label: Text(
          '核查结果',
        ),
      ),
    );

    return Card(
        child: DataTable(
            dividerThickness: 1,
            dataRowHeight: 35,
            showBottomBorder: true,
            headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: colorHeader),
            headingRowColor: MaterialStateProperty.resolveWith((states) => colorHeaderBackground),
            sortColumnIndex: 1,
            sortAscending: true,
            columns: columns,
            onSelectAll: (selected) {},
            rows: makeBocoJarsDataRowList()));
  }

  List<DataRow> makeBocoJarsDataRowList() {
    List<DataRow> myResult = [];

    if (_listBocoJars.isEmpty) {
      List<DataCell> cells = [];

      for (var i = 0; i < 9; i++) {
        cells.add(const DataCell(Text('')));
      }

      myResult.add(DataRow(cells: cells));
    } else {
      for (var i = 0; i < _listBocoJars.length; i++) {
        List<DataCell> cells = [];

        var f = NumberFormat("0000");
        cells.add(DataCell(Text(f.format(i + 1))));
        for (var j = 1; j < _listBocoJars[i].length - 1; j++) {
          cells.add(DataCell(Text('${_listBocoJars[i][j]}')));
        }

        myResult.add(DataRow(
          selected: _listBocoJars[i][_listBocoJars[i].length - 1],
          onSelectChanged: (value) {
            setState(() {
              if (_rowSelectedLast != -1) {
                _listBocoJars[_rowSelectedLast][_listBocoJars[_rowSelectedLast].length - 1] = false;
              }
              _listBocoJars[i][_listBocoJars[i].length - 1] = value;
              _rowSelectedLast = i;
            });
          },
          cells: cells,
        ));
      }
    }

    return myResult;
  }

  Widget makeWidgetRunCmd() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Card(
                child: DropdownButton(
                    isExpanded: true,
                    value: statusSelected,
                    items: getCommands(),
                    onChanged: (value) {
                      setState(() {
                        statusSelected = value!;
                        if (value != 0) {
                          getCmdResult(_commands[value]["cmd"], _commands[value]["arguments"], _commands[value]["dir"]);
                        }
                      });
                    }),
              ),
            ),
          ],
        ),
        Expanded(
          child: Container(
            alignment: Alignment.topLeft,
            child: Card(
              child: TextField(
                controller: _controllerCmdResult,
                maxLines: 200,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget layoutMain() {
    return Container(
      alignment: Alignment.topLeft,
      decoration: _boxDecorationRoot,
      child: DefaultTabController(
        length: 2,
        child: Column(children: [
          Container(
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: const SizedBox(
              width: 400,
              child: Card(
                child: TabBar(
                  labelColor: Color.fromRGBO(0, 0, 0, 1),
                  tabs: [
                    Tab(
                      text: '开源组件黑名单',
                    ),
                    Tab(
                      text: '其他安全管理项目',
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                decoration: BoxDecoration(border: Border.all(color: _colorBorderRoot, width: 1)),
                child: TabBarView(
                  children: [
                    makeWidgetOpenJarsBlackList(),
                    Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.topLeft,
                      decoration: _boxDecorationContainer,
                      child: makeWidgetRunCmd(),
                    ),
                  ],
                )),
          ),
        ]),
      ),
    );
  }

  void getCmdResult(String cmd, List<String> arguments, String dir) {
    _helper.postCmd(cmd, arguments, dir).then((List value) {
      _logger.d('get boco jars >>>${value.length}<<<');

      String cmdResult = "";
      if (value.isNotEmpty) {
        for (var element in value) {
          _logger.d(element);
          cmdResult += element + '\n';
        }
      }

      _controllerCmdResult.text = cmdResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    return layoutMain();
  }
}
