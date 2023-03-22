import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:logger/logger.dart';
import 'package:flutter_treeview/flutter_treeview.dart';
import 'package:mili/utils/doraemon.dart';
import 'package:mili/utils/helper.dart';
import 'package:intl/intl.dart';
import 'package:mili/utils/events.dart';

class DevopsBocoJars extends StatefulWidget {
  const DevopsBocoJars({super.key});

  @override
  State<DevopsBocoJars> createState() => _DevopsBocoJarsState();
}

class _DevopsBocoJarsState extends State<DevopsBocoJars> {
  final _logger = Logger();
  final _helper = Helper();

  List _listBocoJars = [];
  int _rowSelectedLast = -1;

  // bool _isJarSelectd = false;
  bool _isJarVersionStatusUnknown = false;
  bool _isJarVersionStatusPlanning = false;
  bool _isJarVersionStatusCoding = false;
  bool _isJarVersionStatusReleased = false;

  bool isChanging = false;

  String versionsSelected = '1.0.1';
  String developerSelected = 'gaoyanfu';
  String statusSelected = 'unknown';

  final Color _colorBorderBoxRoot = const Color.fromRGBO(0, 122, 204, 1);
  final Color _colorBackgroundToolbar = const Color.fromRGBO(61, 61, 61, 1);
  final Color _colorBackgroundContent = const Color.fromRGBO(61, 61, 61, 1);
  final Color _colorBackgroundTabBarView = const Color.fromRGBO(75, 75, 75, 1);

  final TextEditingController _textControllerJarsSearch = TextEditingController();
  final TextEditingController _textControllerJarGroupId = TextEditingController();
  final TextEditingController _textControllerJarGroupTitle = TextEditingController();
  final TextEditingController _textControllerJarArtifactId = TextEditingController();
  final TextEditingController _textControllerJarArtifactTitle = TextEditingController();
  final TextEditingController _textControllerJarVersion = TextEditingController();
  final TextEditingController _textControllerJarManager = TextEditingController();
  final TextEditingController _textControllerJarLocationXml = TextEditingController();

  final ScrollController scrollControllerTable = ScrollController();
  final ScrollController scrollControllerDataTable = ScrollController();

  Slider mySlider = Slider(
      value: 1,
      onChanged: (value) {
        final logger = Logger();
        logger.d(value);
      });

  double _sliderTableScrollbarValueCurrent = 0;
  double _sliderTableScrollbarValueMax = 10;

