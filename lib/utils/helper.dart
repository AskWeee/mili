import 'dart:convert';
import 'dart:io';

import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

enum SingingCharacter { lafayette, jefferson }

enum DevopsProductsViewNodeType { unknown, category, product, module, service, component }

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
}
