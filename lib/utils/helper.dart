import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

enum SingingCharacter { lafayette, jefferson }

enum DevopsProductsViewNodeType { unknown, category, product, module, service, component }

abstract class CustomConstants {
  // 定义一个静态常量TextStyle，用于设置字体颜色为黑色，字体大小为20
  static const TextStyle fontColorBlack = TextStyle(
    color: Colors.black,
    fontSize: 20,
  );

  // 定义一个静态常量TextStyle，用于设置字体颜色为白色，字体大小为18
  static const TextStyle fontColorWhite = TextStyle(
    color: Colors.white,
    fontSize: 18,
  );

  // 定义一个静态常量Color，用于设置窗体背景色为蓝色
  static const Color backgroundColorBlue = Colors.blue;

  // 定义一个静态常量Color，用于设置窗体背景色为红色
  static const Color backgroundColorRed = Colors.red;

  static const Color backgroundColor = Color.fromRGBO(0, 122, 204, 1);

  static const Color borderNormalColor = Color.fromRGBO(0, 122, 204, 1);
  static const Color splitterColor = Color.fromRGBO(0, 122, 204, 1);

  static BoxDecoration get boxDebug => BoxDecoration(
        border: Border.all(
          color: Colors.red,
          width: 1,
        ),
      );
  static BoxDecoration get boxNormal => BoxDecoration(
        border: Border.all(
          color: backgroundColor,
          width: 1,
        ),
      );

  static BoxDecoration get boxNone => BoxDecoration(
        border: Border.all(
          color: Colors.transparent,
          width: 1,
        ),
      );

  static const String messageDefault = "系统提示：";

  static const String messageOnCloudAppsRefresh = '''刷新: 提取数据库信息, 注意: 非来自UCMP''';
  static const String messageOnCloudAppsAdd = '''新增：提供 Dockerfile, 构建镜像, 上传到 harbor, 保存好关联信息及必要的配置文件''';
  static const String messageOnCloudAppsModify = '''修改：核心能力是重新构建镜像, 因为修改的原因只能是镜像有问题,需要修改, 触发修改应该是研发驱动, 改了发布包!''';
  static const String messageOnCloudAppsDelete = '''删除：核心是删除镜像, Dockerfile仍保留?显示未构建镜像?''';
  static const String messageOnCloudAppsDeploy = '''部署: 导入必要的配置到UCMP, 弹出UCMP配置界面,配置保存后,按配置完成部署工作. 用户后期仍可调整配置.''';
  static const String messageOnCloudAppsConfig = '''配置: 对于已经部署的应用,提供参数配置页面(新UCMP client), 也包括运行环境参数配置''';
  static const String messageOnCloudAppsStart = '''启动: 启动集群! 指启动pod容器内主进程,一个pod一桶容器的情况下. 部署后pod已经启动,容器进程也已经启动''';
  static const String messageOnCloudAppsRestart = '''重启: 重启集群! 重新启动pod, 或重新启动pod容器内主进程''';
  static const String messageOnCloudAppsStop = '''停止: 停止集群! 指停止pod容器内应用进程''';
  static const String messageOnCloudAppsUpdate = '''更新: 更新集群内版本! master如何更新? 用最新版本的镜像创建部署,并执行服务切换,此工作实际较为复杂,需进一步明确过程''';
  static const String messageOnCloudAppsUndeploy = '''下线: 集群下线! master 也下线? 即不再部署该应用(Pod删除)''';
}

class Helper {
  final Logger _logger = Logger();

  final _headers = {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Credentials": 'true',
    "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
    "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
    'Content-Type': 'application/json',
    'Accept': '*/*'
  };

