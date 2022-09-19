import 'dart:developer';

import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:senior_project/Models/student_info.dart';
import 'package:senior_project/Repo/api_student.dart';
import 'package:senior_project/Utils/constants.dart';
import 'package:senior_project/Utils/themes/app_theme.dart';
import 'package:senior_project/View-Model/providers/auth/userAuthenticator.dart';
import 'package:senior_project/View-Model/providers/notification_badgeShower.dart';
import 'package:senior_project/View-Model/providers/public/theme_provider.dart';
import 'package:senior_project/View-Model/providers/public/wishlist_provider.dart';
import 'package:senior_project/View-Model/providers/router/routing.dart';
import 'package:senior_project/View/student_ui/notification_section.dart';
import 'package:senior_project/View/student_ui/student_announcements.dart';
import 'package:senior_project/View/student_ui/student_blogs.dart';
import 'package:senior_project/View/student_ui/student_calender.dart';
import 'package:senior_project/View/student_ui/student_profile.dart';
import 'package:senior_project/View/student_ui/student_tasks.dart';
import 'package:senior_project/View/teacher_ui/teacher_announcements.dart';
import 'package:senior_project/View/teacher_ui/teacher_classes.dart';
import 'package:senior_project/View/teacher_ui/teacher_home_page.dart';
import 'package:senior_project/View/teacher_ui/teacher_profile.dart';
import 'package:senior_project/View/teacherandStudent/book_library.dart';
import 'package:senior_project/View/student_ui/student_home.dart';
import 'package:senior_project/View/teacherandStudent/wishlist.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:unicons/unicons.dart';

class RoutingPage extends StatefulWidget {
  const RoutingPage({Key? key}) : super(key: key);

  @override
  State<RoutingPage> createState() => _RoutingPageState();
}

class _RoutingPageState extends State<RoutingPage> {
  var currentwindow = [
    const StudentHome(),
    const BooksLibrary(),
    const StudentBlogs(),
    const StudentProfile()
  ];
  var teachercurrenwindow = [
    const TeacherHome(),
    const BooksLibrary(),
    const TeacherClasses(),
    const TeacherProfile()
  ];
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  // ignore: non_constant_identifier_names
  DateTime pre_backpress = DateTime.now();
  StudentApi service = StudentApi();
  Future<List<Student>>? students;
  List<Student>? thestudent;
  Future<void> gettingStudents() async {
    students = service.getStudentByEmail(
        context.read<UserAuthenticator>().useremail().toString());
    thestudent = await service.getStudentByEmail(
        context.read<UserAuthenticator>().useremail().toString());
  }

  @override
  void initState() {
    super.initState();
    gettingStudents();
    fetchBadgeStatus();
  }

  fetchBadgeStatus() async {
    final pref = await SharedPreferences.getInstance();
    if (pref.getInt('badge') != null) {
      context.read<NotificationBadgeFire>().setCount = pref.getInt('badge')!;
      log(context.read<NotificationBadgeFire>().getCount.toString());
    }
  }

  setBadge() async {
    final pref = await SharedPreferences.getInstance();
    await pref.setInt('badge', thestudent![0].notificationsCount.length);
    log(thestudent![0].notificationsCount.length.toString());
  }

