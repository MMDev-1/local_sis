import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:provider/provider.dart';
import 'package:senior_project/View-Model/providers/auth/userAuthenticator.dart';
import 'package:senior_project/View-Model/providers/auth/user_control.dart';
import 'package:senior_project/View-Model/providers/id_provider.dart';
import 'package:senior_project/View-Model/providers/loggedIn_user.dart';
import 'package:senior_project/View-Model/providers/notification_badgeShower.dart';
import 'package:senior_project/View-Model/providers/public/theme_provider.dart';
import 'package:senior_project/View-Model/providers/router/enterance_router.dart';
import 'package:senior_project/View-Model/providers/router/grade_provider_id.dart';
import 'package:senior_project/View-Model/providers/router/routing.dart';
import 'package:senior_project/View-Model/providers/public/theme_provider.dart';
import 'package:senior_project/View-Model/providers/public/wishlist_provider.dart';
import 'package:senior_project/View-Model/providers/router/teacher_classes_provider.dart';
import 'package:senior_project/View-Model/providers/search_book_provider.dart';
import 'package:senior_project/View-Model/providers/toggle_provider.dart';
import 'package:senior_project/View/enterance/enterance.dart';
import 'package:senior_project/View/router/routing_page.dart';
import 'package:senior_project/View/router/teacher_classes_router.dart';
import 'package:senior_project/View/student_ui/student_blogs.dart';
import 'package:senior_project/View/student_ui/student_leave_request.dart';
import 'package:senior_project/View/student_ui/student_leaves.dart';
import 'package:senior_project/View/teacher_ui/create_blog.dart';
import 'package:senior_project/View/teacher_ui/create_task_page.dart';
import 'package:senior_project/View/teacher_ui/teacher_blogs_page.dart';
import 'package:senior_project/View/teacher_ui/teacher_grading_students.dart';
import 'package:senior_project/View/teacher_ui/teacher_schedule.dart';
import 'package:senior_project/View/teacher_ui/teacher_tasks.dart';
import 'package:senior_project/View/teacherandStudent/book_page.dart';
import 'package:senior_project/View/student_ui/student_login.dart';
import 'package:senior_project/View/student_ui/student_calender.dart';
import 'package:senior_project/View/student_ui/student_home.dart';
import 'package:senior_project/View/student_ui/student_tasks.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized;
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  bool? _isFirstRun;

  void _checkFirstRun() async {
    bool ifr = await IsFirstRun.isFirstRun();
    setState(() {
      _isFirstRun = ifr;
    });
  }

  void _reset() async {
    await IsFirstRun.reset();
    _checkFirstRun();
  }

  @override
  void initState() {
    _checkFirstRun();

    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        log('inactive');
        break;
      case AppLifecycleState.paused:
        log('paused');
        break;
      case AppLifecycleState.resumed:
        log('resumed');
        break;
      case AppLifecycleState.detached:
        log('detached');
        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  final key1 = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NotificationBadgeFire>(
            create: (_) => NotificationBadgeFire()),
        ChangeNotifierProvider<LoggedInUser>(create: (_) => LoggedInUser()),
        ChangeNotifierProvider<SearchBooksProvider>(
            create: (_) => SearchBooksProvider()),
        ChangeNotifierProvider<GradeProviderId>(
            create: (_) => GradeProviderId()),
        ChangeNotifierProvider<ClassesProvider>(
            create: (_) => ClassesProvider()),
        ChangeNotifierProvider<IdProvider>(create: (_) => IdProvider()),
        ChangeNotifierProvider<ToggleProvider>(create: (_) => ToggleProvider()),
        ChangeNotifierProvider<WishListProvider>(
            create: (_) => WishListProvider()),
        ChangeNotifierProvider<LoadingControl>(create: (_) => LoadingControl()),
        ChangeNotifierProvider<EnteranceRouting>(
            create: (_) => EnteranceRouting()),
        ChangeNotifierProvider<Routing>(create: (_) => Routing()),
        ChangeNotifierProvider<ThemeProvide>(create: (_) => ThemeProvide()),
        Provider<UserAuthenticator>(
            create: (_) => UserAuthenticator(FirebaseAuth.instance)),
        StreamProvider(
            create: (context) =>
                context.read<UserAuthenticator>().authStateChanges,
            initialData: null)
      ],
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: MaterialApp(
          navigatorObservers: [],
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          routes: {
            'routing': (context) => const RoutingPage(),
            'enterance': (context) => const Enterance(),
            'login': (context) => const LoginTest(),
            'student_home': (context) => const StudentHome(),
            'student_leaves': (context) => const StudentLeaves(),
            'student_leave_request': (context) => const StudentLeaveRequest(),
            'teacher_schedule': (context) => const TeacherSchedule(),
            'teacher_tasks': (context) => const TeacherTasks(),
            'teacher_router': (context) => const TeacherRouter(),
            'grades_for_students': (context) => const StudentGrading(),
            'student_blogs': (context) => const StudentBlogs(),
            'teacher_blogs': (context) => const TeacherBlogsPage(),
            'create_blog': (context) => const CreateBlogPage()
          },
          home: FutureBuilder(
            future: _initializeFirebase(),
            builder: (context, snap) {
              if (snap.hasError) {
                log('${snap.error}');
              } else if (snap.connectionState == ConnectionState.done) {
                return _isFirstRun == true
                    ? const Enterance()
                    : context.read<UserAuthenticator>().userCheck() == null
                        ? const LoginTest()
                        : const RoutingPage();
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }
}

/*class Project extends StatelessWidget {
  const Project({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const StudentHome();
  }
}
*/