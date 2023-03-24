import 'dart:io';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mili/utils/doraemon.dart';
import 'package:mili/utils/helper.dart';
import 'package:intl/intl.dart';

/// FUNC01：呈现云环境中应用的实际部署情况
/// FUNC02：呈现可用的应用列表
///   显示全集，可过滤installed状态，类似VSCODE的插件库形式，点击应用，可看到应用的说明页面
///   应用名称，部署状态，部署版本，最新版本
///   按钮：部署，针对已经部署的应用，提供：扩缩，配置，启动，重启，停止，下线，更新，等操作，在应用说明页面体现
/// FUNC03：选择某个应用，设定部署策略，执行云部署
///   点击部署后，弹出窗口，完成部署策略制定工作
/// FUNC04：查看已经部署的应用的实际部署状态
/// FUNC05：设置应用的必要参数，启动应用
///   点击应用，弹出页面，完成应用参数配置工作，
///   点击应用控制器（如果有的话），弹出页面，完成必要的参数配置工作
/// FUNC06：查看应用的运行状态
///   呈现，应用-PODS
/// FUNC07：调整应用的参数，重启应用，提供启停操作
/// FUNC08：调整应用的部署，进行必要的伸缩，以适应业务变化
///
/// FUNC09：刷新应用源，获取应用版本发布信息
///   参考Intellij IDEA中maven包呈现及升级提醒的方式
/// FUNC10：发现有可用更新后，提示用户更新
///   点击升级，弹出升级配置页面
/// FUNC11：执行应用版本更新操作，采用上新，测试，切换，下线的方式进行
///   理论上和部署的页面一直，但自动套用已经配置的参数，只补充新增有修改的参数
/// FUNC12：点击应用，展示应用说明页面
///   文件根式为MarkDown格式
/// FUNC13：提供应用下线操作（remove操作）
///   下线将删除部署，同时将配置信息移入已删除应用配置区域，以备后用
/// FUNC14：新部署应用后，在备份区查找是否有配置信息，有则提供建议
/// FUNC15：提供应用管理页面
///   增删改查应用，制定应用控制器，配置默认参数
/// FUNC16：...

class OnCloudApps extends StatefulWidget {
  const OnCloudApps({super.key});

  @override
  State<OnCloudApps> createState() => _OnCloudAppsState();
}

class _OnCloudAppsState extends State<OnCloudApps> {
  final _logger = Logger();
  final _helper = Helper();

  final double _splitterWidth = 8;
  double _maxWidth = 0;
  double _ratio = 0.3;
  List _dataApps = [];

  int _appsTableColumnsCount = 0;
  int _rowSelectedLast = -1;

  bool isChanging = false;

  late WebSocket _socket;

  String versionsSelected = '1.0.1';
  String developerSelected = 'gaoyanfu';
  String statusSelected = 'unknown';

  final Color _colorBorderNormal = const Color.fromRGBO(0, 122, 204, 1);
  final Color _colorSplitter = const Color.fromRGBO(0, 122, 204, 1);

  BoxDecoration get _boxDebug => BoxDecoration(
        border: Border.all(
          color: Colors.red,
          width: 1,
        ),
      );
  BoxDecoration get _boxNormal => BoxDecoration(
        border: Border.all(
          color: _colorBorderNormal,
          width: 1,
        ),
      );

  BoxDecoration get _boxNone => BoxDecoration(
        border: Border.all(
          color: Colors.transparent,
          width: 1,
        ),
      );

  final ScrollController scrollControllerTable = ScrollController();
  final ScrollController scrollControllerDataTable = ScrollController();

  Slider mySlider = Slider(
      value: 1,
      onChanged: (value) {
        final logger = Logger();
        logger.d(value);
      });

  Widget makeBoxDebug(String message) {
    return Container(
      alignment: Alignment.topLeft,
      decoration: _boxDebug,
      padding: const EdgeInsets.all(5),
      child: Text(message),
    );
  }