  int count = 0;
  num value = 0;
  @override
  Widget build(BuildContext context) {
    String userSplit = context.read<UserAuthenticator>().useremail().toString();
    String userId = userSplit.substring(0, userSplit.indexOf('@'));
    // ignore: non_constant_identifier_names
    var RoutingProvider = Provider.of<Routing>(context);
    var _apptheme = Provider.of<ThemeProvide>(context);
    Future.delayed(const Duration(seconds: 2), () {
      if (thestudent![0].notificationsCount.length != null) {
        setState(() {
          count = thestudent![0].notificationsCount.length;
        });
      }
    });
    value = count - context.read<NotificationBadgeFire>().getCount;
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
          drawer: userId.startsWith('11') == true
              ? const RoutingDrawer()
              : userId.startsWith('12') == true
                  ? const TeacherRoutingDrawer()
                  : const Drawer(),
          backgroundColor: _apptheme.getAppTheme == AppTheme.lightMode
              ? Theme.of(context).scaffoldBackgroundColor
              : darkModeBackground,
          appBar: AppBar(
            backgroundColor: _apptheme.getAppTheme == AppTheme.lightMode
                ? Theme.of(context).scaffoldBackgroundColor
                : darkModeBackground,
            leading: IconButton(
                onPressed: () => _key.currentState!.openDrawer(),
                icon: Icon(
                  EvaIcons.options2Outline,
                  color: _apptheme.getAppTheme.bodyMedium.color,
                  size: 35,
                )),
            elevation: 0,
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const WishList()));
                  },
                  icon: Badge(
                    badgeColor: _apptheme.getAppTheme == AppTheme.lightMode
                        ? ksecondary
                        : kprimary.withOpacity(0.6),
                    badgeContent: Text(
                      context
                          .watch<WishListProvider>()
                          .getTotalBooks
                          .toString(),
                      style: GoogleFonts.roboto(color: kwhite),
                    ),
                    child: Icon(
                      Icons.favorite_outline,
                      color: _apptheme.getAppTheme == AppTheme.lightMode
                          ? kblack
                          : kwhite,
                      size: 30,
                    ),
                  )),
              IconButton(
                  onPressed: () => {
                        if (_apptheme.getAppTheme == AppTheme.lightMode)
                          {_apptheme.setAppTheme = AppTheme.darkMode}
                        else
                          {_apptheme.setAppTheme = AppTheme.lightMode}
                      },
                  icon: Icon(
                    _apptheme.getAppTheme == AppTheme.lightMode
                        ? Icons.dark_mode_outlined
                        : Icons.light_mode_outlined,
                    color: _apptheme.getAppTheme == AppTheme.lightMode
                        ? kblack
                        : kwhite,
                    size: 35,
                  )),
              count > context.watch<NotificationBadgeFire>().getCount
                  ? Badge(
                      badgeColor: _apptheme.getAppTheme == AppTheme.lightMode
                          ? ksecondary
                          : kprimary.withOpacity(0.6),
                      badgeContent: Text(
                        '.',
                        style: GoogleFonts.roboto(color: kwhite),
                      ),
                      child: IconButton(
                          onPressed: () async {
                            await setBadge();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const NotificationSeciton()));
                          },
                          icon: Icon(
                            Icons.notifications_none_outlined,
                            color: _apptheme.getAppTheme == AppTheme.lightMode
                                ? kblack
                                : kwhite,
                            size: 35,
                          )),
                    )
                  : IconButton(
                      onPressed: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const NotificationSeciton()))
                          },
                      icon: Icon(
                        Icons.notifications_none_outlined,
                        color: _apptheme.getAppTheme == AppTheme.lightMode
                            ? kblack
                            : kwhite,
                        size: 35,
                      )),
            ],
            toolbarHeight: 80,
          ),
          body: userId.startsWith('11') == true
              ? currentwindow[RoutingProvider.getCurrentIndex]
              : userId.startsWith('12') == true
                  ? teachercurrenwindow[RoutingProvider.getCurrentIndex]
                  : null,
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
                label: 'Home',
                icon: RoutingProvider.getCurrentIndex != 0
                    ? const Icon(UniconsLine.home_alt)
                    : const Icon(Icons.home),
              ),
              BottomNavigationBarItem(
                label: 'Library',
                icon: RoutingProvider.getCurrentIndex != 1
                    ? const Icon(UniconsLine.book_open)
                    : const Icon(UniconsLine.book_reader),
              ),
              BottomNavigationBarItem(
                label: userId.startsWith('12') == true ? 'Classes' : 'Blogs',
                icon: RoutingProvider.getCurrentIndex != 2
                    ? const Icon(Icons.class_outlined)
                    : const Icon(Icons.class_),
              ),
              BottomNavigationBarItem(
                label: 'Profile',
                icon: RoutingProvider.getCurrentIndex != 3
                    ? const Icon(Icons.person_outline)
                    : const Icon(Icons.person),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            elevation: 0,
            backgroundColor: kwhite,
            child: Icon(
              UniconsLine.chat,
              color: Colors.black.withOpacity(0.4),
            ),
            onPressed: () {},
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        ),
      ),
    );
  }
}

class RoutingDrawer extends StatefulWidget {
  const RoutingDrawer({
    Key? key,
  }) : super(key: key);

  @override
  State<RoutingDrawer> createState() => _RoutingDrawerState();
}

