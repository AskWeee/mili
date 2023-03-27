import 'package:flutter/material.dart';

class FekingDialog extends Dialog {
  final String title;
  final List<Widget> children;
  final double width;
  final double height;

  const FekingDialog({super.key, required this.title, required this.children, this.width = 800, this.height = 600});

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
              width: width,
              height: height,
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: children,
                          ),
                        ),
                      ),
                      Row(children: [
                        const Spacer(),
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
