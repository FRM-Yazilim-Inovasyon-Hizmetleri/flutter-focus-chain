import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:focus_chain/expense_screen/expense_screen.dart';
import 'package:focus_chain/income_screen/income_screen.dart';
import 'package:focus_chain/states/app_state.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AppState>(
          create: (context) => AppState(Screens.home),
        ),
        ChangeNotifierProvider(
          create: (context) => ExpenseState(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    FocusManager.instance.addListener(() {
      FocusManager.instance.primaryFocus?.context?.widget.key;
    });
  }

  @override
  Widget build(BuildContext context) {
    AppState state = Provider.of<AppState>(context, listen: false);
    state.addNavigationListener(() {
      debugPrint('Shift Intent Navigation Listener');
      Navigator.pop(context);
      //FocusScope.of(context).previousFocus();
    });
    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.shift): ShiftIntent(),
        LogicalKeySet(LogicalKeyboardKey.escape): EscapeIntent(),
      },
      child: Actions(
        actions: {
          ShiftIntent: CallbackAction<ShiftIntent>(
            onInvoke: (intent) {
              debugPrint("invoke");
              AppState state = Provider.of<AppState>(context, listen: false);

              IFocusableWidget? widget = state.getScreenWidgetHandler();
              widget?.handle(LogicalKeyboardKey.shift);
            },
          ),
          EscapeIntent: CallbackAction<EscapeIntent>(
            onInvoke: (intent) {
              debugPrint("escape intent");
              AppState state = Provider.of<AppState>(context, listen: false);
              IFocusableWidget? widget = state.getScreenWidgetHandler();
              widget?.handle(LogicalKeyboardKey.escape);
            },
          ),
        },
        child: MaterialApp(
          routes: {
            "income": (context) => const IncomeScreen(),
            "expense": (context) => const ExpenseScreen()
          },
          debugShowCheckedModeBanner: false,
          title: 'Focus App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const Home(),
        ),
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Focus(
        key: Key("FOCUS"),
        autofocus: true,
        child: Column(
          key: Key("COLUMN"),
          children: [
            const Center(child: Text("Home")),
            Expanded(
              key: Key("EXPANDED"),
              flex: 1,
              child: Center(
                key: Key("CENTER"),
                child: GestureDetector(
                  key: UniqueKey(),
                  child: EditableText(
                    key: GlobalKey(debugLabel: "EXITTEXT"),
                    focusNode: FocusNode(debugLabel: "TEXTFIELD_FOCUS_NODE"),
                    backgroundCursorColor: Colors.black,
                    controller: TextEditingController(),
                    cursorColor: Colors.black,
                    style: TextStyle(),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(80.0),
                  child: MaterialButton(
                    onPressed: () => Navigator.pushNamed(context, "expense"),
                    child: const Text("Expense"),
                    color: Colors.amber,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ShiftIntent extends Intent {}

class EscapeIntent extends Intent {}
