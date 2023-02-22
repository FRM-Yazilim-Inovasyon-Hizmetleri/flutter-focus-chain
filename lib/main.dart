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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
              IFocusableWidget? widget =
                  Provider.of<AppState>(context, listen: false)
                      .getScreenWidgetHandler();
              widget?.handle(LogicalKeyboardKey.shift);
            },
          ),
          EscapeIntent: CallbackAction<EscapeIntent>(
            onInvoke: (intent) {
              debugPrint("escape intent");
              IFocusableWidget? widget =
                  Provider.of<AppState>(context, listen: false)
                      .getScreenWidgetHandler();
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
        autofocus: true,
        child: Column(
          children: [
            const Center(child: Text("Home")),
            Expanded(
              flex: 1,
              child: Center(
                child: MaterialButton(
                  onPressed: () => Navigator.pushNamed(context, "income"),
                  child: const Text("Income"),
                  color: Colors.blue,
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
