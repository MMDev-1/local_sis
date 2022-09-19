import 'package:flutter/cupertino.dart';

class ToggleProvider with ChangeNotifier {
  int index = 0;
  get getIndex => index;
  set setIndex(int _index) {
    index = _index;
    notifyListeners();
  }
}
