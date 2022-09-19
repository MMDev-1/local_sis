import 'package:flutter/material.dart';

class LoadingControl with ChangeNotifier {
  bool isLoading = false;
  get getLogger => isLoading;
  set setLogger(bool v) {
    isLoading = v;
    notifyListeners();
  }
}
