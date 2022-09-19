import 'package:flutter/cupertino.dart';

class ClassesProvider with ChangeNotifier {
  String? grade;
  String? teacherfname;
  String? teacherlname;
  get getGrade => grade;
  set setGrade(String _grade) {
    grade = _grade;
    notifyListeners();
  }
get getName => teacherfname;
  set setName(String _grade) {
    teacherfname = _grade;
    notifyListeners();
  }
  
get getlName => teacherlname;
  set setlName(String _grade) {
    teacherlname = _grade;
    notifyListeners();
  }
  int _currentIndex = 0;
  get getCurrentIndex => _currentIndex;
  set setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
