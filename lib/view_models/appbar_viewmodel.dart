import 'package:flutter/material.dart';

class AppBarViewModel extends ChangeNotifier {

  int index = 0;

  void setIndex(int value) {
    index = value;
    notifyListeners();
  }
}