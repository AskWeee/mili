import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mili/utils/doraemon.dart';
import 'package:mili/utils/helper.dart';
import 'package:intl/intl.dart';

/// FUNC01：

class OnCloudKubernetes extends StatefulWidget {
  const OnCloudKubernetes({super.key});

  @override
  State<OnCloudKubernetes> createState() => _OnCloudKubernetesState();
}

class _OnCloudKubernetesState extends State<OnCloudKubernetes> {
  final _logger = Logger();
  final _helper = Helper();

  List _listHosts = [];
  List<DataColumn> _hostTableColumns = [];
  int _rowSelectedLast = -1;

  bool isChanging = false;

  late WebSocket _socket;

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
                        child: getWidgetHostTabView(),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 500,
                        child: Column(children: [
                          Expanded(
                            child: DefaultTabController(
                              length: 4,
                              child: Column(children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    alignment: Alignment.topLeft,
                                    margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                    decoration: BoxDecoration(border: Border.all(color: _colorBorderBoxRoot, width: 1)),
                                    child: TabBarView(
                                      children: [
                                        getWidgetHostInfoView(),
                                        getWidgetHostSpecialView(),
                                        getWidgetHostProcessesView(),
                                        getWidgetHostDiskView(),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.topLeft,
                                  margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: const SizedBox(
                                    width: 400,
                                    child: Card(
                                      child: TabBar(
                                        labelColor: Color.fromRGBO(0, 0, 0, 1),
                                        tabs: [
                                          Tab(
                                            text: '基本信息',
                                          ),
                                          Tab(
                                            text: '专项信息',
                                          ),
                                          Tab(
                                            text: '进程列表',
                                          ),
                                          Tab(
                                            text: '磁盘空间',
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
            onPressed: onButtonPressedAddHost,
            child: const Text(
              '新增主机',
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              onPressedButtonTestHost();
            },
            child: const Text(
              '检测',
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          ElevatedButton(
            onPressed: () {
              onPressedButtonInitHost();
            },
            child: const Text(
              '初始化',
            ),
          ),
        ],
      ),
    );
  }

  Container getWidgetHostsDataTable() {
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
            child: makeHostsDataTable(),
          ),
        ),
      ),
    );
  }

  Container getWidgetHostTabView() {
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
                    getWidgetHostsDataTable(),
                    getWidgetHostsTopoView(),
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
                      text: '拓扑视图',
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

  Container getWidgetHostsTopoView() {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.all(10),
      color: _colorBackgroundTabBarView,
      child: Container(alignment: Alignment.topLeft, child: const Text("主机流量拓扑")),
    );
  }

  Container getWidgetHostInfoView() {
    return Container(
      color: _colorBackgroundTabBarView,
      child: Column(children: [
        Expanded(
          child: Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("CPU\n内存\n名称\n版本\n用户列表"),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Container getWidgetHostSpecialView() {
    return Container(
      color: _colorBackgroundTabBarView,
      child: Column(children: [
        Expanded(
          child: Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("!!! 追加详情信息，如看源主机的包列表，Harbor主机的镜像列表等专项页面"),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Container getWidgetHostProcessesView() {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.all(10),
      color: _colorBackgroundTabBarView,
      child: Container(
        alignment: Alignment.topLeft,
        color: const Color.fromRGBO(25, 75, 125, 1),
        child: const Card(child: Text("进程总数：")),
      ),
    );
  }

  Container getWidgetHostDiskView() {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.all(10),
      color: _colorBackgroundTabBarView,
      child: Container(
        color: const Color.fromRGBO(25, 75, 125, 1),
        child: Container(
          alignment: Alignment.topLeft,
          child: const Text("/var\n/opt"),
        ),
      ),
    );
  }

  Widget makeHostsDataTable() {
    var colorHeader = const Color.fromRGBO(255, 255, 255, 1);
    var colorHeaderBackground = const Color.fromRGBO(75, 175, 255, 1);

    _hostTableColumns = [];
    _hostTableColumns.add(
      const DataColumn(
        label: Text(
          '序号',
        ),
      ),
    );
    _hostTableColumns.add(
      const DataColumn(
          label: Text(
            '主机名称',
          ),
          tooltip: '中文名称'),
    );
    _hostTableColumns.add(
      const DataColumn(
          label: Text(
            '主机标识',
          ),
          tooltip: '英文名称'),
    );
    _hostTableColumns.add(
      const DataColumn(
          label: Text(
            '操作系统',
          ),
          tooltip: '操作系统'),
    );
    _hostTableColumns.add(
      const DataColumn(
          label: Text(
            '系统版本',
          ),
          tooltip: '英文版本'),
    );
    _hostTableColumns.add(
      const DataColumn(
        label: Text(
          'IP地址 - IPV4',
        ),
      ),
    );
    _hostTableColumns.add(
      const DataColumn(
        label: Text(
          'IP地址 - IPV6',
        ),
      ),
    );
    _hostTableColumns.add(
      const DataColumn(
        label: Text(
          '登录用户',
        ),
      ),
    );
    _hostTableColumns.add(
      const DataColumn(
        label: Text(
          '用户口令',
        ),
      ),
    );
    _hostTableColumns.add(
      const DataColumn(
        label: Text(
          '用途',
        ),
      ),
    );
    _hostTableColumns.add(
      const DataColumn(
        label: Text(
          '状态',
        ),
      ),
    );
    _hostTableColumns.add(
      const DataColumn(
        label: Text(
          '备注',
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
            columns: _hostTableColumns,
            onSelectAll: (selected) {},
            rows: makeHostsDataRowList()));
  }

  void onButtonPressedRefresh() {
    getHosts();
  }

  void onPressedButtonTestHost() {
    doTestHost();
  }

  void onPressedButtonInitHost() {
    doInitHost();
  }

  void doTestHost() async {
    try {
      _socket = await WebSocket.connect("ws://127.0.0.1:5055/ws");
      _socket.listen(socketHandler, onError: socketErrorHandler, onDone: socketDoneHandler, cancelOnError: false);

      // 检测内容（拉清单，逐一检测验证，打钩或打叉
      // 根据用途
      // YUM源：1. 操作系统版本，yum源当前的设置
      /*
      修改 yum 配置文件：/etc/yum.conf
      cachedir=/var/cache/yum/$basearch/$releasever
      keepchche=1


      kubectl exec anolisosapp -- yum repolist --all|enabled|disabled
      kubectl exec anolisosapp -- ls /etc/yum.repos.d
      kubectl exec anolisosapp -- yum --enablerepo [repo]
      kubectl exec anolisosapp -- yum --disablerepo [repo]
      --downloadonly --destdir DESTDIR, --downloaddir DESTDIR
      kubectl exec anolisosapp -- yum list installed / available
      将外部文件复制到容器内？
      kubectl exec anolisosapp -- yum -y update 慎用
      kubectl exec anolisosapp -- yum clean all
      kubectl exec anolisosapp -- yum makecache
      kubectl exec anolisosapp -- rpm -qa
      kubectl exec anolisosapp -- systemctl start docker
      kubectl exec anolisosapp -- yum install / remove / info softwarename

      */

      _socket.add(jsonEncode({
        "action": "runCmd",
        "params": {
          "cmd": 'kubectl',
          "arguments": ['exec', 'anolisosapp', '--', 'cat', '/etc/redhat-release'],
        }
      }));
    } catch (error) {
      _logger.d(error.toString());
    }
  }

  void doInitHost() async {
    try {
      _socket = await WebSocket.connect("ws://127.0.0.1:5055/ws");
      _socket.listen(socketHandler, onError: socketErrorHandler, onDone: socketDoneHandler, cancelOnError: false);

      // 初始化内容（拉清单，逐一执行证，成功打钩或失败打叉
      // 根据用途
      // 创建用户，切换用户，配置环境变量 1. 修改YUM源 2. 更新系统 3. 安装特定软件包 4.执行验证命令

      _socket.add(jsonEncode({
        "action": "runCmd",
        "params": {
          "cmd": 'kubectl',
          "arguments": ['exec', 'anolisosapp', '--', 'cat', '/etc/redhat-release'],
        }
      }));
    } catch (error) {
      _logger.d(error.toString());
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

  void onButtonPressedAddHost() async {
    Map? dialogResult = await showDialogAddHost();

    if (dialogResult != null) {
      if (dialogResult["isConfirmed"]) {
        addHost(
            dialogResult["values"]["uuid"],
            dialogResult["values"]["hostTitle"],
            dialogResult["values"]["hostName"],
            dialogResult["values"]["os"],
            dialogResult["values"]["osVersion"],
            dialogResult["values"]["ipv4"],
            dialogResult["values"]["ipv6"],
            dialogResult["values"]["username"],
            dialogResult["values"]["password"],
            dialogResult["values"]["function"],
            dialogResult["values"]["status"],
            dialogResult["values"]["memo"]);
      } else {
        _logger.d("放弃【新增主机】操作");
      }
    }
  }

  Future<Map?> showDialogAddHost() {
    return showDialog<Map>(
      context: context,
      builder: (context) {
        return DialogAddHost();
      },
    );
  }

  List<DataRow> makeHostsDataRowList() {
    List<DataRow> myResult = [];

    if (_listHosts.isEmpty) {
      List<DataCell> cells = [];

      for (var i = 0; i < _hostTableColumns.length; i++) {
        cells.add(const DataCell(Text('')));
      }

      myResult.add(DataRow(cells: cells));
    } else {
      for (var i = 0; i < _listHosts.length; i++) {
        List<DataCell> cells = [];

        var f = NumberFormat("0000");
        cells.add(DataCell(Text(f.format(i + 1))));
        for (var j = 1; j < _listHosts[i].length - 1; j++) {
          cells.add(DataCell(Text('${_listHosts[i][j]}')));
        }

        myResult.add(DataRow(
          selected: _listHosts[i][_listHosts[i].length - 1],
          onSelectChanged: (value) {
            setState(() {
              if (_rowSelectedLast != -1) {
                _listHosts[_rowSelectedLast][_listHosts[_rowSelectedLast].length - 1] = false;
              }
              _listHosts[i][_listHosts[i].length - 1] = value;
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

  Size getRedBoxSize(BuildContext context) {
    final box = context.findRenderObject() as RenderBox;
    return box.size;
  }

  void getHosts() {
    _helper.postExsqlSelect("oncloud_hosts", [{}]).then((Map<String, dynamic> result) {
      List newlistHosts = [];
      int rowCount = (result["data"] as List).length;

      for (var row in result["data"] as List) {
        row.add(false);
      }

      for (int i = 1; i < rowCount; i++) {
        newlistHosts.add(result["data"]?[i]);
      }

      setState(() {
        _listHosts = newlistHosts;
      });
    });
  }

  void addHost(String uuid, String hostTitle, String hostName, String os, String osVersion, String ipv4, String ipv6, String username, String password, String function,
      String status, String memo) {
    //uuid	product_title	product_id	group_title	group_id	artifact_title	artifact_id
    List values = [];
    values.add(uuid);
    values.add(hostTitle);
    values.add(hostName);
    values.add(os);
    values.add(osVersion);
    values.add(ipv4);
    values.add(ipv6);
    values.add(username);
    values.add(password);
    values.add(function);
    values.add(status);
    values.add(memo);

    _helper.postExsqlInsert("oncloud_hosts", values).then((value) {
      values.add(false);
      setState(() {
        _listHosts.add(values);
      });
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _logger.d('WidgetsBinding.instance.addPostFrameCallback');

      getHosts();

      Doraemon.dbSystem.add("add by boco_jars.widget");
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return getWidgetLayoutMain();
  }
}

//ignore: must_be_immutable
class DialogAddHost extends Dialog {
  DialogAddHost({super.key});

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
                                "hostTitle": "本机",
                                "hostName": "localhost",
                                "os": "龙蜥", // 欧拉
                                "osVersion": "Anolis OS release 8.6", // 欧拉
                                "ipv4": "127.0.0.1",
                                "ipv6": "1002:003B:456C:678D:890E:0012:234F:56G7",
                                "username": "admin",
                                "password": "admin",
                                "function": "Yum源主机", // K8s主节点，K8sWork节点，包管理主机
                                "status": "未初始化", // 可用（满足功能要求，但没有投入生产） 不可用（不满足功能要求） 活动（已投入生产）异常（已投入生产）
                                "memo": "备注信息"
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