  Future<List?> testHttpGet() async {
    String url = 'http://10.12.2.211:8087/nexus/service/local/repositories/snapshots/content/?isLocal';
    // Uri uri = Uri(scheme: 'http', host: '10.12.2.211', port: 8087, path: '/nexus/service/local/repositories/snapshots/content/?isLocal');

    var headers = {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": 'true',
      "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      "Access-Control-Allow-Methods": "POST, OPTIONS",
      'Content-Type': 'application/json',
      'Accept': '*/*'
    };
    try {
      http.Response response = await http.get(Uri.parse(url), headers: headers);
      _logger.d(response.body);
      return json.decode(response.body);
    } catch (e) {
      _logger.d(e.toString());
      return null;
    }
  }

  testDirectoryCreate() {
    var dir = Directory("temp01");
    dir.create();
  }

  Future<List> getBocoJars() async {
    String url = 'http://localhost:5055/api/v1/get_boco_jars';

    var headers = {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": 'true',
      "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
      'Content-Type': 'application/json',
      'Accept': '*/*'
    };

    try {
      http.Response response = await http.get(Uri.parse(url), headers: headers);

      var responseBody = json.decode(response.body);

      return responseBody['data'];
    } catch (e) {
      _logger.d(e.toString());

      return [];
    }
  }

  Future<List> postCmd(String cmd, List<String> arguments, String dir) async {
    String url = 'http://localhost:5055/api/v1/run_cmd';

    var headers = {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": 'true',
      "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
      'Content-Type': 'application/json',
      'Accept': '*/*'
    };

    Map body = {"cmd": cmd, "arguments": arguments, "dir": dir};
    String strBody = jsonEncode(body);

    try {
      http.Response response = await http.post(Uri.parse(url), headers: headers, body: strBody);

      var responseBody = json.decode(response.body);

      return responseBody;
    } catch (e) {
      _logger.d(e.toString());

      return [];
    }
  }

  Future<List> getOpenJars() async {
    String url = 'http://localhost:5055/api/v1/get_open_jars';

    var headers = {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": 'true',
      "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
      'Content-Type': 'application/json',
      'Accept': '*/*'
    };

    try {
      http.Response response = await http.get(Uri.parse(url), headers: headers);

      var responseBody = json.decode(response.body);

      return responseBody['data'];
    } catch (e) {
      _logger.d(e.toString());

      return [];
    }
  }

  Future<List> getDatabaseInfo() async {
    String url = 'http://localhost:5055/api/v1/get_database_info';

    var headers = {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": 'true',
      "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
      'Content-Type': 'application/json',
      'Accept': '*/*'
    };

    Map body = {"user": "admin"};
    String strBody = jsonEncode(body);

    try {
      http.Response response = await http.post(Uri.parse(url), headers: headers, body: strBody);

      var responseBody = json.decode(response.body);

      return responseBody;
    } catch (e) {
      _logger.d(e.toString());

      return [
        {
          "data": [e.toString()]
        }
      ];
    }
  }

  Future<List> postExsqlInsert(String table, List<dynamic> values) async {
    String url = 'http://localhost:5055/api/v1/exsql_insert';

    Map body = {"table": table, "values": values};
    String strBody = jsonEncode(body);

    try {
      http.Response response = await http.post(Uri.parse(url), headers: _headers, body: strBody);

      var responseBody = json.decode(response.body);

      return responseBody;
    } catch (e) {
      _logger.d(e.toString());

      return [];
    }
  }

  Future<Map<String, dynamic>> postExsqlSelect(String table, List<dynamic> where) async {
    String url = 'http://localhost:5055/api/v1/exsql_select';

    Map body = {"table": table, "where": where};
    String strBody = jsonEncode(body);

    try {
      http.Response response = await http.post(Uri.parse(url), headers: _headers, body: strBody);

      var responseBody = json.decode(response.body);

      return responseBody;
    } catch (e) {
      _logger.d(e.toString());

      return {"data": []};
    }
  }

  Widget makeBoxDebug(String message) {
    return Container(
      alignment: Alignment.topLeft,
      decoration: CustomConstants.boxDebug,
      padding: const EdgeInsets.all(5),
      child: Text(message),
    );
  }
}
