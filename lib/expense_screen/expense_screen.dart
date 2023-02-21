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
    print("Expense Screen initState");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppState appState = Provider.of<AppState>(context);
    ExpenseState expenseState = Provider.of<ExpenseState>(context);
    appState.changeScreen(Screens.expense, expenseState);

    return Center(
      child: Stack(
        children: [
          const Text("Expense Screen"),
          CustomInput(
            handler: expenseState,
            next: null,
            prev: null,
          ),
          ExampleInput(
            handler: expenseState,
          ),
        ],
      ),
    );
  }
}

class CustomInput extends StatefulWidget {
  final IScreenFocusStateHandler handler;
  @override
  final IFocusableWidget? next;
  @override
  final IFocusableWidget? prev;

  const CustomInput({super.key, required this.handler, this.next, this.prev});

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> implements IFocusableWidget {
  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: () {
        print('CustomInput onFocusGained');
        widget.handler.push(this);
      },
      onFocusLost: () {
        print('CustomInput onFocusLost');
        widget.handler.pop();
      },
      onForegroundGained: () {
        print('CustomInput onFocusLost');
      },
      onForegroundLost: () {
        print('CustomInput onForegroundLost');
      },
      onVisibilityGained: () {
        print('CustomInput onVisibilityGained');
      },
      onVisibilityLost: () {
        print('CustomInput onVisibilityLost');
      },
      child: Container(
        child: Text("Click"),
      ),
    );
  }

  @override
  void handle(LogicalKeyboardKey pressedKey, BuildContext context) {
    print('CustomInput handle method');
    Navigator.pop(this.context);
  }

  @override
  void focus() {
    print("Custom Input focus");
  }

  @override
  IFocusableWidget? get next => widget.next;

  @override
  IFocusableWidget? get prev => widget.prev;
}

class ExampleInput extends StatelessWidget implements IFocusableWidget {
  final IScreenFocusStateHandler handler;
  ExampleInput({super.key, required this.handler});

  late BuildContext _context;
  @override
  Widget build(BuildContext context) {
    _context = context;
    return FocusDetector(
      onFocusGained: () {
        print('ExampleInput onFocusGained');
        handler.push(this);
      },
      onFocusLost: () {
        print('ExampleInput onFocusLost');
        handler.pop();
      },
      onForegroundGained: () {
        print('ExampleInput onFocusLost');
      },
      onForegroundLost: () {
        print('ExampleInput onForegroundLost');
      },
      onVisibilityGained: () {
        print('ExampleInput onVisibilityGained');
      },
      onVisibilityLost: () {
        print('ExampleInput onVisibilityLost');
      },
      child: Container(
        child: Text("ExampleInput Click"),
      ),
    );
  }

  @override
  void focus() {
    print("Example focus");
  }

  @override
  void handle(LogicalKeyboardKey pressedKey, BuildContext context) {
    print("Example Handler");
    Navigator.pop(_context);
  }

  @override
  // TODO: implement next
  IFocusableWidget? get next => throw UnimplementedError();

  @override
  // TODO: implement prev
  IFocusableWidget? get prev => throw UnimplementedError();
}
