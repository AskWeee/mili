import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';

class OnePunchManNotifier extends ChangeNotifier {
  @override
  void notifyListeners() {
    Doraemon.save();
    super.notifyListeners();
  }
}

class Doraemon {
  static List<String> dbSystem = [];

  static Future init() async {
    Logger logger = Logger();
    logger.d("Helper init()");
    WidgetsFlutterBinding.ensureInitialized();
  }

  static save() {
    Logger logger = Logger();
    logger.d("something changed, save!");
  }
}
