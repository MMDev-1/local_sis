import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senior_project/Utils/constants.dart';
import 'package:senior_project/Utils/themes/app_theme.dart';
import 'package:senior_project/View-Model/providers/public/theme_provider.dart';

class ReadingTasks extends StatefulWidget {
  ReadingTasks({Key? key, required this.desc}) : super(key: key);
  String desc;

  @override
  State<ReadingTasks> createState() => _ReadingTasksState();
}

class _ReadingTasksState extends State<ReadingTasks> {
  @override
  Widget build(BuildContext context) {
    var _apptheme = Provider.of<ThemeProvide>(context);
    return SafeArea(
        child: Scaffold(
      backgroundColor: _apptheme.getAppTheme == AppTheme.lightMode
          ? Theme.of(context).scaffoldBackgroundColor
          : darkModeBackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: _apptheme.getAppTheme == AppTheme.lightMode
            ? Theme.of(context).scaffoldBackgroundColor
            : darkModeBackground,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_sharp,
              size: 30, color: _apptheme.getAppTheme.bodyLarge.color),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            widget.desc,
            style: _apptheme.getAppTheme.bodyMedium,
          ),
        ),
      ),
    ));
  }
}
