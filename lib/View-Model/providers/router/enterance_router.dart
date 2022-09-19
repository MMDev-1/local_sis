import 'package:flutter/material.dart';

class EnteranceRouting with ChangeNotifier {
  int _currentIndex = 0;

  get getCurrentIndex => _currentIndex;

  incrementIndex() {
    _currentIndex++;
    notifyListeners();
  }

  set setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
