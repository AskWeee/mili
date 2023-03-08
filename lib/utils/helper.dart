import 'dart:convert';
import 'dart:io';

import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

class Helper {
  var logger = Logger();

  // 测试：
  // final Helper _helper = Helper();
  // _helper.testDirectoryCreate();
  // _helper.testHttpGet().then((value) {
  //   logger.d(value);
  // });

  Future<List?> testHttpGet() async {
    String url =
        'http://10.12.2.211:8087/nexus/service/local/repositories/snapshots/content/?isLocal';
    // Uri uri = Uri(scheme: 'http', host: '10.12.2.211', port: 8087, path: '/nexus/service/local/repositories/snapshots/content/?isLocal');

    var headers = {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": 'true',
      "Access-Control-Allow-Headers":
          "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      "Access-Control-Allow-Methods": "POST, OPTIONS",
      'Content-Type': 'application/json',
      'Accept': '*/*'
    };
    try {
      http.Response response = await http.get(Uri.parse(url), headers: headers);
      logger.d(response.body);
      return json.decode(response.body);
    } catch (e) {
      logger.d(e.toString());
      return null;
    }
  }

  testDirectoryCreate() {
    var dir = Directory("temp01");
    dir.create();
  }
}
