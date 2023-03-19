import 'dart:collection';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FocusableWidgetStackStructure {
  FocusableWidgetStackStructure() : _storage = <FocusableWidgetStack>[];
  final List<FocusableWidgetStack> _storage;

  void push(FocusableWidgetStack element) {
    _storage.add(element);
  }

  int count() {
    return _storage.length;
  }

  FocusableWidgetStack? pop() {
    if (_storage.isNotEmpty) {
      return _storage.removeLast();
    }

    return null;
  }

  FocusableWidgetStack? getActive() {
    for (var element in _storage) {
      if (element.isActive) {
        return element;
      }
    }
  }

  void setActive(IFocusableWidget widget) {
    _storage.where((element) => element.isActive).forEach((element) {
      element.setInactive();
    });

    _storage.singleWhere((element) => element.widget == widget).setActive();
  }

  FocusableWidgetStack? peek() {
    if (_storage.isNotEmpty) {
      return _storage.last;
    }
    return null;
  }
}

class FocusableWidgetStack {
  final IFocusableWidget widget;
  bool isActive = false;

  FocusableWidgetStack(this.widget);

  void setActive() {
    isActive = true;
  }

  void setInactive() {
    isActive = false;
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

  void addNavigationListener(VoidCallback callback) {
    _screens[_currentScreen]?.setNavigationListener(callback);
  }

  IFocusableWidget? getScreenWidgetHandler() {
    return _screens[_currentScreen]?.getWidgetHandler();
  }
}

class ExpenseState extends ChangeNotifier implements IScreenFocusStateHandler {
  FocusableWidgetStackStructure widgets = FocusableWidgetStackStructure();

  VoidCallback? navigationListener;

  @override
  IFocusableWidget? getWidgetHandler() {
    debugPrint('ExpenseState getWidgetHandler');
    IFocusableWidget? value = widgets.getActive()?.widget;
    return value;
  }

  @override
  IFocusableWidget? pop(BuildContext context) {
    debugPrint('ExpenseState pop');
    if (navigationListener != null) {
      navigationListener!.call();
    }
    /*
IFocusableWidget? current = widgets.peek()?.widget;
    if (current == null) {
      Navigator.pop(context);
    } else {
      widgets.setActive(current);
      current.focus();
    }

    return current;
    */
  }

  @override
  void push(IFocusableWidget widget) {
    debugPrint('ExpenseState push widgets count is ${widgets.count()}');
    FocusableWidgetStack stack = FocusableWidgetStack(widget);
    if (widgets.count() == 0) {
      stack.setActive();
    }
    widgets.push(stack);
  }

  @override
  void next() {}

  @override
  void setNavigationListener(VoidCallback action) {
    navigationListener = action;
  }
}

abstract class IScreenFocusStateHandler {
  IFocusableWidget? getWidgetHandler();

  void push(IFocusableWidget widget);
  IFocusableWidget? pop(BuildContext context);

  void setNavigationListener(VoidCallback action);

  void next();
}

abstract class IFocusableWidget {
  void handle(LogicalKeyboardKey pressedKey);
  void focus();
}
