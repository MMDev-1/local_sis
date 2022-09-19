import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class IdProvider with ChangeNotifier {
  String id = '';
  get getID => id;
  set setID(String _id) {
    id = _id;
    notifyListeners();
  }
}