  Widget makeLayoutMain(BuildContext context) {
    return LayoutBuilder(builder: (context, BoxConstraints constraints) {
      if (_maxWidth == 0) {
        _maxWidth = constraints.maxWidth - _splitterWidth;
      }

      return Container(
        alignment: Alignment.topLeft,
        decoration: _boxNormal,
        child: Row(children: [
          Container(
            alignment: Alignment.topLeft,
            decoration: _boxNormal,
            width: _maxWidth * _ratio,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  decoration: _boxNormal,
                  child: Row(children: [
                    const Expanded(
                      child: SizedBox(
                        height: 35,
                        child: Card(
                          child: TextField(),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text("搜索"),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    ElevatedButton(
                      onPressed: onButtonPressedRefresh,
                      child: const Text("刷新"),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    ElevatedButton(
                      onPressed: onButtonPressedAddApp,
                      child: const Text("新增"),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text("修改"),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text("删除"),
                    ),
                  ]),
                ),
                Expanded(
                  child: makeDataTableApps(),
                ),
              ],
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: Container(
              alignment: Alignment.topLeft,
              color: _colorSplitter,
              width: _splitterWidth,
            ),
            onPanUpdate: (DragUpdateDetails details) {
              setState(() {
                _ratio += details.delta.dx / _maxWidth;
                if (_ratio > 0.5) {
                  _ratio = 0.5;
                } else if (_ratio < 0.2) {
                  _ratio = 0.2;
                }
              });
            },
          ),
          Expanded(
            child: Container(
              alignment: Alignment.topLeft,
              decoration: _boxNormal,
              child: makeTabViewMain(),
            ),
          ),
        ]),
      );
    });
  }

  Widget makeDataTableApps() {
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
            child: makeAppsDataTable(),
          ),
        ),
      ),
    );
  }

  Widget makeTabViewMain() {
    return Container(
      alignment: Alignment.topLeft,
      child: DefaultTabController(
        length: 2,
        child: Column(children: [
          Expanded(
            flex: 1,
            child: Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.fromLTRB(3, 3, 3, 0),
                decoration: _boxNormal,
                child: TabBarView(
                  children: [
                    makeAppView(),
                    makeKubernetesView(),
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
                      text: 'App 详情',
                    ),
                    Tab(
                      text: 'Kubernetes 环境',
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

  Widget makeTabViewApp() {
    return Container(
      alignment: Alignment.topLeft,
      child: DefaultTabController(
        length: 4,
        child: Column(children: [
          Container(
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.fromLTRB(00, 0, 0, 0),
            child: const SizedBox(
              width: 500,
              child: Card(
                child: TabBar(
                  labelColor: Color.fromRGBO(0, 0, 0, 1),
                  tabs: [
                    Tab(
                      text: '运行实例',
                    ),
                    Tab(
                      text: '应用控制器',
                    ),
                    Tab(
                      text: '参数管理',
                    ),
                    Tab(
                      text: '发布信息',
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
                margin: const EdgeInsets.fromLTRB(3, 3, 3, 0),
                decoration: _boxNormal,
                child: TabBarView(
                  children: [
                    makeBoxDebug('未部署，无运行实例\n'),
                    makeBoxDebug('应用控制器：未指定\n'),
                    makeBoxDebug('模板参数\n参数1：xxx\n参数1：xxx\n参数1：xxx\n实例参数：\n实例1参数：xxx\n参数1：xxx\n参数1：xxx\n'),
                    makeBoxDebug("支持1：xxx\n支持1：xxx\n修正1：xxx\n修正1：xxx\n废除1：xxx\n废除1：xxx\n"),
                  ],
                )),
          ),
        ]),
      ),
    );
  }

  Widget makeAppsDataTable() {
    var colorHeader = const Color.fromRGBO(255, 255, 255, 1);
    var colorHeaderBackground = const Color.fromRGBO(75, 175, 255, 1);

    var dataAppProperties = ["序号", "应用名称", "应用标识", "部署状态", "部署版本", "最新版本"];

    _appsTableColumnsCount = dataAppProperties.length;

    List<DataColumn> tableColumnsApps = [];
    for (String app in dataAppProperties) {
      tableColumnsApps.add(
        DataColumn(
          label: Text(
            app,
          ),
        ),
      );
    }

    return Card(
      child: DataTable(
        dividerThickness: 1,
        dataRowHeight: 35,
        showBottomBorder: true,
        headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: colorHeader),
        headingRowColor: MaterialStateProperty.resolveWith((states) => colorHeaderBackground),
        sortColumnIndex: 1,
        sortAscending: true,
        columns: tableColumnsApps,
        onSelectAll: (selected) {},
        rows: makeAppsDataRows(),
      ),
    );
  }

  List<DataRow> makeAppsDataRows() {
    List<DataRow> myResult = [];

    if (_dataApps.isEmpty) {
      List<DataCell> cells = [];

      // +1 for appended column: selected status
      for (var i = 0; i < _appsTableColumnsCount; i++) {
        cells.add(const DataCell(Text('')));
      }

      myResult.add(DataRow(cells: cells));
    } else {
      for (var i = 0; i < _dataApps.length; i++) {
        List<DataCell> cells = [];

        var f = NumberFormat("0000");
        cells.add(DataCell(Text(f.format(i + 1))));
        for (var j = 1; j < _dataApps[i].length - 1; j++) {
          cells.add(DataCell(Text('${_dataApps[i][j]}')));
        }

        myResult.add(DataRow(
          selected: _dataApps[i][_dataApps[i].length - 1],
          onSelectChanged: (value) {
            setState(() {
              if (_rowSelectedLast != -1) {
                _dataApps[_rowSelectedLast][_dataApps[_rowSelectedLast].length - 1] = false;
              }
              _dataApps[i][_dataApps[i].length - 1] = value;
              _rowSelectedLast = i;
            });
          },
          cells: cells,
        ));
      }
    }

    return myResult;
  }

  Widget makeAppView() {
    return Container(
      alignment: Alignment.topLeft,
      decoration: _boxNone,
      margin: const EdgeInsets.fromLTRB(5, 5, 5, 0),
      child: Column(children: [
        Row(
          //扩缩，配置，启动，重启，停止，下线，更新
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Nginx HTTP服务器"),
                Text("nginx"),
                Text("未部署"),
                Text("最新版本：2.0"),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {},
              child: const Text("部署"),
            ),
            const SizedBox(
              width: 5,
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text("启动"),
            ),
            const SizedBox(
              width: 5,
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text("重启"),
            ),
            const SizedBox(
              width: 5,
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text("停止"),
            ),
            const SizedBox(
              width: 5,
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text("更新"),
            ),
            const SizedBox(
              width: 5,
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text("下线"),
            ),
          ],
        ),
        Expanded(
          child: Container(
            alignment: Alignment.bottomLeft,
            decoration: _boxNone,
            margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
            child: makeTabViewApp(),
          ),
        ),
      ]),
    );
  }

  Widget makeKubernetesView() {
    return Container(
      alignment: Alignment.topLeft,
      decoration: _boxNormal,
      child: Column(children: [
        makeBoxDebug("Kubernetes"),
        Expanded(
          child: makeBoxDebug("做一个简化版本的rancher"),
        ),
      ]),
    );
  }

  void onButtonPressedRefresh() {
    getApps();
  }

  void onButtonPressedAddApp() async {
    Map? dialogResult = await showDialogAddApp();

    if (dialogResult != null) {
      if (dialogResult["isConfirmed"]) {
        addApp(dialogResult["values"]["uuid"], dialogResult["values"]["appName"], dialogResult["values"]["appId"], dialogResult["values"]["deployStatus"],
            dialogResult["values"]["deployVersion"], dialogResult["values"]["latestVersion"]);
      } else {
        _logger.d("放弃【新增主机】操作");
      }
    }
  }

  void socketHandler(dynamic data) {
    _logger.d(data);
    // 检测结果捕获
  }

  void socketErrorHandler(error, StackTrace trace) {
    _logger.d("error=$error, trace=${trace.toString()}");

    _socket.close();
    _logger.d("socket error closed");
  }

  void socketDoneHandler() {
    _socket.close();
    _logger.d("socket done closed");
  }

  Future<Map?> showDialogAddApp() {
    return showDialog<Map>(
      context: context,
      builder: (context) {
        return DialogAddApp();
      },
    );
  }

  void getApps() {
    _helper.postExsqlSelect("oncloud_apps", [{}]).then((Map<String, dynamic> result) {
      List newData = [];
      int rowCount = (result["data"] as List).length;

      // appended column: selected status, default is false
      for (var row in result["data"] as List) {
        row.add(false);
      }

      for (int i = 1; i < rowCount; i++) {
        newData.add(result["data"]?[i]);
      }

      setState(() {
        _dataApps = newData;
      });
    });
  }

  void addApp(String uuid, String appName, String appId, String deployStatus, String deployVersion, String latestVersion) {
    //uuid	product_title	product_id	group_title	group_id	artifact_title	artifact_id
    List values = [];
    values.add(uuid);
    values.add(appName);
    values.add(appId);
    values.add(deployStatus);
    values.add(deployVersion);
    values.add(latestVersion);

    _helper.postExsqlInsert("oncloud_apps", values).then((value) {
      values.add(false);
      setState(() {
        _dataApps.add(values);
      });
    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _logger.d('WidgetsBinding.instance.addPostFrameCallback');

      getApps();

      Doraemon.dbSystem.add("add by boco_jars.widget");
    });
  }

  @override
  Widget build(BuildContext context) {
    return makeLayoutMain(context);
  }
}

//ignore: must_be_immutable
class DialogAddApp extends Dialog {
  DialogAddApp({super.key});

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
                                "appName": "Nginx",
                                "appId": "nginx",
                                "deployStatus": "未部署", // 欧拉
                                "deployVersion": "", // 欧拉
                                "latestVersion": "2.0",
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