  Container getWidgetLayoutMain() {
    return Container(
        alignment: Alignment.topLeft,
        decoration: BoxDecoration(
          border: Border.all(color: _colorBorderBoxRoot, width: 1),
        ),
        child: Column(
          children: <Widget>[
            getWidgetToolbar(),
            Expanded(
              flex: 1,
              child: Container(
                  alignment: Alignment.topLeft,
                  color: _colorBackgroundContent,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: getWidgetJarTabView(),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 500,
                        child: Column(children: [
                          Container(
                            alignment: Alignment.topLeft,
                            margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                            decoration: BoxDecoration(border: Border.all(color: _colorBorderBoxRoot, width: 1)),
                            child: getWidgetJarInfoLocation(),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: DefaultTabController(
                              length: 3,
                              child: Column(children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    alignment: Alignment.topLeft,
                                    margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                    decoration: BoxDecoration(border: Border.all(color: _colorBorderBoxRoot, width: 1)),
                                    child: TabBarView(
                                      children: [
                                        getWidgetJarInfo(),
                                        getWidgetJarDependencyTree(),
                                        getWidgetJarUsedTree(),
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
                                            text: '基本信息',
                                          ),
                                          Tab(
                                            text: '依赖关系',
                                          ),
                                          Tab(
                                            text: '引用关系',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                          ),
                        ]),
                      ),
                    ],
                  )),
            ),
          ],
        ));
  }

  Container getWidgetToolbar() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.all(10),
      color: _colorBackgroundToolbar,
      child: Row(
        children: [
          SizedBox(
              width: 500,
              height: 35,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: TextField(
                  controller: _textControllerJarsSearch,
                  decoration: const InputDecoration(
                    hintText: '请输入关键字',
                  ),
                ),
              )),
          const SizedBox(
            width: 10,
          ),
          ElevatedButton.icon(
            icon: const Icon(
              Icons.send,
              size: 16,
            ),
            label: const Text(
              '搜索',
            ),
            onPressed: () {},
          ),
          const SizedBox(
            width: 10,
          ),
          ElevatedButton.icon(
            icon: const Icon(
              Icons.send,
              size: 16,
            ),
            label: const Text(
              '刷新',
            ),
            onPressed: onButtonPressedRefresh,
          ),
          const SizedBox(
            width: 10,
          ),
          ElevatedButton(
              onPressed: onButtonPressedAddBocoJar,
              child: const Text(
                '新增组件',
              )),
          const SizedBox(
            width: 10,
          ),
          ElevatedButton(
              onPressed: onButtonPressedAddBocoJarVersion,
              child: const Text(
                '新增版本',
              )),
          const Spacer(),
          ElevatedButton(
              onPressed: onButtonPressedManageJarsCategories,
              child: const Text(
                '组件类目管理',
              )),
          const SizedBox(
            width: 10,
          ),
          ElevatedButton(
              onPressed: onButtonPressedRebuildDependencies,
              child: const Text(
                '重建依赖关系',
              )),
        ],
      ),
    );
  }

  Container getWidgetJarsTable() {
    return Container(
      alignment: Alignment.topLeft,
      margin: const EdgeInsets.all(10),
      color: const Color.fromRGBO(155, 155, 155, 1),
      child: Column(children: [
        Expanded(
          child: SingleChildScrollView(
            child: NotificationListener<ScrollNotification>(
              onNotification: _handleScrollNotification,
              child: SingleChildScrollView(
                controller: scrollControllerTable,
                scrollDirection: Axis.horizontal,
                child: makeJarsTable(),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 30,
          child: Row(children: [
            ElevatedButton(
                onPressed: () {
                  scrollControllerTable.jumpTo(0);
                },
                child: const Text('|<')),
            Expanded(
              child: Card(
                child:
                    // mySlider,
                    Slider(
                  key: const Key('SliderTableScrollBar'),
                  value: _sliderTableScrollbarValueCurrent,
                  max: _sliderTableScrollbarValueMax,
                  divisions: (0.1 * _sliderTableScrollbarValueMax).toInt(),
                  label: _sliderTableScrollbarValueCurrent.round().toString(),
                  onChanged: (double value) {
                    if (!isChanging) {
                      scrollControllerTable.jumpTo(value);
                      setState(() {
                        _sliderTableScrollbarValueCurrent = value;
                      });
                    }
                  },
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  scrollControllerTable.jumpTo(_sliderTableScrollbarValueMax);
                },
                child: const Text('>|'))
          ]),
          // scrollbarOrientation: ScrollbarOrientation.left,
        ),
      ]),
    );
  }

  Container getWidgetJarsDataTable() {
    return Container(
      alignment: Alignment.topLeft,
      margin: const EdgeInsets.all(10),
      color: const Color.fromRGBO(155, 155, 155, 1),
      child: Scrollbar(
        thumbVisibility: true,
        controller: scrollControllerDataTable,
        child: SingleChildScrollView(
          controller: scrollControllerDataTable,
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            child: makeJarsDataTable(),
          ),
        ),
      ),
    );
  }

  Container getWidgetJarTabView() {
    return Container(
      alignment: Alignment.topLeft,
      child: DefaultTabController(
        length: 2,
        child: Column(children: [
          Expanded(
            flex: 1,
            child: Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                decoration: BoxDecoration(border: Border.all(color: _colorBorderBoxRoot, width: 1)),
                child: TabBarView(
                  children: [
                    // getWidgetJarsTable(),
                    getWidgetJarsDataTable(),
                    getWidgetJarsTree(),
                  ],
                )),
          ),
          Container(
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: const SizedBox(
              width: 300,
              child: Card(
                child: TabBar(
                  labelColor: Color.fromRGBO(0, 0, 0, 1),
                  tabs: [
                    Tab(
                      text: '表视图',
                    ),
                    Tab(
                      text: '树视图',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Container getWidgetJarsTree() {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.all(10),
      color: _colorBackgroundTabBarView,
      child: Card(
        child: TreeView(
            controller: TreeViewController(children: [
          const Node(key: 'com', label: 'com', icon: Icons.folder, children: [
            Node(
              key: 'boco',
              label: 'boco',
              icon: Icons.folder,
            )
          ]),
        ])),
      ),
    );
  }

  Container getWidgetJarInfoLocation() {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.all(10),
      color: _colorBackgroundTabBarView,
      child: Column(children: [
        Table(
          border: TableBorder.all(),
          columnWidths: const <int, TableColumnWidth>{
            1: FlexColumnWidth(),
            2: FlexColumnWidth(),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: <TableRow>[
            const TableRow(
              children: <Widget>[
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.top,
                  child: Text('组标识： GroupID'),
                ),
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.top,
                  child: Text('归属及分类：'),
                ),
              ],
            ),
            TableRow(
              children: <Widget>[
                TableCell(
                  // verticalAlignment: TableCellVerticalAlignment.top,
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Card(
                      child: TextField(
                        controller: _textControllerJarGroupId,
                      ),
                    ),
                  ),
                ),
                TableCell(
                  // verticalAlignment: TableCellVerticalAlignment.top,
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Card(
                      child: TextField(controller: _textControllerJarGroupTitle),
                    ),
                  ),
                ),
              ],
            ),
            const TableRow(
              children: <Widget>[
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.top,
                  child: Text('制品标识： ArtifactID'),
                ),
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.top,
                  child: Text('制品名称：'),
                ),
              ],
            ),
            TableRow(
              children: <Widget>[
                TableCell(
                  // verticalAlignment: TableCellVerticalAlignment.top,
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Card(
                      child: TextField(controller: _textControllerJarArtifactId),
                    ),
                  ),
                ),
                TableCell(
                  // verticalAlignment: TableCellVerticalAlignment.top,
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Card(
                      child: TextField(controller: _textControllerJarArtifactTitle),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        Container(
          alignment: Alignment.topLeft,
          child: Row(children: [
            const Expanded(
              child: Text('制品版本： Version'),
            ),
            Expanded(
              child: Row(children: const [
                Expanded(
                  child: Text('版本状态：'),
                ),
                Expanded(
                  child: Text('责任人：'),
                ),
              ]),
            ),
          ]),
        ),
        Container(
          alignment: Alignment.topLeft,
          child: Row(children: [
            Expanded(
              child: Card(
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
            ),
            Expanded(
              child: Row(children: [
                Expanded(
                  child: Card(
                    child: DropdownButton(
                        isExpanded: true,
                        value: statusSelected,
                        items: const [
                          DropdownMenuItem(
                            value: 'unknown',
                            child: Text(''),
                          ),
                          DropdownMenuItem(
                            value: 'planning',
                            child: Text('规划中'),
                          ),
                          DropdownMenuItem(
                            value: 'coding',
                            child: Text('开发中'),
                          ),
                          DropdownMenuItem(
                            value: 'released',
                            child: Text('已发布'),
                          )
                        ],
                        onChanged: (value) {
                          setState(() {
                            statusSelected = value!;

                            bool isJarVersionStatusUnknown = false;
                            bool isJarVersionStatusPlanning = false;
                            bool isJarVersionStatusCoding = false;
                            bool isJarVersionStatusReleased = false;
                            if (value == 'unknown') {
                              isJarVersionStatusUnknown = true;
                            } else if (value == 'planning') {
                              isJarVersionStatusPlanning = true;
                            } else if (value == 'coding') {
                              isJarVersionStatusCoding = true;
                            } else if (value == 'released') {
                              isJarVersionStatusReleased = true;
                            }
                            setState(() {
                              _isJarVersionStatusUnknown = isJarVersionStatusUnknown;
                              _isJarVersionStatusPlanning = isJarVersionStatusPlanning;
                              _isJarVersionStatusCoding = isJarVersionStatusCoding;
                              _isJarVersionStatusReleased = isJarVersionStatusReleased;
                            });
                          });
                        }),
                  ),
                ),
                Expanded(
                  child: Card(
                    child: DropdownButton(
                        isExpanded: true,
                        value: developerSelected,
                        items: const [
                          DropdownMenuItem(
                            value: 'gaoyanfu',
                            child: Text('高彦夫'),
                          ),
                          DropdownMenuItem(
                            value: 'dingxiaohai',
                            child: Text('丁小孩'),
                          )
                        ],
                        onChanged: (value) {
                          setState(() {
                            developerSelected = value!;
                          });
                        }),
                  ),
                ),
              ]),
            ),
          ]),
        ),
      ]),
    );
  }

  Container getWidgetJarInfo() {
    return Container(
        color: _colorBackgroundTabBarView,
        child: Column(children: [
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
            child: const Text(
              '制品坐标：',
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Card(
              child: TextField(
                maxLines: 6,
                controller: _textControllerJarLocationXml,
              ),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
            child: const Text(
              '仓库地址：',
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
            child: const Text(
              '源码地址：',
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
            child: const Text(
              '更新时间：',
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
            child: const Text(
              '制品备注：',
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
              child: const Card(
                child: TextField(
                  maxLines: 50,
                ),
              ),
            ),
          ),
          _isJarVersionStatusUnknown
              ? const SizedBox(height: 5)
              : Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.fromLTRB(15, 5, 15, 15),
                  child: Row(children: [
                    _isJarVersionStatusReleased
                        ? Row(
                            children: [
                              ElevatedButton(onPressed: () {}, child: const Text('下载')),
                              const SizedBox(width: 10),
                            ],
                          )
                        : const SizedBox(),
                    _isJarVersionStatusPlanning
                        ? ElevatedButton(
                            onPressed: () {
                              onButtonPressedJumpToDevToolsView();
                            },
                            child: const Text('创建 Maven 项目'))
                        : const SizedBox(),
                    _isJarVersionStatusCoding || _isJarVersionStatusReleased
                        ? ElevatedButton(
                            onPressed: () {
                              onButtonPressedJumpToSrcView();
                            },
                            child: const Text('跳转到源码管理'))
                        : const SizedBox(),
                    const Spacer(),
                    ElevatedButton(onPressed: () {}, child: const Text('删除')),
                    const SizedBox(),
                  ]),
                ),
        ]));
  }

  Container getWidgetJarDependencyTree() {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.all(10),
      color: _colorBackgroundTabBarView,
      child: Container(
        color: const Color.fromRGBO(25, 75, 125, 1),
        child: Card(
          child: TreeView(
              controller: TreeViewController(children: [
            const Node(key: '依赖树', label: '依赖树', icon: Icons.folder, children: [
              Node(
                key: 'treeItem1',
                label: 'hello world',
                icon: Icons.folder,
              )
            ]),
          ])),
        ),
      ),
    );
  }

  Container getWidgetJarUsedTree() {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.all(10),
      color: _colorBackgroundTabBarView,
      child: Container(
        color: const Color.fromRGBO(25, 75, 125, 1),
        child: Card(
          child: TreeView(
              controller: TreeViewController(children: [
            const Node(key: '引用树', label: '引用树', icon: Icons.folder, children: [
              Node(
                key: 'treeItem1',
                label: 'hello world',
                icon: Icons.folder,
              )
            ]),
          ])),
        ),
      ),
    );
  }

  Container makeJarsTable() {
    return Container(
      alignment: Alignment.topLeft,
      child: Table(
        border: TableBorder.all(color: _colorBorderBoxRoot, width: 1),
        columnWidths: const <int, TableColumnWidth>{
          0: FixedColumnWidth(80),
          1: FixedColumnWidth(200),
          2: FixedColumnWidth(200),
          3: FixedColumnWidth(200),
          4: FixedColumnWidth(300),
          5: FixedColumnWidth(300),
          6: FixedColumnWidth(200),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: _makeBocoJarsTableRowList(_listBocoJars),
      ),
    );
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
            '归属名称',
          ),
          tooltip: '亿阳信通-{产品名称}'),
    );
    columns.add(
      const DataColumn(
          label: Text(
            '归属标识',
          ),
          tooltip: 'com.boco.{product}'),
    );
    columns.add(
      const DataColumn(
        label: Text(
          '分组名称',
        ),
      ),
    );
    columns.add(
      const DataColumn(
        label: Text(
          '分组标识',
        ),
      ),
    );
    columns.add(
      const DataColumn(
        label: Text(
          '制品名称',
        ),
      ),
    );
    columns.add(
      const DataColumn(
        label: Text(
          '制品标识',
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

  void onButtonPressedRefresh() {
    getBocoJars();
  }

  void onButtonPressedRebuildDependencies() async {
    bool? isConfirmed = await showDialogRebuildDependencies();

    if (isConfirmed != null) {
      if (isConfirmed) {
        _logger.d("重建依赖关系");
      } else {
        _logger.d("放弃操作");
      }
    }
  }

  void onButtonPressedAddBocoJar() async {
    Map? dialogResult = await showDialogAddBocoJar();

    if (dialogResult != null) {
      if (dialogResult["isConfirmed"]) {
        addBocoJar(dialogResult["values"]["uuid"], dialogResult["values"]["productTitle"], dialogResult["values"]["productUuid"], dialogResult["values"]["groupTitle"],
            dialogResult["values"]["groupUuid"], dialogResult["values"]["artifactTitle"], dialogResult["values"]["artifactUuid"]);
      } else {
        _logger.d("放弃 add boco jar 操作");
      }
    }
  }

  void onButtonPressedAddBocoJarVersion() async {
    bool? isConfirmed = await showDialogAddBocoJarVersion();

    if (isConfirmed != null) {
      if (isConfirmed) {
        _logger.d("add boco jar limited with version");
        addBocoJarVersion();
      } else {
        _logger.d("放弃 add boco jar limited with version 操作");
      }
    }
  }

  void onButtonPressedManageJarsCategories() async {
    bool? isConfirmed = await showDialogManageJarsCategories();

    if (isConfirmed != null) {
      if (isConfirmed) {
        _logger.d("重建依赖关系");
      } else {
        _logger.d("放弃操作");
      }
    }
  }

  void onButtonPressedJumpToDevToolsView() {
    eventBus.fire(EventOnNavigatorChanged('开发工具'));
  }

  void onButtonPressedJumpToSrcView() {
    eventBus.fire(EventOnNavigatorChanged('源码管理'));
  }

  void onScrllPositionChanged() {
    _logger.d(scrollControllerTable.offset);
  }

  Future<bool?> showDialogRebuildDependencies() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("提示"),
          content: const Text("您确定要重建全库依赖关系吗?"),
          actions: <Widget>[
            TextButton(
              child: const Text("放弃"),
              onPressed: () => Navigator.of(context).pop(false), // 关闭对话框
            ),
            TextButton(
              child: const Text("确定"),
              onPressed: () {
                //关闭对话框并返回true
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  Future<Map?> showDialogAddBocoJar() {
    return showDialog<Map>(
      context: context,
      builder: (context) {
        return DialogAddBocoJar();
      },
    );
  }

  Future<bool?> showDialogAddBocoJarVersion() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return DialogAddBocoJarVersion();
      },
    );
  }

  Future<bool?> showDialogManageJarsCategories() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return DialogManageJarsCategories();
      },
    );
  }

  List<TableRow> _makeBocoJarsTableRowList(List inData) {
    List<TableRow> list = [];

    var tableHeader = const TableRow(
      children: <Widget>[
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.top,
          child: Text(
            '序号',
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.top,
          child: Text(
            '组件归属名称',
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.top,
          child: Text(
            '组件归属标识',
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.top,
          child: Text(
            '组件分组名称',
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.top,
          child: Text(
            '组件分组标识',
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.top,
          child: Text(
            '组件制品名称',
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.top,
          child: Text(
            '组件制品标识',
          ),
        ),
      ],
    );

    list.add(tableHeader);

    for (var i = 0; i < inData.length; i++) {
      list.add(TableRow(children: [
        Container(
          padding: const EdgeInsets.all(12),
          child: Text(i.toString()),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          child: Text(inData[1]),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          child: Text(inData[2]),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          child: Text(inData[3]),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          child: Text(inData[4]),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          child: Text(inData[5]),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          child: Text(inData[6]),
        ),
      ]));
    }
    return list;
  }

  List<DataRow> makeBocoJarsDataRowList() {
    List<DataRow> myResult = [];

    if (_listBocoJars.isEmpty) {
      List<DataCell> cells = [];

      for (var i = 0; i < 7; i++) {
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

  void setJarInfoLocation(String groupId, String groupTitle, String artifactId, String artifactTitle, String version, String manager) {
    _textControllerJarGroupId.text = groupId;
    _textControllerJarGroupTitle.text = groupTitle;
    _textControllerJarArtifactId.text = artifactId;
    _textControllerJarArtifactTitle.text = artifactTitle;
    _textControllerJarVersion.text = version;
    _textControllerJarManager.text = manager;
  }

  void setJarInfoLocationXml(String locationXml) {
    _textControllerJarLocationXml.text = locationXml;
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    final ScrollMetrics metrics = notification.metrics;
    //print('滚动组件最大滚动距离:${metrics.maxScrollExtent}');
    //print('当前滚动位置:${metrics.pixels}');
    _logger.d('滚动组件最大滚动距离：${metrics.maxScrollExtent}');

    // Key('SliderTableScrollBar')
    //mySlider.max = metrics

    // mySlider.onChanged = null;

    setState(() {
      isChanging = true;
      _sliderTableScrollbarValueCurrent = 0;
      _sliderTableScrollbarValueMax = metrics.maxScrollExtent;
      isChanging = false;
    });

    return true;
  }

  // bool _handleKSizeChangedNotification(KSizeChangedNotification notification) {
  //   _logger.d('... ${notification.size} ...');
  //   return true;
  // }

  Size getRedBoxSize(BuildContext context) {
    final box = context.findRenderObject() as RenderBox;
    return box.size;
  }

  void getBocoJars() {
    _helper.postExsqlSelect("boco_jars", [{}]).then((Map<String, dynamic> result) {
      List newlistBocoJars = [];
      int rowCount = (result["data"] as List).length;
      //int countColumns = result["data"]?[0]?.length + 1;

      for (var row in result["data"] as List) {
        row.add(false);
      }

      for (int i = 1; i < rowCount; i++) {
        // newlistBocoJars.add(List.from(result["data"]?[i] as List));
        newlistBocoJars.add(result["data"]?[i]);
      }

      setState(() {
        _listBocoJars = newlistBocoJars;
      });

      // scrollControllerTable.jumpTo(1);
      // scrollControllerTable.jumpTo(0);
    });
  }

  void addBocoJar(String uuid, String productTitle, String productUuid, String groupTitle, String groupUuit, String artifactTitle, String artifactUuid) {
    //uuid	product_title	product_id	group_title	group_id	artifact_title	artifact_id
    List values = [];
    values.add(uuid);
    values.add(productTitle);
    values.add(productUuid);
    values.add(groupTitle);
    values.add(groupUuit);
    values.add(artifactTitle);
    values.add(artifactUuid);

    _helper.postExsqlInsert("boco_jars", values).then((value) {
      setState(() {
        values.add(false);
        _listBocoJars.add(values);
      });
    });
  }

  void addBocoJarVersion() {
    List newListBocoJars = [
      [1, 'b', 'b', 'b', 'b', 'b', 'b']
    ];

    setState(() {
      _listBocoJars = newListBocoJars;
    });
  }

  @override
  void didUpdateWidget(covariant DevopsBocoJars oldWidget) {
    _logger.d('.................');

    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    setJarInfoLocation('com.boco.alarms.common', '亿阳信通-故障管理-通用', 'alarm-common-monitor', '告警流水', '1.0.0-20020202', '高彦夫');
    setJarInfoLocationXml("<dependency>...</dependency>");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _logger.d('WidgetsBinding.instance.addPostFrameCallback');

      getBocoJars();

      Doraemon.dbSystem.add("add by boco_jars.widget");
      _logger.d("Helper.dbSystem.length = ${Doraemon.dbSystem.length}");
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return getWidgetLayoutMain();
  }
}

//ignore: must_be_immutable
class DialogAddBocoJar extends Dialog {
  DialogAddBocoJar({super.key});

  String companyProductIdSelected = '';
  String groupIdSelected = '';
  String versionsSelected = '';
  String statusSelected = 'unknown';
  String checkResultSelected = '';

  bool _isArtifactIdChecked = false;

  final TextEditingController _textControllerArtifactId = TextEditingController();
  final TextEditingController _textControllerArtifactTitle = TextEditingController();
  final TextEditingController _textControllerVersion = TextEditingController();
  final TextEditingController _textControllerMemo = TextEditingController();
  final TextEditingController _textControllerDependency = TextEditingController();
  final TextEditingController _textControllerDeveloper = TextEditingController();

  final _colorMask = const Color.fromRGBO(0, 0, 0, 0.2);
  final _colorDialog = const Color.fromRGBO(255, 255, 255, 1);
  final _colorTitleBar = const Color.fromRGBO(0, 55, 175, 1);
  final _colorTitleBarBorder = const Color.fromRGBO(215, 215, 215, 1);
  final _colorTitle = const Color.fromRGBO(255, 255, 255, 1);
  final _colorContent = const Color.fromRGBO(215, 215, 215, 1);
  final _colorContentBorder = const Color.fromRGBO(215, 215, 215, 1);

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
              width: 800,
              height: 600,
              color: _colorDialog,
              child: Column(children: [
                Container(
                  alignment: Alignment.center,
                  height: 40,
                  decoration: BoxDecoration(color: _colorTitleBar, border: Border.all(color: _colorTitleBarBorder, width: 1)),
                  child: Text(
                    '新增自研组件',
                    style: TextStyle(color: _colorTitle, fontSize: 16),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.topLeft,
                    decoration: BoxDecoration(color: _colorContent, border: Border.all(color: _colorContentBorder, width: 1)),
                    child: Column(children: [
                      Expanded(
                        child: Container(
                          alignment: Alignment.topLeft,
                          margin: const EdgeInsets.all(10),
                          color: _colorContent,
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            const Text(
                              '归属： com.boco.{产品标识}',
                            ),
                            //SizedBox(
                            //width: 490,
                            //child:
                            DropdownButton(
                                isExpanded: true,
                                value: companyProductIdSelected,
                                items: const [
                                  DropdownMenuItem(
                                    value: '',
                                    child: Text('请选择'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'com.boco.alarms',
                                    child: Text('亿阳信通故障管理'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'com.boco.trans',
                                    child: Text('亿阳信通传输网管'),
                                  )
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    companyProductIdSelected = value!;
                                  });
                                }),
                            //),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              '分组： GroupID = com.boco.{产品标识}.{分组标识}',
                            ),
                            //SizedBox(
                            //width: 490,
                            //child:
                            DropdownButton(
                                isExpanded: true,
                                value: groupIdSelected,
                                items: const [
                                  DropdownMenuItem(
                                    value: '',
                                    child: Text('请选择'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'common',
                                    child: Text('通用组件'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'ucmp',
                                    child: Text('集中配置'),
                                  )
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    groupIdSelected = value!;
                                  });
                                }),
                            //),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('制品标识： ArtifactID'),
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      child: TextField(
                                        controller: _textControllerArtifactId,
                                        decoration: const InputDecoration(
                                          hintText: '请输入关键字',
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(children: [
                                      const Expanded(
                                        child: Text('制品名称：'),
                                      ),
                                      !_isArtifactIdChecked
                                          ? const SizedBox(
                                              width: 10,
                                            )
                                          : Row(children: const [
                                              Checkbox(value: false, onChanged: null),
                                              Text('使用旧制品名称'),
                                            ]),
                                    ]),
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      child: TextField(
                                        controller: _textControllerArtifactTitle,
                                        decoration: const InputDecoration(
                                          hintText: '请输入关键字',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('组件版本： Version'),
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      child: TextField(
                                        controller: _textControllerVersion,
                                        decoration: const InputDecoration(
                                          hintText: '请输入关键字',
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
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('版本状态：'),
                                    DropdownButton(
                                        isExpanded: true,
                                        value: statusSelected,
                                        items: const [
                                          DropdownMenuItem(
                                            value: 'unknown',
                                            child: Text('请选择'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'planning',
                                            child: Text('规划中'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'coding',
                                            child: Text('开发中'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'released',
                                            child: Text('已发布'),
                                          ),
                                        ],
                                        onChanged: (value) {
                                          setState(() {
                                            statusSelected = value!;
                                          });
                                        }),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('责任人：'),
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      child: TextField(
                                        controller: _textControllerDeveloper,
                                        decoration: const InputDecoration(
                                          hintText: '请输入关键字',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('备注：'),
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      child: TextField(
                                        controller: _textControllerMemo,
                                        decoration: const InputDecoration(
                                          hintText: '请输入关键字',
                                        ),
                                        maxLines: 5,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('坐标：'),
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      child: TextField(
                                        controller: _textControllerDependency,
                                        decoration: const InputDecoration(
                                          hintText: '请输入关键字',
                                        ),
                                        maxLines: 5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                          ]),
                        ),
                      ),
                      Row(children: [
                        const Spacer(),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _isArtifactIdChecked = !_isArtifactIdChecked;
                              });
                            },
                            child: const Text('校验')),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Map values = {
                                "uuid": "1",
                                "productTitle": "亿阳信通-故障管理",
                                "productUuid": "com.boco.alarms",
                                "groupTitle": "集中配置",
                                "groupUuid": "ucmp",
                                "artifactTitle": "集中配置客户端",
                                "artifactUuid": "ucmp-client",
                              };
                              Navigator.of(context).pop({"isConfirmed": true, "values": values});
                            },
                            child: const Text('保存')),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop({
                                "isConfirmed": false,
                                "values": ["a"]
                              });
                            },
                            child: const Text('放弃')),
                        const SizedBox(
                          width: 10,
                        ),
                      ]),
                      const SizedBox(
                        height: 10,
                      ),
                    ]),
                  ),
                ),
              ]),
            ),
          ));
    });
  }
}

//ignore: must_be_immutable
class DialogAddBocoJarVersion extends Dialog {
  DialogAddBocoJarVersion({super.key});

  String companyProductIdSelected = '';
  String groupIdSelected = '';
  String versionsSelected = '1.0.1';
  String statusSelected = 'unknown';
  String checkResultSelected = '';

  bool _isArtifactIdChecked = false;

  final TextEditingController _textControllerArtifactId = TextEditingController();
  final TextEditingController _textControllerArtifactTitle = TextEditingController();
  final TextEditingController _textControllerVersion = TextEditingController();
  final TextEditingController _textControllerMemo = TextEditingController();
  final TextEditingController _textControllerDependency = TextEditingController();
  final TextEditingController _textControllerDeveloper = TextEditingController();

  final _colorMask = const Color.fromRGBO(0, 0, 0, 0.2);
  final _colorDialog = const Color.fromRGBO(255, 255, 255, 1);
  final _colorTitleBar = const Color.fromRGBO(0, 55, 175, 1);
  final _colorTitleBarBorder = const Color.fromRGBO(215, 215, 215, 1);
  final _colorTitle = const Color.fromRGBO(255, 255, 255, 1);
  final _colorContent = const Color.fromRGBO(215, 215, 215, 1);
  final _colorContentBorder = const Color.fromRGBO(215, 215, 215, 1);

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
              width: 800,
              height: 600,
              color: _colorDialog,
              child: Column(children: [
                Container(
                  alignment: Alignment.center,
                  height: 40,
                  decoration: BoxDecoration(color: _colorTitleBar, border: Border.all(color: _colorTitleBarBorder, width: 1)),
                  child: Text(
                    '新增自研组件版本',
                    style: TextStyle(color: _colorTitle, fontSize: 16),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.topLeft,
                    decoration: BoxDecoration(color: _colorContent, border: Border.all(color: _colorContentBorder, width: 1)),
                    child: Column(children: [
                      Expanded(
                        child: Container(
                          alignment: Alignment.topLeft,
                          margin: const EdgeInsets.all(10),
                          color: _colorContent,
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            const Text(
                              '归属： com.boco.{产品标识}',
                            ),
                            //SizedBox(
                            //width: 490,
                            //child:
                            DropdownButton(
                                isExpanded: true,
                                value: companyProductIdSelected,
                                items: const [
                                  DropdownMenuItem(
                                    value: '',
                                    child: Text('请选择'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'com.boco.alarms',
                                    child: Text('亿阳信通故障管理'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'com.boco.trans',
                                    child: Text('亿阳信通传输网管'),
                                  )
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    companyProductIdSelected = value!;
                                  });
                                }),
                            //),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              '分组： GroupID = com.boco.{产品标识}.{分组标识}',
                            ),
                            //SizedBox(
                            //width: 490,
                            //child:
                            DropdownButton(
                                isExpanded: true,
                                value: groupIdSelected,
                                items: const [
                                  DropdownMenuItem(
                                    value: '',
                                    child: Text('请选择'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'common',
                                    child: Text('通用组件'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'ucmp',
                                    child: Text('集中配置'),
                                  )
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    groupIdSelected = value!;
                                  });
                                }),
                            //),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('制品标识： ArtifactID'),
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      child: TextField(
                                        controller: _textControllerArtifactId,
                                        decoration: const InputDecoration(
                                          hintText: '请输入关键字',
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('制品名称：'),
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      child: TextField(
                                        controller: _textControllerArtifactTitle,
                                        decoration: const InputDecoration(
                                          hintText: '请输入关键字',
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('版本列表：'),
                                    DropdownButton(
                                        isExpanded: true,
                                        value: versionsSelected,
                                        items: const [
                                          DropdownMenuItem(
                                            value: '1.0.1',
                                            child: Text('1.0.1'),
                                          ),
                                          DropdownMenuItem(
                                            value: '1.1.0',
                                            child: Text('1.1.0'),
                                          )
                                        ],
                                        onChanged: (value) {
                                          setState(() {
                                            versionsSelected = value!;
                                          });
                                        }),
                                    //),
                                    //   ]),
                                    // ),
                                    //]),
                                    //),
                                  ],
                                ),
                              ),
                            ]),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(children: [
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('组件版本： Version'),
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      child: TextField(
                                        controller: _textControllerVersion,
                                        decoration: const InputDecoration(
                                          hintText: '请输入关键字',
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
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('版本状态：'),
                                    DropdownButton(
                                        isExpanded: true,
                                        value: statusSelected,
                                        items: const [
                                          DropdownMenuItem(
                                            value: 'unknown',
                                            child: Text('请选择'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'planning',
                                            child: Text('规划中'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'coding',
                                            child: Text('开发中'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'released',
                                            child: Text('已发布'),
                                          ),
                                        ],
                                        onChanged: (value) {
                                          setState(() {
                                            statusSelected = value!;
                                          });
                                        }),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('责任人：'),
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      child: TextField(
                                        controller: _textControllerDeveloper,
                                        decoration: const InputDecoration(
                                          hintText: '请输入关键字',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('备注：'),
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      child: TextField(
                                        controller: _textControllerMemo,
                                        decoration: const InputDecoration(
                                          hintText: '请输入关键字',
                                        ),
                                        maxLines: 5,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('坐标：'),
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      child: TextField(
                                        controller: _textControllerDependency,
                                        decoration: const InputDecoration(
                                          hintText: '请输入关键字',
                                        ),
                                        maxLines: 5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                          ]),
                        ),
                      ),
                      Row(children: [
                        const Spacer(),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _isArtifactIdChecked = !_isArtifactIdChecked;
                              });
                            },
                            child: const Text('校验')),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            child: const Text('保存')),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: const Text('放弃')),
                        const SizedBox(
                          width: 10,
                        ),
                      ]),
                      const SizedBox(
                        height: 10,
                      ),
                    ]),
                  ),
                ),
              ]),
            ),
          ));
    });
  }

  /*
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(''),
                                  ElevatedButton(onPressed: () {}, child: const Text('校验')),
                                ],
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              !_isArtifactIdChecked
                                  ? const SizedBox(
                                      width: 300,
                                    )
                                  : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      const Text('制品名称不同，但制品ID相同，版本列表如下：'),
                                      Container(
                                        alignment: Alignment.topLeft,
                                        // color: Colors.red,
                                        //child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                                        //const Text('版本：'),
                                        //Container(
                                        //alignment: Alignment.topLeft,
                                        width: 300,
                                        child:
                                            //     const Text(''),
                                    ]),



                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(''),
                                  ElevatedButton(onPressed: () {}, child: const Text('校验')),
                                ],
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              !_isStatusChecked
                                  ? const SizedBox(
                                      width: 300,
                                    )
                                  : Expanded(
                                      flex: 1,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: const [
                                          Text(''),
                                          Text('校验结果：'),
                                        ],
                                      ),
                                    ),

  */
}

//ignore: must_be_immutable
class DialogManageJarsCategories extends Dialog {
  DialogManageJarsCategories({super.key});

  final _logger = Logger();

  int groupIdSelected = 1;
  int versionSelected = 1;

  final _colorMask = const Color.fromRGBO(0, 0, 0, 0.2);
  final _colorDialog = const Color.fromRGBO(255, 255, 255, 1);
  final _colorTitleBar = const Color.fromRGBO(0, 55, 175, 1);
  final _colorTitleBarBorder = const Color.fromRGBO(215, 215, 215, 1);
  final _colorTitle = const Color.fromRGBO(255, 255, 255, 1);
  final _colorContent = const Color.fromRGBO(215, 215, 215, 1);
  final _colorContentBorder = const Color.fromRGBO(215, 215, 215, 1);

  void onButtonPressedAddJarsCategoriesFirst(BuildContext context) async {
    bool? isConfirmed = await showDialogAddJarsCategoriesFirst(context, '新增一级（制品归属）类目');

    if (isConfirmed != null) {
      if (isConfirmed) {
        _logger.d("重建依赖关系");
      } else {
        _logger.d("放弃操作");
      }
    }
  }

  void onButtonPressedModifyJarsCategoriesFirst(BuildContext context) async {
    bool? isConfirmed = await showDialogAddJarsCategoriesFirst(context, '修改一级（制品归属）类目');

    if (isConfirmed != null) {
      if (isConfirmed) {
        _logger.d("重建依赖关系");
      } else {
        _logger.d("放弃操作");
      }
    }
  }

  void onButtonPressedAddJarsCategoriesSecond(BuildContext context) async {
    bool? isConfirmed = await showDialogAddJarsCategoriesSecond(context, '新增二级（制品分组）类目');

    if (isConfirmed != null) {
      if (isConfirmed) {
        _logger.d("重建依赖关系");
      } else {
        _logger.d("放弃操作");
      }
    }
  }

  void onButtonPressedModifyJarsCategoriesSecond(BuildContext context) async {
    bool? isConfirmed = await showDialogAddJarsCategoriesSecond(context, '修改二级（制品分组）类目');

    if (isConfirmed != null) {
      if (isConfirmed) {
        _logger.d("重建依赖关系");
      } else {
        _logger.d("放弃操作");
      }
    }
  }

  Future<bool?> showDialogAddJarsCategoriesFirst(BuildContext context, String title) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return DialogAddJarsCategoriesFirst(
          title: title,
        );
      },
    );
  }

  Future<bool?> showDialogAddJarsCategoriesSecond(BuildContext context, String title) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return DialogAddJarsCategoriesSecond(title: title);
      },
    );
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
              width: 800,
              height: 600,
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
                        '自研组件类目管理',
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
                        child: Row(children: [
                          Expanded(
                            child: Column(
                              children: [
                                Row(children: [
                                  const Text('一级类目（制品归属）：'),
                                  const Spacer(),
                                  ElevatedButton(
                                      onPressed: () {
                                        onButtonPressedAddJarsCategoriesFirst(context);
                                      },
                                      child: const Text('新增')),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        onButtonPressedModifyJarsCategoriesFirst(context);
                                      },
                                      child: const Text('修改')),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  ElevatedButton(onPressed: () {}, child: const Text('删除')),
                                ]),
                                const SizedBox(
                                  height: 5,
                                ),
                                Expanded(
                                    child: Container(
                                  alignment: Alignment.topLeft,
                                  color: Colors.white,
                                ))
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
                                  const Text('二级类目（制品分组）：'),
                                  const Spacer(),
                                  ElevatedButton(
                                      onPressed: () {
                                        onButtonPressedAddJarsCategoriesSecond(context);
                                      },
                                      child: const Text('新增')),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        onButtonPressedModifyJarsCategoriesSecond(context);
                                      },
                                      child: const Text('修改')),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  ElevatedButton(onPressed: () {}, child: const Text('删除')),
                                ]),
                                const SizedBox(
                                  height: 5,
                                ),
                                Expanded(
                                    child: Container(
                                  alignment: Alignment.topLeft,
                                  color: Colors.white,
                                ))
                              ],
                            ),
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

//ignore: must_be_immutable
class DialogAddJarsCategoriesFirst extends Dialog {
  DialogAddJarsCategoriesFirst({super.key, required this.title});

  final String title;
  int groupIdSelected = 1;
  int versionSelected = 1;

  final _colorMask = const Color.fromRGBO(0, 0, 0, 0.2);
  final _colorDialog = const Color.fromRGBO(255, 255, 255, 1);
  final _colorTitleBar = const Color.fromRGBO(0, 55, 175, 1);
  final _colorTitleBarBorder = const Color.fromRGBO(215, 215, 215, 1);
  final _colorTitle = const Color.fromRGBO(255, 255, 255, 1);
  final _colorContent = const Color.fromRGBO(215, 215, 215, 1);
  final _colorContentBorder = const Color.fromRGBO(215, 215, 215, 1);

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
              width: 400,
              height: 300,
              color: _colorDialog,
              child: Column(children: [
                Container(
                  alignment: Alignment.center,
                  height: 40,
                  decoration: BoxDecoration(color: _colorTitleBar, border: Border.all(color: _colorTitleBarBorder, width: 1)),
                  child: Text(
                    title,
                    style: TextStyle(color: _colorTitle, fontSize: 16),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.topLeft,
                    decoration: BoxDecoration(color: _colorContent, border: Border.all(color: _colorContentBorder, width: 1)),
                    child: Column(children: [
                      Expanded(
                        child: Container(
                          alignment: Alignment.topLeft,
                          margin: const EdgeInsets.all(10),
                          color: _colorContent,
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            const Text('一级类目（制品归属）名称：'),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: const TextField(
                                controller: null,
                                decoration: InputDecoration(
                                  hintText: '请输入关键字',
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text('一级类目（制品归属）标识：'),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: const TextField(
                                controller: null,
                                decoration: InputDecoration(
                                  hintText: '请输入关键字',
                                ),
                              ),
                            ),
                          ]),
                        ),
                      ),
                      Row(children: [
                        const Spacer(),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            child: const Text('保存')),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: const Text('放弃')),
                        const SizedBox(
                          width: 10,
                        ),
                      ]),
                      const SizedBox(
                        height: 10,
                      ),
                    ]),
                  ),
                ),
              ]),
            ),
          ));
    });
  }
}

