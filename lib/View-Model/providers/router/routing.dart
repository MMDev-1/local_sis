import 'package:flutter/cupertino.dart';

class Routing with ChangeNotifier {
  int _currentIndex = 0;
  get getCurrentIndex => _currentIndex;
  set setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
