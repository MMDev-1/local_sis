import 'package:flutter/cupertino.dart';

class GradeProviderId with ChangeNotifier {
  String? docId;
  get getdocId => docId;
  set setdocId(_docId) {
    docId = _docId;
    notifyListeners();
  }
}
