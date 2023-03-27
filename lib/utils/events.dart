import 'package:event_bus/event_bus.dart';

EventBus eventBus = EventBus();

/// Event A.
class EventOnNavigatorChanged {
  String navigator;

  EventOnNavigatorChanged(this.navigator);
}

/// Event B.
class MyEventB {
  String text;

  MyEventB(this.text);
}

// 定义一个事件类，用于传递消息
class MessageEvent {
  final String message;
  MessageEvent(this.message);
}
