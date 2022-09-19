import 'package:flutter/cupertino.dart';

class LoggedInUser with ChangeNotifier {
  String? name;
  get getUserName => name;

  set setUserName(_name) {
    name = _name;
    notifyListeners();
  }
}
