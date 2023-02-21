import 'package:flutter/material.dart';

class CatalogState extends ChangeNotifier implements IFocusStateHandler {
  @override
  FocusNode? nextFocus() {
    // TODO: implement handle

    return null;
  }
}

abstract class IFocusStateHandler {
  FocusNode? nextFocus();
}
