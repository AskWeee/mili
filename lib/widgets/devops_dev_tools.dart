import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../utils/helper.dart';
import 'package:flutter_treeview/flutter_treeview.dart';
import '../utils/events.dart';
import 'package:intl/intl.dart';

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
                  const SizedBox(
                    width: 5,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        onButtonPressedManageCampBoot();
                      },
                      child: const Text('自身管理')),
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

  void onButtonPressedManageCampBoot() async {
    bool? isConfirmed = await showDialogManageCampBoot();

    if (isConfirmed != null) {
      if (isConfirmed) {
        _logger.d("重建依赖关系");
      } else {
        _logger.d("放弃操作");
      }
    }
  }

  Future<bool?> showDialogManageCampBoot() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return DialogManageCampBoot();
      },
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

//ignore: must_be_immutable
class DialogManageCampBoot extends Dialog {
  DialogManageCampBoot({super.key});

  final _logger = Logger();

  int groupIdSelected = 1;
  int versionSelected = 1;

  int _rowSelectedLast = -1;

  bool _isNew = false;
  bool _isModify = false;

  List _listBocoJars = [
    ['1', '1.0.0', '草稿', '2023-01-01', false],
    ['2', '1.0.1', 'SNAPSHOT', '2023-01-02', false],
    ['3', '1.0.0', 'CURRENT GA', '2023-01-03', false],
  ];

  final _colorMask = const Color.fromRGBO(0, 0, 0, 0.2);
  final _colorDialog = const Color.fromRGBO(255, 255, 255, 1);
  final _colorTitleBar = const Color.fromRGBO(0, 55, 175, 1);
  final _colorTitleBarBorder = const Color.fromRGBO(215, 215, 215, 1);
  final _colorTitle = const Color.fromRGBO(255, 255, 255, 1);
  final _colorContent = const Color.fromRGBO(215, 215, 215, 1);
  final _colorContentBorder = const Color.fromRGBO(215, 215, 215, 1);

  Card makeJarsDataTable(StateSetter setState) {
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
            '版本号',
          ),
          tooltip: ''),
    );
    columns.add(
      const DataColumn(
          label: Text(
            '版本状态',
          ),
          tooltip: ''),
    );
    columns.add(
      const DataColumn(
        label: Text(
          '变更时间',
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
            rows: makeBocoJarsDataRowList(setState)));
  }

  List<DataRow> makeBocoJarsDataRowList(StateSetter setState) {
    List<DataRow> myResult = [];

    if (_listBocoJars.isEmpty) {
      List<DataCell> cells = [];

      for (var i = 0; i < 4; i++) {
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

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, StateSetter setState) {
      return Material(
          type: MaterialType.transparency,
          child: Container(
            alignment: Alignment.center,
            color: _colorMask,
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(20),
              color: _colorDialog,
              child: Column(children: [
                Container(
                  alignment: Alignment.center,
                  height: 40,
                  decoration: BoxDecoration(color: _colorTitleBar, border: Border.all(color: _colorTitleBarBorder, width: 1)),
                  child: Stack(children: [
                    Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(right: 5),
                      child: Text(
                        'CampBoot 构建窗口',
                        style: TextStyle(color: _colorTitle, fontSize: 16),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      margin: const EdgeInsets.only(right: 5),
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: const Text('关闭')),
                    ),
                  ]),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.topLeft,
                    decoration: BoxDecoration(color: _colorContent, border: Border.all(color: _colorContentBorder, width: 1)),
                    child: Expanded(
                      child: Container(
                        alignment: Alignment.topLeft,
                        margin: const EdgeInsets.all(10),
                        color: _colorContent,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text('版本：'),
                                        const Spacer(),
                                        ElevatedButton(onPressed: () {}, child: const Text('新增')),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        ElevatedButton(onPressed: () {}, child: const Text('克隆')),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        ElevatedButton(onPressed: () {}, child: const Text('构建')),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        ElevatedButton(onPressed: () {}, child: const Text('发布')),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        ElevatedButton(onPressed: () {}, child: const Text('修改')),
                                        (_isNew || _isModify)
                                            ? Row(
                                                children: [
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  ElevatedButton(onPressed: () {}, child: const Text('删除')),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  ElevatedButton(onPressed: () {}, child: const Text('保存')),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  ElevatedButton(onPressed: () {}, child: const Text('放弃')),
                                                ],
                                              )
                                            : const SizedBox(),
                                      ],
                                    ),
                                    makeJarsDataTable(setState),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('坐标：'),
                                    Card(
                                      child: TextField(
                                        maxLines: 6,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text('简述：'),
                          Card(
                            child: TextField(),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: Row(children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Row(children: [
                                      Text('pom.xml'),
                                      const Spacer(),
                                      ElevatedButton(onPressed: () {}, child: const Text('校验')),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                    ]),
                                    Expanded(
                                      child: Card(
                                        child: TextField(
                                          maxLines: 100,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Row(children: [
                                      Text('子模块列表'),
                                      const Spacer(),
                                      ElevatedButton(onPressed: () {}, child: const Text('新增')),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      ElevatedButton(onPressed: () {}, child: const Text('删除')),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                    ]),
                                    Expanded(
                                      child: Card(
                                        child: TextField(
                                          maxLines: 100,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                          ),
                        ]),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ));
    });
  }
}
