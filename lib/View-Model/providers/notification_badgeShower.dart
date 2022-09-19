import 'package:flutter/foundation.dart';

class NotificationBadgeFire with ChangeNotifier {
  int count=0;
  get getCount => count;
  set setCount(int _count) {
    count = _count;
    notifyListeners();
  }
}
