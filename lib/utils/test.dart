class TestCharGPT {}


// String temp = '''dart
// import 'package:flutter/material.dart';

// // 创建一个StatefulWidget类
// class CustomDialog extends StatefulWidget {
// // 定义一个构造函数，接收多个widget作为输入参数
// CustomDialog({Key? key, required this.widgets}) : super(key: key);

// // 定义一个列表属性，存储输入参数
// final List<Widget> widgets;

// // 重写createState方法，返回一个State对象
// @override
// _CustomDialogState createState() => _CustomDialogState();
// }

// // 创建一个State对象
// class _CustomDialogState extends State<CustomDialog> {
// // 重写build方法，返回一个Widget对象
// @override
// Widget build(BuildContext context) {
// // 使用AlertDialog类创建一个基于dialog的布局
// return AlertDialog(
// // 使用Column类组合多个widget，并作为content参数传递给AlertDialog类
// content: Column(
// mainAxisSize: MainAxisSize.min,
// children: widget.widgets,
// ),
// );
// }
// }

// // 在主函数中调用showDialog函数，并传递CustomDialog类作为child参数
// void main() {
// runApp(MaterialApp(
// home: Scaffold(
// body: Center(
// child: ElevatedButton(
// onPressed: () {
// showDialog(
// context: context,
// builder: (context) => CustomDialog(
// // 创建多个widget作为输入参数
// widgets: [
// Text('Hello'),
// Text('World'),
// Icon(Icons.star),
// ],
// ),
// );
// },
// child: Text('Show Custom Dialog'),
// ),
// ),
// ),
// ));
// }
// '''

// - 希望这些文本对您有帮助。如果您有任何其他问题或建议，请随时与我联系。😊
// - 为了创建一个使用flutter编写的基于dialog的自定义dialog，您需要以下步骤：
//   - 首先，您需要创建一个StatefulWidget类，这个类将包含您的自定义dialog的逻辑和界面。
//   - 然后，您需要在这个类中重写createState方法，返回一个State对象，这个对象将管理您的自定义dialog的状态。
//   - 接着，您需要在这个State对象中重写build方法，返回一个Widget对象，这个对象将是您的自定义dialog的主体。
//   - 在这个Widget对象中，您可以使用Dialog类或AlertDialog类来创建一个基于dialog的布局，这些类都有一个content参数，可以接收一个Widget对象作为自定义dialog的显示内容。
//   - 您可以使用Column类或Row类来组合多个Widget对象，并将它们作为content参数传递给Dialog类或AlertDialog类，以便支持自定义dialog的显示内容。
//   - 最后，您需要在您想要显示自定义dialog的地方调用showDialog函数，并将您创建的StatefulWidget类作为child参数传递给它，这样就可以弹出您的自定义dialog了。
// - 下面是一个使用flutter编写的基于dialog的自定义dialog的示例代码：

