import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../utils/helper.dart';

class DevopsCampboot extends StatefulWidget {
  const DevopsCampboot({super.key});

  @override
  State<DevopsCampboot> createState() => _DevopsCampbootState();
}

List<String> _list = <String>['One', 'Two', 'Three', 'Four'];

class _DevopsCampbootState extends State<DevopsCampboot> {
  var logger = Logger();
  final Helper _helper = Helper();
  final _colorMainBackground = const Color.fromRGBO(49, 49, 49, 1);

  void _onPressed() {
    _helper.testDirectoryCreate();
  }

  void _onPressedA() {
    _helper.testDirectoryCreate();
  }

  void _onPressedB() {
    _helper.testHttpGet().then((value) {
      logger.d(value);
    });
  }

  String dropdownValue = _list.first;
  // dynamic productA = const DropdownMenuItem(
  //   value: "product_alarms",
  //   child: Text("智能监控"),
  // );
  // dynamic productB = const DropdownMenuItem(
  //   value: "product_camp",
  //   child: Text("云原生应用平台"),
  // );
  // List<dynamic> products = [productA];

  Stack _layoutMain(BuildContext context) {
    return Stack(children: <Widget>[
      Container(
        alignment: Alignment.topLeft,
        color: _colorMainBackground,
      ),
      Container(
        alignment: Alignment.topLeft,
        child: Wrap(direction: Axis.vertical, children: [
          const Text(
            "开发平台 > 工程管理",
            style: TextStyle(
              color: Color.fromRGBO(255, 255, 255, 1),
              fontSize: 16,
              decoration: TextDecoration.none,
            ),
          ),
          Wrap(
            spacing: 5,
            children: [
              const SizedBox(
                width: 0,
              ),
              Card(
                child: DropdownButton<String>(
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      dropdownValue = value!;
                    });
                  },
                  items: _list.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              Card(
                  child: IconButton(
                onPressed: _onPressed,
                icon: const Icon(Icons.volume_up),
              )),
              ElevatedButton(
                onPressed: _onPressed,
                child: const Text('添加产品'),
              ),
              ElevatedButton(
                onPressed: _onPressed,
                child: const Text('添加模块'),
              ),
              ElevatedButton(
                onPressed: _onPressed,
                child: const Text('添加制品'),
              ),
            ],
          ),
        ]),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return _layoutMain(context);
  }
}
