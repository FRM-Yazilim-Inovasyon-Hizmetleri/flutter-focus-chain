import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:focus_chain/states/app_state.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:provider/provider.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  @override
  void initState() {
    debugPrint("Expense Screen initState");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppState appState = Provider.of<AppState>(context);
    ExpenseState expenseState = Provider.of<ExpenseState>(context);
    appState.changeScreen(Screens.expense, expenseState);

    return Scaffold(
      body: Container(
        color: Colors.amber.shade400,
        child: Column(
          children: [
            const Text("Expense Screen"),
            CustomInput(
              handler: expenseState,
            ),
            ExampleInput(
              handler: expenseState,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomInput extends StatefulWidget {
  final IScreenFocusStateHandler handler;

  const CustomInput({super.key, required this.handler});

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> implements IFocusableWidget {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: () {
        debugPrint('CustomInput onFocusGained');
        widget.handler.push(this);
      },
      onFocusLost: () {
        debugPrint('CustomInput onFocusLost');
      },
      onForegroundGained: () {
        debugPrint('CustomInput onFocusLost');
      },
      onForegroundLost: () {
        debugPrint('CustomInput onForegroundLost');
      },
      onVisibilityGained: () {
        debugPrint('CustomInput onVisibilityGained');
      },
      onVisibilityLost: () {
        debugPrint('CustomInput onVisibilityLost');
      },
      child: TextField(
        controller: controller,
        autocorrect: false,
        autofocus: false,
        style: const TextStyle(
          color: Colors.amber,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  void handle(LogicalKeyboardKey pressedKey) {
    debugPrint('CustomInput handle method ${pressedKey.debugName}');
    if (pressedKey == LogicalKeyboardKey.escape) {
      widget.handler.pop(context);
    }
  }

  @override
  void focus() {
    debugPrint("Custom Input Statefull focus");
  }
}

class ExampleInput extends StatelessWidget implements IFocusableWidget {
  final IScreenFocusStateHandler handler;
  final TextEditingController controller = TextEditingController();
  ExampleInput({super.key, required this.handler});

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: () {
        debugPrint('ExampleInput onFocusGained');
        handler.push(this);
      },
      onFocusLost: () {
        debugPrint('ExampleInput onFocusLost');
      },
      onForegroundGained: () {
        debugPrint('ExampleInput onFocusLost');
      },
      onForegroundLost: () {
        debugPrint('ExampleInput onForegroundLost');
      },
      onVisibilityGained: () {
        debugPrint('ExampleInput onVisibilityGained');
      },
      onVisibilityLost: () {
        debugPrint('ExampleInput onVisibilityLost');
      },
      child: TextField(
        controller: controller,
        autocorrect: false,
        autofocus: false,
        style: const TextStyle(
          color: Colors.amber,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  void focus() {
    debugPrint("Example Input Stateless focus");
  }

  @override
  void handle(LogicalKeyboardKey pressedKey) {
    debugPrint("Example Input handle ${pressedKey.debugName}");
    if (pressedKey == LogicalKeyboardKey.escape) {
    } else if (pressedKey == LogicalKeyboardKey.enter) {
      handler.next();
    }
  }
}
