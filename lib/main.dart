import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:focus_chain/expense_screen/expense_screen.dart';
import 'package:focus_chain/income_screen/income_screen.dart';
import 'package:focus_chain/states/app_state.dart';
import 'package:focus_chain/states/catalog_state.dart';
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
      },
      child: Actions(
        actions: {
          ShiftIntent: CallbackAction<ShiftIntent>(
            onInvoke: (intent) {
              print("invoke");
              IFocusableWidget? widget =
                  Provider.of<AppState>(context, listen: false)
                      .getScreenWidgetHandler();
              widget?.handle(LogicalKeyboardKey.shift, context);
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

class OrderedButtonRow extends StatelessWidget {
  const OrderedButtonRow({super.key});

  @override
  Widget build(BuildContext context) {
    return FocusTraversalGroup(
      policy: OrderedTraversalPolicy(),
      child: Row(
        children: <Widget>[
          const Spacer(),
          FocusTraversalOrder(
            order: const NumericFocusOrder(2.0),
            child: TextButton(
              child: const Text('ONE'),
              onPressed: () {},
            ),
          ),
          const Spacer(),
          FocusTraversalOrder(
            order: const NumericFocusOrder(1.0),
            child: TextButton(
              child: const Text('TWO'),
              onPressed: () {},
            ),
          ),
          const Spacer(),
          FocusTraversalOrder(
            order: const NumericFocusOrder(3.0),
            child: TextButton(
              child: const Text('THREE'),
              onPressed: () {},
            ),
          ),
          const Spacer(),
        ],
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
