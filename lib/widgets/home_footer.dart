import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mili/utils/events.dart';

import '../utils/helper.dart';

class HomeFooter extends StatefulWidget {
  const HomeFooter({super.key});

  @override
  State<HomeFooter> createState() => _HomeFooterState();
}

class _HomeFooterState extends State<HomeFooter> {
  var logger = Logger();

  String _message = CustomConstants.messageDefault;
  // 定义一个订阅对象
  late StreamSubscription subscription;

  Widget _makeLayoutMain() {
    return Container(
        alignment: Alignment.topLeft,
        color: CustomConstants.backgroundColor,
        child: Row(
          children: <Widget>[
            const SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.topLeft,
                color: CustomConstants.backgroundColor,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.topLeft,
                        margin: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                        child: Text(
                          _message,
                          style: const TextStyle(color: Colors.white),
                          maxLines: _message.split("\n").length,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ));
  }

  @override
  void initState() {
    super.initState();
    // 订阅MessageEvent事件
    subscription = eventBus.on<MessageEvent>().listen((event) {
      // 收到事件后更新状态
      switch (event.runtimeType) {
        case MessageEvent:
          setState(() {
            _message = event.message;
          });
          break;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    // 取消订阅
    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return _makeLayoutMain();
  }
}
