import 'dart:io';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mili/utils/doraemon.dart';
import 'package:mili/utils/helper.dart';
import 'package:intl/intl.dart';
import 'package:mili/utils/events.dart';

import 'feking_dialog.dart';

/// FUNC01：呈现云环境中应用的实际部署情况
/// FUNC02：呈现可用的应用列表【👌🏻】
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

  final ScrollController scrollControllerTable = ScrollController();
  final ScrollController scrollControllerDataTable = ScrollController();

  Slider mySlider = Slider(
      value: 1,
      onChanged: (value) {
        final logger = Logger();
        logger.d(value);
      });

  Widget makeLayoutMain(BuildContext context) {
    return LayoutBuilder(builder: (context, BoxConstraints constraints) {
      if (_maxWidth == 0) {
        _maxWidth = constraints.maxWidth - _splitterWidth;
      }

      return Container(
        alignment: Alignment.topLeft,
        decoration: CustomConstants.boxNormal,
        child: Row(children: [
          Container(
            alignment: Alignment.topLeft,
            decoration: CustomConstants.boxNormal,
            width: _maxWidth * _ratio,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  decoration: CustomConstants.boxNormal,
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
                      onHover: (value) {
                        showHelpMessage(value, CustomConstants.messageOnCloudAppsRefresh);
                      },
                      onPressed: onButtonPressedRefresh,
                      child: const Text("刷新"),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    ElevatedButton(
                      onHover: (value) {
                        showHelpMessage(value, CustomConstants.messageOnCloudAppsAdd);
                      },
                      onPressed: onButtonPressedAddApp,
                      child: const Text("新增"),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    ElevatedButton(
                      onHover: (value) {
                        showHelpMessage(value, CustomConstants.messageOnCloudAppsModify);
                      },
                      onPressed: () {},
                      child: const Text("修改"),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    ElevatedButton(
                      onHover: (value) {
                        showHelpMessage(value, CustomConstants.messageOnCloudAppsDelete);
                      },
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
              color: CustomConstants.splitterColor,
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
              decoration: CustomConstants.boxNormal,
              child: makeTabViewMain(),
            ),
          ),
        ]),
      );
    });
  }

  void showHelpMessage(bool isMouseOver, String message) {
    eventBus.fire(
      MessageEvent(isMouseOver ? message : CustomConstants.messageDefault),
    );
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
                decoration: CustomConstants.boxNormal,
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
              decoration: CustomConstants.boxNormal,
              child: TabBarView(
                children: [
                  _helper.makeBoxDebug('''简要说明:
情况1: 未部署，无运行实例
情况2: 已部署, 但集群未启动,此时显示各个实例,可以在这里配置实例参数
情况2: 已部署, 已启动, 此时显示各个实例, 可以单独停止, 重启, 启动, 当不可以更新(更新必须整体更新),也可以配置实例参数,修改参数后如果没有点击重启,并退出界面,更改的参数将失效(会有提示)
'''),
                  _helper.makeBoxDebug('''简要说明:
提供选项: 选择应用控制器, 无论部署与否, 都有这个选项!
最好自动关联, 在新增应用的是否, 要求指定相应的应用控制器. 没有构建则需要构建.
如果没有关联, 则在此选择!

情况1: 未部署，无运行实例
情况2: 已部署, 但集群未启动,此时显示各个实例,可以在这里配置实例参数
情况2: 已部署, 已启动, 此时显示各个实例, 可以单独停止, 重启, 启动, 当不可以更新(更新必须整体更新),也可以配置实例参数,修改参数后如果没有点击重启,并退出界面,更改的参数将失效(会有提示)
'''),
                  _helper.makeBoxDebug('''简要说明:
配置应用模板参数
如果已经启动,也可以修改,但必须通过应用来保存,否则修改无效(目的是保证运行参数和保存的参数一致)

'''),
                  _helper.makeBoxDebug('''简要说明:
支持md格式文件, 默认为 ReleaseNotes.md

'''),
                ],
              ),
            ),
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
      decoration: CustomConstants.boxNone,
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
              onHover: (value) {
                showHelpMessage(value, CustomConstants.messageOnCloudAppsDeploy);
              },
              onPressed: onButtonPressedDeployApp,
              child: const Text("部署"),
            ),
            // const SizedBox(
            //   width: 5,
            // ),
            // ElevatedButton(
            //   onHover: (value) {
            //     showHelpMessage(value, CustomConstants.messageOnCloudAppsConfig);
            //   },
            //   onPressed: onButtonPressedConfigApp,
            //   child: const Text("配置"),
            // ),
            const SizedBox(
              width: 5,
            ),
            ElevatedButton(
              onHover: (value) {
                showHelpMessage(value, CustomConstants.messageOnCloudAppsStart);
              },
              onPressed: () {},
              child: const Text("启动"),
            ),
            const SizedBox(
              width: 5,
            ),
            ElevatedButton(
              onHover: (value) {
                showHelpMessage(value, CustomConstants.messageOnCloudAppsRestart);
              },
              onPressed: () {},
              child: const Text("重启"),
            ),
            const SizedBox(
              width: 5,
            ),
            ElevatedButton(
              onHover: (value) {
                showHelpMessage(value, CustomConstants.messageOnCloudAppsStop);
              },
              onPressed: () {},
              child: const Text("停止"),
            ),
            const SizedBox(
              width: 5,
            ),
            ElevatedButton(
              onHover: (value) {
                showHelpMessage(value, CustomConstants.messageOnCloudAppsUpdate);
              },
              onPressed: () {},
              child: const Text("更新"),
            ),
            const SizedBox(
              width: 5,
            ),
            ElevatedButton(
              onHover: (value) {
                showHelpMessage(value, CustomConstants.messageOnCloudAppsUndeploy);
              },
              onPressed: () {},
              child: const Text("下线"),
            ),
          ],
        ),
        Expanded(
          child: Container(
            alignment: Alignment.bottomLeft,
            decoration: CustomConstants.boxNone,
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
      decoration: CustomConstants.boxNormal,
      child: Column(children: [
        _helper.makeBoxDebug("Kubernetes"),
        Expanded(
          child: _helper.makeBoxDebug("做一个简化版本的rancher"),
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
        _logger.d(dialogResult["values"]);
      }
    }
  }

  void onButtonPressedDeployApp() async {
    Map? dialogResult = await showDialogDeployApp();

    if (dialogResult != null) {
      if (dialogResult["isConfirmed"]) {
        _logger.d(dialogResult["values"]);
      }
    }
  }

  void onButtonPressedConfigApp() async {
    Map? dialogResult = await showDialogConfigApp();

    if (dialogResult != null) {
      if (dialogResult["isConfirmed"]) {
        _logger.d(dialogResult["values"]);
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
        return FekingDialog(
          title: "新增应用",
          height: 900,
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.topLeft,
                decoration: CustomConstants.boxNone,
                child: Expanded(
                  child: Column(children: [
                    Row(children: [
                      const Text("Dockerfile:"),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('选择'),
                      ),
                    ]),
                    const SizedBox(
                      height: 5,
                    ),
                    const TextField(),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(children: [
                      const Text("Dockerfile 详情:"),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('构建'),
                      ),
                    ]),
                    const SizedBox(
                      height: 5,
                    ),
                    const TextField(
                      maxLines: 10,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(children: [
                      const Text("Harbor镜像列表:"),
                      const Expanded(
                        child: TextField(),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('搜索'),
                      ),
                    ]),
                    const SizedBox(
                      height: 5,
                    ),
                    Expanded(
                      child: _helper.makeBoxDebug("此处放一个DataTable, 显示镜像列表"),
                    ),
                  ]),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<Map?> showDialogDeployApp() {
    return showDialog<Map>(
      context: context,
      builder: (context) {
        return FekingDialog(
          title: "部署应用",
          height: 900,
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.topLeft,
                decoration: CustomConstants.boxNone,
                child: Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        const Text("请选择镜像文件:"),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: DropdownButton(
                              isExpanded: true,
                              value: '',
                              items: const [
                                DropdownMenuItem(
                                  value: '',
                                  child: Text('最新版本: nginx-3.01'),
                                ),
                                DropdownMenuItem(
                                  value: '1',
                                  child: Text('nginx-2.9'),
                                ),
                                DropdownMenuItem(
                                  value: '2',
                                  child: Text('nginx-2.8'),
                                )
                              ],
                              onChanged: (value) {
                                setState(() {
                                  // companyProductIdSelected = value!;
                                });
                              }),
                        ),
                      ]),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text("版本说明:"),
                      const SizedBox(
                        height: 5,
                      ),
                      const TextField(maxLines: 3),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text("副本数量(部署pod的参数):"),
                      const SizedBox(
                        height: 5,
                      ),
                      const TextField(),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text("CPU(其他部署pod的参数):"),
                      const SizedBox(
                        height: 5,
                      ),
                      const TextField(),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          const Text("请选应用控制器(master)版本镜像:"),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: DropdownButton(
                                isExpanded: true,
                                value: '',
                                items: const [
                                  DropdownMenuItem(
                                    value: '',
                                    child: Text('最新版本:nginx-master-1.0'),
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    // companyProductIdSelected = value!;
                                  });
                                }),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text("版本说明:"),
                      const SizedBox(
                        height: 5,
                      ),
                      const TextField(maxLines: 5),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text("副本数量(部署pod的参数):"),
                      const SizedBox(
                        height: 5,
                      ),
                      const TextField(),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text("CPU(其他部署pod的参数):"),
                      const SizedBox(
                        height: 5,
                      ),
                      const TextField(),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          const Text("请选运行环境:"),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: DropdownButton(
                                isExpanded: true,
                                value: '',
                                items: const [
                                  DropdownMenuItem(
                                    value: '',
                                    child: Text('K8s测试环境A'),
                                  ),
                                  DropdownMenuItem(
                                    value: '1',
                                    child: Text('K8s测试环境B'),
                                  ),
                                  DropdownMenuItem(
                                    value: '2',
                                    child: Text('K8s生产环境'),
                                  )
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    // companyProductIdSelected = value!;
                                  });
                                }),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Expanded(
                        child: _helper.makeBoxDebug("保存按钮应改为:部署. 部署后知识创建POD及mastpod,应用并不启动,包括master,因为参数还没有配置."),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<Map?> showDialogConfigApp() {
    return showDialog<Map>(
      context: context,
      builder: (context) {
        return FekingDialog(
          title: "配置应用(UCMP新界面)",
          width: 1200,
          height: 900,
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.topLeft,
                decoration: CustomConstants.boxNone,
                child: Expanded(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 300,
                        child: _helper.makeBoxDebug('tree'),
                      ),
                      Expanded(
                        child: _helper.makeBoxDebug('detail'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
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
