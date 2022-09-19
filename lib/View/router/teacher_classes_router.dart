import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:senior_project/Utils/constants.dart';
import 'package:senior_project/Utils/themes/app_theme.dart';
import 'package:senior_project/View-Model/providers/auth/userAuthenticator.dart';
import 'package:senior_project/View-Model/providers/public/theme_provider.dart';
import 'package:senior_project/View-Model/providers/public/wishlist_provider.dart';
import 'package:senior_project/View-Model/providers/router/routing.dart';
import 'package:senior_project/View-Model/providers/router/teacher_classes_provider.dart';
import 'package:senior_project/View/student_ui/student_blogs.dart';
import 'package:senior_project/View/student_ui/student_calender.dart';
import 'package:senior_project/View/student_ui/student_profile.dart';
import 'package:senior_project/View/student_ui/student_tasks.dart';
import 'package:senior_project/View/teacher_ui/attendance.dart';
import 'package:senior_project/View/teacher_ui/teacher_announcements.dart';
import 'package:senior_project/View/teacher_ui/teacher_classes.dart';
import 'package:senior_project/View/teacher_ui/teacher_grades.dart';
import 'package:senior_project/View/teacher_ui/teacher_profile.dart';
import 'package:senior_project/View/teacher_ui/teacher_students_view.dart';
import 'package:senior_project/View/teacherandStudent/book_library.dart';
import 'package:senior_project/View/student_ui/student_home.dart';
import 'package:senior_project/View/teacherandStudent/wishlist.dart';
import 'package:shimmer/shimmer.dart';
import 'package:unicons/unicons.dart';

class TeacherRouter extends StatefulWidget {
  const TeacherRouter({Key? key}) : super(key: key);

  @override
  State<TeacherRouter> createState() => _TeacherRouterState();
}

class _TeacherRouterState extends State<TeacherRouter> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  // ignore: non_constant_identifier_names
  DateTime pre_backpress = DateTime.now();
  @override
  Widget build(BuildContext context) {
    String userSplit = context.read<UserAuthenticator>().useremail().toString();
    String userId = userSplit.substring(0, userSplit.indexOf('@'));
    // ignore: non_constant_identifier_names
    var RoutingProvider = Provider.of<ClassesProvider>(context);
    var _apptheme = Provider.of<ThemeProvide>(context);
    var currentwindow = [
      Attendance(grade: RoutingProvider.getGrade),
      const TeacherGrades(),
      TeacherStudentsView(grade: RoutingProvider.getGrade),
      TeacherAnnouncements(grade: RoutingProvider.getGrade)
    ];

    return WillPopScope(
      onWillPop: () async {
        if (RoutingProvider.getCurrentIndex == 0) {
          /*final timegap = DateTime.now().difference(pre_backpress);
          final cantExit = timegap >= const Duration(milliseconds: 750);
          pre_backpress = DateTime.now();
          if (cantExit) {
            return HapticFeedback.vibrate() as bool;
          } else {
            return true; // true will exit the app
          }*/
          return true;
        } else {
          return RoutingProvider.setCurrentIndex =
              RoutingProvider.getCurrentIndex - RoutingProvider.getCurrentIndex;
        }
      },
      child: SafeArea(
        child: Scaffold(
          key: _key,
          body: currentwindow[RoutingProvider.getCurrentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: RoutingProvider.getCurrentIndex,
            elevation: 5,
            type: BottomNavigationBarType.fixed,
            backgroundColor: _apptheme.getAppTheme == AppTheme.lightMode
                ? Theme.of(context).scaffoldBackgroundColor
                : kblack,
            selectedItemColor: ksecondary,
            unselectedItemColor: _apptheme.getAppTheme == AppTheme.lightMode
                ? Colors.black.withOpacity(0.4)
                : kwhite,
            selectedFontSize: 14,
            unselectedFontSize: 14,
            onTap: (int i) {
              RoutingProvider.setCurrentIndex = i;
            },
            items: [
              BottomNavigationBarItem(
                label: 'Attendance',
                icon: RoutingProvider.getCurrentIndex != 0
                    ? const Icon(Icons.person_add)
                    : const Icon(Icons.person_add_alt),
              ),
              BottomNavigationBarItem(
                label: 'Grades',
                icon: RoutingProvider.getCurrentIndex != 1
                    ? const Icon(Icons.grade_outlined)
                    : const Icon(Icons.grade),
              ),
              BottomNavigationBarItem(
                label: 'Students',
                icon: RoutingProvider.getCurrentIndex != 2
                    ? const Icon(UniconsLine.dashboard)
                    : const Icon(UniconsLine.dashboard),
              ),
              BottomNavigationBarItem(
                label: 'Stream',
                icon: RoutingProvider.getCurrentIndex != 3
                    ? const Icon(Icons.announcement_outlined)
                    : const Icon(Icons.announcement),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
