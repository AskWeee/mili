import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:logger/logger.dart';
import 'package:flutter_treeview/flutter_treeview.dart';

class DevopsBocoJars extends StatefulWidget {
  const DevopsBocoJars({super.key});

  @override
  State<DevopsBocoJars> createState() => _DevopsBocoJarsState();
}

class _DevopsBocoJarsState extends State<DevopsBocoJars> {
  var _key = GlobalKey();
  Size? _redboxSize;
  bool isChanging = false;

  final _logger = Logger();

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
            onPressed: () {},
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
        trackVisibility: true,
        interactive: true,
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
                    getWidgetJarsTable(),
                    // getWidgetJarsDataTable(),
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
        ));
  }

  Container getWidgetJarInfoLocation() {
    return Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(10),
        color: _colorBackgroundTabBarView,
        child: Table(
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
                  child: Text('组标识（GroupID）'),
                ),
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.top,
                  child: Text('组名称'),
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
                  child: Text('制品标识（ArtifactID）'),
                ),
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.top,
                  child: Text('制品名称'),
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
            const TableRow(
              children: <Widget>[
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.top,
                  child: Text('版本'),
                ),
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.top,
                  child: Text('责任人'),
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
                      child: TextField(controller: _textControllerJarVersion),
                    ),
                  ),
                ),
                TableCell(
                  // verticalAlignment: TableCellVerticalAlignment.top,
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Card(
                      child: TextField(controller: _textControllerJarManager),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
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
        children: _renderList(),
        // children: <TableRow>[

        //   _renderList().map((e) => e;),
        // ],
      ),
    );
  }

  DataTable makeJarsDataTable() {
    int rowsCount = 100;
    int columnsCount = 30;

    List<DataColumn> columns() {
      List<DataColumn> column = [];

      for (var i = 0; i < columnsCount; i++) {
        column.add(DataColumn(label: Text('列标题$i')));
      }
      return column;
    }

    List<DataCell> cells() {
      List<DataCell> cells = [];
      for (var i = 0; i < columnsCount; i++) {
        cells.add(DataCell(Text('$i')));
      }
      return cells;
    }

    List<DataRow> rows() {
      //行
      List<DataRow> rows = [];
      for (var i = 0; i < rowsCount; i++) {
        rows.add(DataRow(cells: cells()));
      }
      return rows;
    }

    return DataTable(columns: columns(), rows: rows());
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
    bool? isConfirmed = await showDialogAddBocoJar();

    if (isConfirmed != null) {
      if (isConfirmed) {
        _logger.d("重建依赖关系");
      } else {
        _logger.d("放弃操作");
      }
    }
  }

  void onButtonPressedAddBocoJarVersion() async {
    bool? isConfirmed = await showDialogAddBocoJarVersion();

    if (isConfirmed != null) {
      if (isConfirmed) {
        _logger.d("重建依赖关系");
      } else {
        _logger.d("放弃操作");
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

  Future<bool?> showDialogAddBocoJar() {
    return showDialog<bool>(
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

  List<TableRow> _renderList() {
    List titleList = ['aa', 'bb', 'cc', 'dd', 'ee', 'ff', 'gg', 'hh', 'ii', 'jj', 'kk', 'll', 'mm', 'nn', 'oo', 'pp', 'qq', 'rr', 'ss', 'tt'];
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

    for (var i = 0; i < titleList.length; i++) {
      list.add(TableRow(children: [
        Container(
          padding: const EdgeInsets.all(12),
          child: Text(titleList[i]),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          child: Text(titleList[i] * 2),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          child: Text(titleList[i] * 3),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          child: Text(titleList[i] * 4),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          child: Text(titleList[i] * 5),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          child: Text(titleList[i] * 6),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          child: Text(titleList[i] * 7),
        ),
      ]));
    }
    return list;
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

    setState(() {
      isChanging = true;
      _sliderTableScrollbarValueCurrent = 0;
      _sliderTableScrollbarValueMax = metrics.maxScrollExtent;
      isChanging = false;
    });

    return true;
  }

  bool _handleKSizeChangedNotification(KSizeChangedNotification notification) {
    _logger.d('... ${notification.size} ...');
    return true;
  }

  Size getRedBoxSize(BuildContext context) {
    final box = context.findRenderObject() as RenderBox;
    return box.size;
  }

  @override
  void didUpdateWidget(covariant DevopsBocoJars oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    _logger.d('.................');
  }

  @override
  void initState() {
    setJarInfoLocation('com.boco.alarms.common', '亿阳信通-故障管理-通用', 'alarm-common-monitor', '告警流水', '1.0.0-20020202', '高彦夫');
    setJarInfoLocationXml("<dependency>...</dependency>");

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      // _logger.d('>>> ${getRedBoxSize(_key.currentContext!)}');

      // setState(() {
      //   _redboxSize = getRedBoxSize(_key.currentContext!);
      // });
      scrollControllerTable.jumpTo(1);
      scrollControllerTable.jumpTo(0);
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

  int groupIdSelected = 1;
  int versionSelected = 1;

  final TextEditingController _textControllerArtifactId = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, StateSetter setState) {
      return Material(
          type: MaterialType.transparency,
          child: Container(
            alignment: Alignment.center,
            color: const Color.fromRGBO(0, 0, 0, 0.2),
            child: Container(
              alignment: Alignment.center,
              width: 800,
              height: 600,
              color: const Color.fromRGBO(0, 49, 222, 1),
              child: Column(children: [
                Container(
                  alignment: Alignment.center,
                  height: 40,
                  decoration: BoxDecoration(color: const Color.fromRGBO(75, 75, 75, 1), border: Border.all(color: const Color.fromRGBO(75, 75, 75, 1), width: 1)),
                  child: const Text(
                    '新增自研组件',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.topLeft,
                    decoration: BoxDecoration(color: const Color.fromRGBO(215, 215, 215, 1), border: Border.all(color: const Color.fromRGBO(215, 215, 215, 1), width: 1)),
                    child: Column(children: [
                      Expanded(
                        child: Container(
                          alignment: Alignment.topLeft,
                          margin: const EdgeInsets.all(10),
                          color: const Color.fromRGBO(215, 215, 215, 1),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            const Text(
                              '组件类别标识（GroupID）：',
                            ),
                            DropdownButton(
                                isExpanded: true,
                                value: groupIdSelected,
                                items: const [
                                  DropdownMenuItem(
                                    value: 1,
                                    child: Text('亿阳信通故障管理-通用组件'),
                                  ),
                                  DropdownMenuItem(
                                    value: 2,
                                    child: Text('亿阳信通故障管理-集中配置'),
                                  )
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    groupIdSelected = value as int;
                                  });
                                }),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('组件标识（ArtifactID）：'),
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
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('历史版本：'),
                                    DropdownButton(
                                        isExpanded: true,
                                        value: versionSelected,
                                        items: const [
                                          DropdownMenuItem(
                                            value: 1,
                                            child: Text('1.0.1'),
                                          ),
                                          DropdownMenuItem(
                                            value: 2,
                                            child: Text('1.1.0'),
                                          )
                                        ],
                                        onChanged: (value) {
                                          setState(() {
                                            versionSelected = value as int;
                                          });
                                        }),
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
                                    const Text('组件版本（Version）：'),
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
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('版本状态：'),
                                    DropdownButton(
                                        isExpanded: true,
                                        value: versionSelected,
                                        items: const [
                                          DropdownMenuItem(
                                            value: 1,
                                            child: Text('未知'),
                                          ),
                                          DropdownMenuItem(
                                            value: 2,
                                            child: Text('带上传'),
                                          )
                                        ],
                                        onChanged: (value) {
                                          setState(() {
                                            versionSelected = value as int;
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
                                    const Text('定位状态：'),
                                    DropdownButton(
                                        isExpanded: true,
                                        value: versionSelected,
                                        items: const [
                                          DropdownMenuItem(
                                            value: 1,
                                            child: Text('成功'),
                                          ),
                                          DropdownMenuItem(
                                            value: 2,
                                            child: Text('失败'),
                                          )
                                        ],
                                        onChanged: (value) {
                                          setState(() {
                                            versionSelected = value as int;
                                          });
                                        }),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(''),
                                  ElevatedButton(onPressed: () {}, child: const Text('定位')),
                                ],
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
                                    const Text('完整坐标（XML）：'),
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      child: TextField(
                                        controller: _textControllerArtifactId,
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
                                    const Text('组件备注：'),
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      child: TextField(
                                        controller: _textControllerArtifactId,
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
                              Navigator.of(context).pop(true);
                            },
                            child: const Text('确定')),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: const Text('关闭')),
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

  int groupIdSelected = 1;
  int versionSelected = 1;

  final TextEditingController _textControllerArtifactId = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, StateSetter setState) {
      return Material(
          type: MaterialType.transparency,
          child: Container(
            alignment: Alignment.center,
            color: const Color.fromRGBO(0, 0, 0, 0.2),
            child: Container(
              alignment: Alignment.center,
              width: 800,
              height: 600,
              color: const Color.fromRGBO(0, 49, 222, 1),
              child: Column(children: [
                Container(
                  alignment: Alignment.center,
                  height: 40,
                  decoration: BoxDecoration(color: const Color.fromRGBO(75, 75, 75, 1), border: Border.all(color: const Color.fromRGBO(75, 75, 75, 1), width: 1)),
                  child: const Text(
                    '自研组件新增版本',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.topLeft,
                    decoration: BoxDecoration(color: const Color.fromRGBO(215, 215, 215, 1), border: Border.all(color: const Color.fromRGBO(215, 215, 215, 1), width: 1)),
                    child: Column(children: [
                      Expanded(
                        child: Container(
                          alignment: Alignment.topLeft,
                          margin: const EdgeInsets.all(10),
                          color: const Color.fromRGBO(215, 215, 215, 1),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            const Text(
                              '组件类别标识（GroupID）：',
                            ),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: TextField(
                                readOnly: true,
                                controller: _textControllerArtifactId,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('组件标识（ArtifactID）：'),
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      child: TextField(
                                        readOnly: true,
                                        controller: _textControllerArtifactId,
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
                                    const Text('历史版本：'),
                                    DropdownButton(
                                        isExpanded: true,
                                        value: versionSelected,
                                        items: const [
                                          DropdownMenuItem(
                                            value: 1,
                                            child: Text('1.0.1'),
                                          ),
                                          DropdownMenuItem(
                                            value: 2,
                                            child: Text('1.1.0'),
                                          )
                                        ],
                                        onChanged: (value) {
                                          setState(() {
                                            versionSelected = value as int;
                                          });
                                        }),
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
                                    const Text('组件版本（Version）：'),
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      child: TextField(
                                        controller: _textControllerArtifactId,
                                        decoration: const InputDecoration(
                                          hintText: '请输入新的版本号',
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
                                        value: versionSelected,
                                        items: const [
                                          DropdownMenuItem(
                                            value: 1,
                                            child: Text('未知'),
                                          ),
                                          DropdownMenuItem(
                                            value: 2,
                                            child: Text('带上传'),
                                          )
                                        ],
                                        onChanged: (value) {
                                          setState(() {
                                            versionSelected = value as int;
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
                                    const Text('定位状态：'),
                                    DropdownButton(
                                        isExpanded: true,
                                        value: versionSelected,
                                        items: const [
                                          DropdownMenuItem(
                                            value: 1,
                                            child: Text('成功'),
                                          ),
                                          DropdownMenuItem(
                                            value: 2,
                                            child: Text('失败'),
                                          )
                                        ],
                                        onChanged: (value) {
                                          setState(() {
                                            versionSelected = value as int;
                                          });
                                        }),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(''),
                                  ElevatedButton(onPressed: () {}, child: const Text('定位')),
                                ],
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
                                    const Text('完整坐标（XML）：'),
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      child: TextField(
                                        controller: _textControllerArtifactId,
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
                                    const Text('组件备注：'),
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      child: TextField(
                                        controller: _textControllerArtifactId,
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
                              Navigator.of(context).pop(true);
                            },
                            child: const Text('确定')),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: const Text('关闭')),
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
class DialogManageJarsCategories extends Dialog {
  DialogManageJarsCategories({super.key});

  final _logger = Logger();

  int groupIdSelected = 1;
  int versionSelected = 1;

  void onButtonPressedAddJarsCategoriesFirst(BuildContext context) async {
    bool? isConfirmed = await showDialogAddJarsCategoriesFirst(context);

    if (isConfirmed != null) {
      if (isConfirmed) {
        _logger.d("重建依赖关系");
      } else {
        _logger.d("放弃操作");
      }
    }
  }

  void onButtonPressedAddJarsCategoriesSecond(BuildContext context) async {
    bool? isConfirmed = await showDialogAddJarsCategoriesSecond(context);

    if (isConfirmed != null) {
      if (isConfirmed) {
        _logger.d("重建依赖关系");
      } else {
        _logger.d("放弃操作");
      }
    }
  }

  Future<bool?> showDialogAddJarsCategoriesFirst(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return DialogAddJarsCategoriesFirst();
      },
    );
  }

  Future<bool?> showDialogAddJarsCategoriesSecond(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return DialogAddJarsCategoriesSecond();
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
            color: const Color.fromRGBO(0, 0, 0, 0.2),
            child: Container(
              alignment: Alignment.center,
              width: 800,
              height: 600,
              color: const Color.fromRGBO(0, 49, 222, 1),
              child: Column(children: [
                Container(
                  alignment: Alignment.center,
                  height: 40,
                  decoration: BoxDecoration(color: const Color.fromRGBO(75, 75, 75, 1), border: Border.all(color: const Color.fromRGBO(75, 75, 75, 1), width: 1)),
                  child: const Text(
                    '自研组件类目管理',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.topLeft,
                    decoration: BoxDecoration(color: const Color.fromRGBO(215, 215, 215, 1), border: Border.all(color: const Color.fromRGBO(215, 215, 215, 1), width: 1)),
                    child: Column(children: [
                      Expanded(
                        child: Container(
                          alignment: Alignment.topLeft,
                          margin: const EdgeInsets.all(10),
                          color: const Color.fromRGBO(215, 215, 215, 1),
                          child: Row(children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Row(children: [
                                    const Text('一级类目：'),
                                    const Spacer(),
                                    ElevatedButton(
                                        onPressed: () {
                                          onButtonPressedAddJarsCategoriesFirst(context);
                                        },
                                        child: const Text('新增')),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    ElevatedButton(onPressed: () {}, child: const Text('删除')),
                                  ]),
                                  Expanded(
                                      child: Container(
                                    alignment: Alignment.topLeft,
                                    color: Colors.amber,
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
                                    const Text('二级类目：'),
                                    const Spacer(),
                                    ElevatedButton(
                                        onPressed: () {
                                          onButtonPressedAddJarsCategoriesSecond(context);
                                        },
                                        child: const Text('新增')),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    ElevatedButton(onPressed: () {}, child: const Text('删除')),
                                  ]),
                                  Expanded(
                                      child: Container(
                                    alignment: Alignment.topLeft,
                                    color: Colors.amber,
                                  ))
                                ],
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
                            child: const Text('确定')),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: const Text('关闭')),
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
class DialogAddJarsCategoriesFirst extends Dialog {
  DialogAddJarsCategoriesFirst({super.key});

  int groupIdSelected = 1;
  int versionSelected = 1;

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, StateSetter setState) {
      return Material(
          type: MaterialType.transparency,
          child: Container(
            alignment: Alignment.center,
            color: const Color.fromRGBO(0, 0, 0, 0.1),
            child: Container(
              alignment: Alignment.center,
              width: 600,
              height: 400,
              color: const Color.fromRGBO(0, 49, 222, 1),
              child: Column(children: [
                Container(
                  alignment: Alignment.center,
                  height: 40,
                  decoration: BoxDecoration(color: const Color.fromRGBO(75, 75, 75, 1), border: Border.all(color: const Color.fromRGBO(75, 75, 75, 1), width: 1)),
                  child: const Text(
                    '自研组件类目管理 - 新增一级类目',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.topLeft,
                    decoration: BoxDecoration(color: const Color.fromRGBO(215, 215, 215, 1), border: Border.all(color: const Color.fromRGBO(215, 215, 215, 1), width: 1)),
                    child: Column(children: [
                      Expanded(
                        child: Container(
                          alignment: Alignment.topLeft,
                          margin: const EdgeInsets.all(10),
                          color: const Color.fromRGBO(215, 215, 215, 1),
                          child: Column(children: [
                            const Text('一级类目名称：'),
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
                            const Text('一级类目标识：'),
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
                            child: const Text('确定')),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: const Text('关闭')),
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
  DialogAddJarsCategoriesSecond({super.key});

  int groupIdSelected = 1;
  int versionSelected = 1;

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, StateSetter setState) {
      return Material(
          type: MaterialType.transparency,
          child: Container(
            alignment: Alignment.center,
            color: const Color.fromRGBO(0, 0, 0, 0.1),
            child: Container(
              alignment: Alignment.center,
              width: 600,
              height: 400,
              color: const Color.fromRGBO(0, 49, 222, 1),
              child: Column(children: [
                Container(
                  alignment: Alignment.center,
                  height: 40,
                  decoration: BoxDecoration(color: const Color.fromRGBO(75, 75, 75, 1), border: Border.all(color: const Color.fromRGBO(75, 75, 75, 1), width: 1)),
                  child: const Text(
                    '自研组件类目管理 - 新增二级类目',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.topLeft,
                    decoration: BoxDecoration(color: const Color.fromRGBO(215, 215, 215, 1), border: Border.all(color: const Color.fromRGBO(215, 215, 215, 1), width: 1)),
                    child: Column(children: [
                      Expanded(
                        child: Container(
                          alignment: Alignment.topLeft,
                          margin: const EdgeInsets.all(10),
                          color: const Color.fromRGBO(215, 215, 215, 1),
                          child: Column(children: [
                            const Text('二级类目名称：'),
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
                            const Text('二级类目标识：'),
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
                            child: const Text('确定')),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: const Text('关闭')),
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
