import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StackStructure<E> {
  StackStructure() : _storage = <E>[];
  final List<E> _storage;

  void push(E element) {
    _storage.add(element);
  }

  int count() {
    return _storage.length;
  }

  E pop() {
    return _storage.removeLast();
  }

  E? peek() {
    return _storage.last;
  }
}

enum Screens { home, income, expense }

class AppState extends ChangeNotifier {
  final Map<Screens, IScreenFocusStateHandler> _screens = {};

  AppState(this._currentScreen);

  Screens _currentScreen;

  void changeScreen(Screens screen, IScreenFocusStateHandler handler) {
    _currentScreen = screen;
    _screens[screen] = handler;
  }

  IFocusableWidget? getScreenWidgetHandler() {
    return _screens[_currentScreen]?.getWidgetHandler();
  }
}

class ExpenseState extends ChangeNotifier implements IScreenFocusStateHandler {
  StackStructure<IFocusableWidget> widgets = StackStructure();

  @override
  IFocusableWidget? getWidgetHandler() {
    print('ExpenseState getWidgetHandler');
    IFocusableWidget? value = widgets.peek();
    return value;
  }

  @override
  IFocusableWidget? pop() {
    print('ExpenseState pop');
    IFocusableWidget value = widgets.pop();
    value.focus();
    return value;
  }

  @override
  void push(IFocusableWidget widget) {
    widgets.push(widget);
    print('ExpenseState push widgets count is ${widgets.count()}');
  }
}

abstract class IScreenFocusStateHandler {
  IFocusableWidget? getWidgetHandler();

  void push(IFocusableWidget widget);
  IFocusableWidget? pop();
}

abstract class IFocusableWidget {
  final IFocusableWidget? prev;
  final IFocusableWidget? next;

  IFocusableWidget(this.prev, this.next);

  void handle(LogicalKeyboardKey pressedKey, BuildContext context);
  void focus();
}
