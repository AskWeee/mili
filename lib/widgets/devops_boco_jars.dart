import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:flutter_treeview/flutter_treeview.dart';

class DevopsBocoJars extends StatefulWidget {
  const DevopsBocoJars({super.key});

  @override
  State<DevopsBocoJars> createState() => _DevopsBocoJarsState();
}

class _DevopsBocoJarsState extends State<DevopsBocoJars> {
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
              width: 200,
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
              '坐标搜索',
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
              onPressed: () {},
              child: const Text(
                '新增组件',
              )),
          const SizedBox(
            width: 10,
          ),
          ElevatedButton(
              onPressed: () {},
              child: const Text(
                '新增版本',
              )),
          const Spacer(),
          ElevatedButton(
              onPressed: () {},
              child: const Text(
                '组件类目管理',
              )),
          const SizedBox(
            width: 10,
          ),
          ElevatedButton(
              onPressed: onButtonRebuildDependencies,
              child: const Text(
                '重建依赖关系',
              )),
        ],
      ),
    );
  }

  List<TableRow> _renderList() {
    List titleList = ['aaaaaaaa', 'bbbb', 'ccccccccc', 'ddd', 'ee'];
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
          padding: EdgeInsets.all(12),
          child: Text(titleList[i]),
        ),
        Container(
          padding: EdgeInsets.all(12),
          child: Text(i % 2 == 0 ? 'content' : 'contentcontentcontentcontentcontentcontentcontentcontent'),
        ),
        Container(
          padding: EdgeInsets.all(12),
          child: Text(titleList[i]),
        ),
        Container(
          padding: EdgeInsets.all(12),
          child: Text(titleList[i]),
        ),
        Container(
          padding: EdgeInsets.all(12),
          child: Text(titleList[i]),
        ),
        Container(
          padding: EdgeInsets.all(12),
          child: Text(titleList[i]),
        ),
        Container(
          padding: EdgeInsets.all(12),
          child: Text(titleList[i]),
        ),
      ]));
    }
    return list;
  }

  Container getWidgetJarsTable() {
    return Container(
        alignment: Alignment.topLeft,
        margin: const EdgeInsets.all(10),
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
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
                ))));
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

  void onButtonRebuildDependencies() async {
    bool? isConfirmed = await showRebuildDependenciesConfirmDialog();

    if (isConfirmed != null) {
      if (isConfirmed) {
        _logger.d("重建依赖关系");
      } else {
        _logger.d("放弃操作");
      }
    }
  }

  Future<bool?> showRebuildDependenciesConfirmDialog() {
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

  @override
  void initState() {
    setJarInfoLocation('com.boco.alarms.common', '亿阳信通-故障管理-通用', 'alarm-common-monitor', '告警流水', '1.0.0-20020202', '高彦夫');
    setJarInfoLocationXml("<dependency>...</dependency>");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return getWidgetLayoutMain();
  }
}
