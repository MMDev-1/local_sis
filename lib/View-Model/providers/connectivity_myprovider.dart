import 'package:flutter/cupertino.dart';

class ConnectivityMyProvider with ChangeNotifier {
  String? result;
  get getResult => result;
  set setResult(String _result) {
    result = _result;
    notifyListeners();
  }
}
