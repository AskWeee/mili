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
