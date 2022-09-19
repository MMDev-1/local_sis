import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:senior_project/Models/student_info.dart';
import 'package:senior_project/Models/teacher_info.dart';
import 'package:senior_project/Repo/api_student.dart';
import 'package:senior_project/Repo/api_teacher.dart';
import 'package:senior_project/Utils/constants.dart';
import 'package:senior_project/Utils/themes/app_theme.dart';
import 'package:senior_project/View-Model/providers/auth/userAuthenticator.dart';
import 'package:senior_project/View-Model/providers/public/theme_provider.dart';
import 'package:senior_project/View-Model/providers/router/teacher_classes_provider.dart';
import 'package:senior_project/View/teacher_ui/announcements_comments_page.dart';
import 'package:senior_project/View/teacher_ui/create_announcement.dart';

class StudentAnnouncements extends StatefulWidget {
  StudentAnnouncements({Key? key, required this.grade}) : super(key: key);
  String grade;
  @override
  State<StudentAnnouncements> createState() => _StudentAnnouncementsState();
}

class _StudentAnnouncementsState extends State<StudentAnnouncements> {
  StudentApi service = StudentApi();
  Future<List<Student>>? students;
  List<Student>? thestudent;
  TeacherApi services = TeacherApi();
  Future<List<Teacher>>? teachers;
  List<Teacher>? theteacher;
  List neededReplies = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String userSplit = context.read<UserAuthenticator>().useremail().toString();
    String userId = userSplit.substring(0, userSplit.indexOf('@'));
    final Stream<QuerySnapshot> allAnnouncements = FirebaseFirestore.instance
        .collection('Announcements')
        .where('Class', isEqualTo: widget.grade)
        .snapshots();
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
        body: Container(
          margin: const EdgeInsets.all(9.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(20),
                  decoration:
                      BoxDecoration(gradient: kmix, borderRadius: kcircular),
                  height: 120,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Grade',
                        style: GoogleFonts.roboto(
                            color: kwhite,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.grade.toString(),
                        style: GoogleFonts.roboto(
                            color: kwhite,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: allAnnouncements,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'An Error have Occured!',
                          style: _apptheme.getAppTheme.bodyLarge,
                        ),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return Column(
                        children:
                            snapshot.data!.docs.map((DocumentSnapshot doc) {
                      Map<String, dynamic> data =
                          doc.data() as Map<String, dynamic>;
                      int count = data['Replies'].length;
                      Future<void> gettingStudents() async {
                        log('${data['Teacher-ID']}@apollosis.com');
                        students =
                            service.getStudentByEmail('$userId@apollosis.com');
                        thestudent = await service
                            .getStudentByEmail('$userId@apollosis.com');
                      }

                      Future<void> gettingTeacher() async {
                        log('${data['Teacher-ID']}@apollosis.com');
                        teachers =
                            services.getStudentByEmail('$userId@apollosis.com');
                        theteacher = await services
                            .getStudentByEmail('$userId@apollosis.com');
                      }

                      return GestureDetector(
                        onTap: gettingStudents,
                        onDoubleTap: gettingTeacher,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              boxShadow:
                                  _apptheme.getAppTheme == AppTheme.lightMode
                                      ? [kboxshadow2]
                                      : [kboxshadow3],
                              borderRadius: kcircular,
                              color: _apptheme.getAppTheme == AppTheme.lightMode
                                  ? kwhite
                                  : darkModeContainers),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  FutureBuilder(
                                    future: students,
                                    builder: (BuildContext context,
                                        AsyncSnapshot snapshot) {
                                      if (snapshot.hasError) {
                                        return Center(
                                          child: Text(
                                            'An Error have Occured!',
                                            style:
                                                _apptheme.getAppTheme.bodyLarge,
                                          ),
                                        );
                                      }
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                      return Text(
                                        'Teacher:${data['Teacher-ID']}',
                                        style: _apptheme.getAppTheme.bodyMedium,
                                      );
                                    },
                                  ),
                                  const Spacer()
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                data['Date'].toString(),
                                style: GoogleFonts.roboto(
                                  color: kblack.withOpacity(0.5),
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                data['Message'],
                                style: GoogleFonts.roboto(
                                    color: kblack,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              Divider(
                                color: kblack,
                                thickness: 2,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AnnouncementsCommentsPage(
                                                    message: data['Message'],
                                                    replies: neededReplies,
                                                    grade: widget.grade,
                                                    name:
                                                        '${thestudent![0].name} ${thestudent![0].lname}',
                                                    counter: count,
                                                    docId: doc.id)));
                                  },
                                  child: Text(
                                      '${count.toString()} class comments'))
                            ],
                          ),
                        ),
                      );
                    }).toList());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