class _RoutingDrawerState extends State<RoutingDrawer> {
  @override
  Widget build(BuildContext context) {
    var useremail = context.read<UserAuthenticator>().useremail().toString();
    final Stream<QuerySnapshot> _drawerStream = FirebaseFirestore.instance
        .collection('Student')
        .where('email', isEqualTo: useremail)
        .snapshots();

    var _apptheme = Provider.of<ThemeProvide>(context);
    return Drawer(
      backgroundColor: _apptheme.getAppTheme == AppTheme.lightMode
          ? kwhite
          : darkModeContainers,
      child: StreamBuilder<QuerySnapshot>(
          stream: _drawerStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                  child: Text('An Error Occured',
                      style: _apptheme.getAppTheme.bodyLarge));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return drawerShimmer(context);
            }

            return Column(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> _drawerData =
                  document.data() as Map<String, dynamic>;
              return drawerBody(context, _drawerData, _apptheme);
            }).toList());
          }),
    );
  }

  Column drawerBody(BuildContext context, Map<String, dynamic> _drawerData,
      ThemeProvide _apptheme) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.close,
                  size: 30,
                ))
          ],
        ),
        Container(
          margin: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const CircleAvatar(
                backgroundImage: AssetImage('assets/images/angelina.jpg'),
                radius: 30,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                _drawerData['First-Name'],
                style: _apptheme.getAppTheme.bodyLarge,
              ),
              const SizedBox(
                height: 50,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StudentAnnouncements(
                              grade: _drawerData['Grade'])));
                },
                child: Row(
                  children: <Widget>[
                    Icon(
                      UniconsLine.folder_question,
                      color: kprimary,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Announcements',
                      style: _apptheme.getAppTheme.bodyMedium,
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              StudentTasks(grade: _drawerData['Grade'])));
                },
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.task_alt,
                      color: kprimary,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Tasks',
                      style: _apptheme.getAppTheme.bodyMedium,
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              StudentCalender(grade: _drawerData['Grade'])));
                },
                child: Row(
                  children: <Widget>[
                    Icon(
                      UniconsLine.calendar_alt,
                      color: kprimary,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Schedule',
                      style: _apptheme.getAppTheme.bodyMedium,
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, 'student_leaves');
                },
                child: Row(
                  children: <Widget>[
                    Icon(
                      UniconsLine.folder_question,
                      color: kprimary,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Leaves',
                      style: _apptheme.getAppTheme.bodyMedium,
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              GestureDetector(
                onTap: () {
                  context.read<UserAuthenticator>().signOut();
                  Future.delayed(const Duration(seconds: 1), () {
                    Navigator.pushNamed(context, 'login');
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      EvaIcons.logOutOutline,
                      color: kprimary,
                      size: 40,
                    ),
                    Text(
                      'Logout',
                      style: _apptheme.getAppTheme.bodyMedium,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Shimmer drawerShimmer(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.7),
      highlightColor: Colors.black.withOpacity(0.04),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.close,
                    size: 30,
                    color: kblack,
                  ))
            ],
          ),
          Container(
            margin: const EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 40,
                  height: 40,
                  decoration:
                      BoxDecoration(color: kblack, shape: BoxShape.circle),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  color: kblack,
                  height: 20,
                  width: 120,
                ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: 40,
                      height: 40,
                      decoration:
                          BoxDecoration(color: kblack, shape: BoxShape.circle),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Container(
                      color: kblack,
                      height: 20,
                      width: 120,
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: 40,
                      height: 40,
                      decoration:
                          BoxDecoration(color: kblack, shape: BoxShape.circle),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Container(
                      color: kblack,
                      height: 20,
                      width: 120,
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: 40,
                      height: 40,
                      decoration:
                          BoxDecoration(color: kblack, shape: BoxShape.circle),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Container(
                      color: kblack,
                      height: 20,
                      width: 120,
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: 40,
                      height: 40,
                      decoration:
                          BoxDecoration(color: kblack, shape: BoxShape.circle),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Container(
                      color: kblack,
                      height: 20,
                      width: 120,
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: 40,
                      height: 40,
                      decoration:
                          BoxDecoration(color: kblack, shape: BoxShape.circle),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Container(
                      color: kblack,
                      height: 20,
                      width: 120,
                    )
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 40,
                      height: 40,
                      decoration:
                          BoxDecoration(color: kblack, shape: BoxShape.circle),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Container(
                      color: kblack,
                      height: 20,
                      width: 120,
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TeacherRoutingDrawer extends StatefulWidget {
  const TeacherRoutingDrawer({
    Key? key,
  }) : super(key: key);

  @override
  State<TeacherRoutingDrawer> createState() => _TeacherRoutingDrawerState();
}

class _TeacherRoutingDrawerState extends State<TeacherRoutingDrawer> {
  @override
  Widget build(BuildContext context) {
    var useremail = context.read<UserAuthenticator>().useremail().toString();
    final Stream<QuerySnapshot> _drawerStream = FirebaseFirestore.instance
        .collection('Teacher')
        .where('Email', isEqualTo: useremail)
        .snapshots();

    var _apptheme = Provider.of<ThemeProvide>(context);
    return Drawer(
      backgroundColor: _apptheme.getAppTheme == AppTheme.lightMode
          ? kwhite
          : darkModeContainers,
      child: StreamBuilder<QuerySnapshot>(
          stream: _drawerStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                  child: Text('An Error Occured',
                      style: _apptheme.getAppTheme.bodyLarge));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return drawerShimmer(context);
            }

            return Column(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> _drawerData =
                  document.data() as Map<String, dynamic>;
              return drawerBody(context, _drawerData, _apptheme);
            }).toList());
          }),
    );
  }

  Column drawerBody(BuildContext context, Map<String, dynamic> _drawerData,
      ThemeProvide _apptheme) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.close,
                  size: 30,
                ))
          ],
        ),
        Container(
          margin: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const CircleAvatar(
                backgroundImage: AssetImage('assets/images/angelina.jpg'),
                radius: 30,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                _drawerData['First-Name'],
                style: _apptheme.getAppTheme.bodyLarge,
              ),
              const SizedBox(
                height: 50,
              ),
              const SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, 'teacher_blogs');
                },
                child: Row(
                  children: <Widget>[
                    Icon(
                      UniconsLine.blogger,
                      color: kprimary,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Blogs',
                      style: _apptheme.getAppTheme.bodyMedium,
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, 'teacher_schedule');
                },
                child: Row(
                  children: <Widget>[
                    Icon(
                      UniconsLine.calendar_alt,
                      color: kprimary,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Schedule',
                      style: _apptheme.getAppTheme.bodyMedium,
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, 'teacher_tasks');
                },
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.task_alt,
                      color: kprimary,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Tasks',
                      style: _apptheme.getAppTheme.bodyMedium,
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              GestureDetector(
                onTap: () {
                  context.read<UserAuthenticator>().signOut();
                  Navigator.pushNamed(context, 'login');
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      EvaIcons.logOutOutline,
                      color: kprimary,
                      size: 40,
                    ),
                    Text(
                      'Logout',
                      style: _apptheme.getAppTheme.bodyMedium,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Shimmer drawerShimmer(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.7),
      highlightColor: Colors.black.withOpacity(0.04),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.close,
                    size: 30,
                    color: kblack,
                  ))
            ],
          ),
          Container(
            margin: const EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 40,
                  height: 40,
                  decoration:
                      BoxDecoration(color: kblack, shape: BoxShape.circle),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  color: kblack,
                  height: 20,
                  width: 120,
                ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: 40,
                      height: 40,
                      decoration:
                          BoxDecoration(color: kblack, shape: BoxShape.circle),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Container(
                      color: kblack,
                      height: 20,
                      width: 120,
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: 40,
                      height: 40,
                      decoration:
                          BoxDecoration(color: kblack, shape: BoxShape.circle),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Container(
                      color: kblack,
                      height: 20,
                      width: 120,
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: 40,
                      height: 40,
                      decoration:
                          BoxDecoration(color: kblack, shape: BoxShape.circle),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Container(
                      color: kblack,
                      height: 20,
                      width: 120,
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: 40,
                      height: 40,
                      decoration:
                          BoxDecoration(color: kblack, shape: BoxShape.circle),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Container(
                      color: kblack,
                      height: 20,
                      width: 120,
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: 40,
                      height: 40,
                      decoration:
                          BoxDecoration(color: kblack, shape: BoxShape.circle),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Container(
                      color: kblack,
                      height: 20,
                      width: 120,
                    )
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 40,
                      height: 40,
                      decoration:
                          BoxDecoration(color: kblack, shape: BoxShape.circle),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Container(
                      color: kblack,
                      height: 20,
                      width: 120,
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