//ignore: must_be_immutable
class DialogAddJarsCategoriesSecond extends Dialog {
  DialogAddJarsCategoriesSecond({super.key, required this.title});

  final String title;
  int groupIdSelected = 1;
  int versionSelected = 1;

  final _colorMask = const Color.fromRGBO(0, 0, 0, 0.2);
  final _colorDialog = const Color.fromRGBO(255, 255, 255, 1);
  final _colorTitleBar = const Color.fromRGBO(0, 55, 175, 1);
  final _colorTitleBarBorder = const Color.fromRGBO(215, 215, 215, 1);
  final _colorTitle = const Color.fromRGBO(255, 255, 255, 1);
  final _colorContent = const Color.fromRGBO(215, 215, 215, 1);
  final _colorContentBorder = const Color.fromRGBO(215, 215, 215, 1);

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
              width: 400,
              height: 300,
              color: _colorDialog,
              child: Column(children: [
                Container(
                  alignment: Alignment.center,
                  height: 40,
                  decoration: BoxDecoration(color: _colorTitleBar, border: Border.all(color: _colorTitleBarBorder, width: 1)),
                  child: Text(
                    title,
                    style: TextStyle(color: _colorTitle, fontSize: 16),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.topLeft,
                    decoration: BoxDecoration(color: _colorContent, border: Border.all(color: _colorContentBorder, width: 1)),
                    child: Column(children: [
                      Expanded(
                        child: Container(
                          alignment: Alignment.topLeft,
                          margin: const EdgeInsets.all(10),
                          color: _colorContent,
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            const Text('二级类目（制品分组）名称：'),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: const TextField(
                                controller: null,
                                decoration: InputDecoration(
                                  hintText: '请输入关键字',
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text('二级类目（制品分组）标识：'),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: const TextField(
                                controller: null,
                                decoration: InputDecoration(
                                  hintText: '请输入关键字',
                                ),
                              ),
                            ),
                          ]),
                        ),
                      ),
                      Row(children: [
                        const Spacer(),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            child: const Text('保存')),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: const Text('放弃')),
                        const SizedBox(
                          width: 10,
                        ),
                      ]),
                      const SizedBox(
                        height: 10,
                      ),
                    ]),
                  ),
                ),
              ]),
            ),
          ));
    });
  }
}

class KSizeChangedNotification extends LayoutChangedNotification {
  Size size;
  //MeasureUtil.measureWidget(myColumn)

  KSizeChangedNotification(this.size);
}

class KSizeChangedNotifier extends SingleChildRenderObjectWidget {
  const KSizeChangedNotifier({super.key, required Widget child}) : super(child: child);

  @override
  KRenderSizeChangedWithCallback createRenderObject(BuildContext context) {
    RenderBox box = context.findRenderObject() as RenderBox;

    return KRenderSizeChangedWithCallback(
        child: box,
        onLayoutChangedCallback: (Size size) {
          KSizeChangedNotification(size).dispatch(context);
        });
  }
}

class KRenderSizeChangedWithCallback extends RenderProxyBox {
  KRenderSizeChangedWithCallback({required RenderBox child, required this.onLayoutChangedCallback}) : super(child);

  final ValueChanged<Size> onLayoutChangedCallback;

  Size _oldSize = const Size(0, 0);

  @override
  void performLayout() {
    super.performLayout();

    if (size != _oldSize) onLayoutChangedCallback(size);

    _oldSize = size;
  }
}
