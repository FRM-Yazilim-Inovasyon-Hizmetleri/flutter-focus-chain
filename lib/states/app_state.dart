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

  E? pop() {
    if (_storage.isNotEmpty) {
      return _storage.removeLast();
    }

    return null;
  }

  E? peek() {
    if (_storage.isNotEmpty) {
      return _storage.last;
    }
    return null;
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
    debugPrint('ExpenseState getWidgetHandler');
    IFocusableWidget? value = widgets.peek();
    return value;
  }

  @override
  IFocusableWidget? pop(BuildContext context) {
    debugPrint('ExpenseState pop');
    IFocusableWidget? value = widgets.pop();
    IFocusableWidget? current = widgets.peek();
    current?.focus();
    if (current == null) {
      Navigator.pop(context);
    }

    return value;
  }

  @override
  void push(IFocusableWidget widget) {
    debugPrint('ExpenseState push widgets count is ${widgets.count()}');
    if (widgets.count() == 0) {
      widget.focus();
    }
    widgets.push(widget);
  }
}

abstract class IScreenFocusStateHandler {
  IFocusableWidget? getWidgetHandler();

  void push(IFocusableWidget widget);
  IFocusableWidget? pop(BuildContext context);
}

abstract class IFocusableWidget {
  void handle(LogicalKeyboardKey pressedKey);
  void focus();
}
