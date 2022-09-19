import 'package:flutter/material.dart';
import 'package:senior_project/Utils/themes/app_theme.dart';

class ThemeProvide with ChangeNotifier {
  var appTheme = AppTheme.lightMode;
  get getAppTheme => appTheme;
  set setAppTheme(TextTheme _apptheme) {
    appTheme = _apptheme;
    notifyListeners();
  }
}
