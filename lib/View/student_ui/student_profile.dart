import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:senior_project/Models/student_info.dart';
import 'package:senior_project/Repo/api_student.dart';
import 'package:senior_project/Utils/constants.dart';
import 'package:senior_project/Utils/themes/app_theme.dart';
import 'package:senior_project/View-Model/providers/auth/userAuthenticator.dart';
import 'package:senior_project/View-Model/providers/public/theme_provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:unicons/unicons.dart';

class StudentProfile extends StatefulWidget {
  const StudentProfile({Key? key}) : super(key: key);

  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
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
  }

  @override
  Widget build(BuildContext context) {
    var _apptheme = Provider.of<ThemeProvide>(context);
    return SingleChildScrollView(
      child: FutureBuilder(
        future: students,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'An Error has occured!',
                style: _apptheme.getAppTheme.bodyLarge,
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return profileShimmer(_apptheme);
          }
          return studentProfile(_apptheme, context);
        },
      ),
    );
  }

  Shimmer profileShimmer(ThemeProvide _apptheme) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.7),
      highlightColor: Colors.black.withOpacity(0.04),
      child: Column(
        children: [
          Container(
            height: 90,
            width: 90,
            decoration: BoxDecoration(shape: BoxShape.circle, color: kblack),
          ),
          const SizedBox(
            height: 12,
          ),
          Container(
            width: 200,
            height: 30,
            decoration:
                BoxDecoration(color: kblack, borderRadius: kmaximumCircular),
          ),
          const SizedBox(
            height: 7,
          ),
          Container(
            width: 200,
            height: 30,
            decoration:
                BoxDecoration(color: kblack, borderRadius: kmaximumCircular),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 30, 30, 12),
            child: Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      color: _apptheme.getAppTheme == AppTheme.lightMode
                          ? kprimary
                          : darkModeBackground,
                      shape: BoxShape.circle),
                ),
                const SizedBox(
                  width: 20,
                ),
                Container(
                  width: 250,
                  height: 30,
                  decoration: BoxDecoration(
                      color: kblack, borderRadius: kmaximumCircular),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 8, 30, 12),
            child: Row(
              children: <Widget>[
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      color: _apptheme.getAppTheme == AppTheme.lightMode
                          ? kprimary
                          : darkModeBackground,
                      shape: BoxShape.circle),
                ),
                const SizedBox(
                  width: 20,
                ),
                Container(
                  width: 250,
                  height: 30,
                  decoration: BoxDecoration(
                      color: kblack, borderRadius: kmaximumCircular),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 8, 30, 12),
            child: Row(
              children: <Widget>[
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      color: _apptheme.getAppTheme == AppTheme.lightMode
                          ? kprimary
                          : darkModeBackground,
                      shape: BoxShape.circle),
                ),
                const SizedBox(
                  width: 20,
                ),
                Container(
                  width: 250,
                  height: 30,
                  decoration: BoxDecoration(
                      color: kblack, borderRadius: kmaximumCircular),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 8, 30, 12),
            child: Row(
              children: <Widget>[
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      color: _apptheme.getAppTheme == AppTheme.lightMode
                          ? kprimary
                          : darkModeBackground,
                      shape: BoxShape.circle),
                ),
                const SizedBox(
                  width: 20,
                ),
                Container(
                  width: 250,
                  height: 30,
                  decoration: BoxDecoration(
                      color: kblack, borderRadius: kmaximumCircular),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 8, 30, 12),
            child: Row(
              children: <Widget>[
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      color: _apptheme.getAppTheme == AppTheme.lightMode
                          ? kprimary
                          : darkModeBackground,
                      shape: BoxShape.circle),
                ),
                const SizedBox(
                  width: 20,
                ),
                Container(
                  width: 250,
                  height: 30,
                  decoration: BoxDecoration(
                      color: kblack, borderRadius: kmaximumCircular),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Stack studentProfile(ThemeProvide _apptheme, BuildContext context) {
    return Stack(
      children: [
        Container(
          color: _apptheme.getAppTheme == AppTheme.lightMode
              ? kprimary
              : darkModeBackground,
          height: MediaQuery.of(context).size.height,
          child: Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
            color: _apptheme.getAppTheme == AppTheme.lightMode
                ? Theme.of(context).scaffoldBackgroundColor
                : darkModeContainers,
          ),
        ),
        Column(
          children: [
            Container(
              height: 200,
              padding: const EdgeInsets.all(12.0),
              width: double.infinity,
              margin: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                  boxShadow: _apptheme.getAppTheme == AppTheme.lightMode
                      ? [kboxshadow2]
                      : [kboxshadow3],
                  borderRadius: kcircular,
                  color: _apptheme.getAppTheme == AppTheme.lightMode
                      ? kwhite
                      : darkModeContainers),
              child: Column(
                children: <Widget>[
                  Container(
                    height: 90,
                    width: 90,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: AssetImage('assets/images/angelina.jpg'),
                            fit: BoxFit.cover)),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    thestudent![0].name,
                    style: _apptheme.getAppTheme.bodyMedium,
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  Text(
                    '@ ${thestudent![0].id}',
                    style: _apptheme.getAppTheme.bodyMedium,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 8, 30, 12),
              child: Row(
                children: <Widget>[
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        color: _apptheme.getAppTheme == AppTheme.lightMode
                            ? kprimary
                            : darkModeBackground,
                        shape: BoxShape.circle),
                    child: Icon(
                      FontAwesomeIcons.person,
                      color: _apptheme.getAppTheme == AppTheme.lightMode
                          ? kwhite
                          : Colors.grey,
                      size: 25,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    '${thestudent![0].name} ${thestudent![0].lname}',
                    style: _apptheme.getAppTheme.bodyMedium,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 8, 30, 12),
              child: Row(
                children: <Widget>[
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        color: _apptheme.getAppTheme == AppTheme.lightMode
                            ? kprimary
                            : darkModeBackground,
                        shape: BoxShape.circle),
                    child: Icon(
                      Icons.class_outlined,
                      color: _apptheme.getAppTheme == AppTheme.lightMode
                          ? kwhite
                          : Colors.grey,
                      size: 25,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    thestudent![0].grade,
                    style: _apptheme.getAppTheme.bodyMedium,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 8, 30, 12),
              child: Row(
                children: <Widget>[
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        color: _apptheme.getAppTheme == AppTheme.lightMode
                            ? kprimary
                            : darkModeBackground,
                        shape: BoxShape.circle),
                    child: Icon(
                      Icons.cake_outlined,
                      color: _apptheme.getAppTheme == AppTheme.lightMode
                          ? kwhite
                          : Colors.grey,
                      size: 25,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    thestudent![0].birthdate,
                    style: _apptheme.getAppTheme.bodyMedium,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 8, 30, 12),
              child: Row(
                children: <Widget>[
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        color: _apptheme.getAppTheme == AppTheme.lightMode
                            ? kprimary
                            : darkModeBackground,
                        shape: BoxShape.circle),
                    child: Icon(
                      EvaIcons.phoneCallOutline,
                      color: _apptheme.getAppTheme == AppTheme.lightMode
                          ? kwhite
                          : Colors.grey,
                      size: 25,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    thestudent![0].phone,
                    style: _apptheme.getAppTheme.bodyMedium,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 8, 30, 12),
              child: Row(
                children: <Widget>[
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        color: _apptheme.getAppTheme == AppTheme.lightMode
                            ? kprimary
                            : darkModeBackground,
                        shape: BoxShape.circle),
                    child: Icon(
                      EvaIcons.emailOutline,
                      color: _apptheme.getAppTheme == AppTheme.lightMode
                          ? kwhite
                          : Colors.grey,
                      size: 25,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    thestudent![0].email,
                    style: _apptheme.getAppTheme.bodyMedium,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 8, 30, 12),
              child: Row(
                children: <Widget>[
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        color: _apptheme.getAppTheme == AppTheme.lightMode
                            ? kprimary
                            : darkModeBackground,
                        shape: BoxShape.circle),
                    child: Icon(
                      FontAwesomeIcons.locationPinLock,
                      color: _apptheme.getAppTheme == AppTheme.lightMode
                          ? kwhite
                          : Colors.grey,
                      size: 25,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    thestudent![0].address,
                    style: _apptheme.getAppTheme.bodyMedium,
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
