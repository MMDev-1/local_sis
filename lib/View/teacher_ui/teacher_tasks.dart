import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:senior_project/Models/student_info.dart';
import 'package:senior_project/Models/teacher_form.dart';
import 'package:senior_project/Utils/constants.dart';
import 'package:senior_project/View-Model/providers/auth/userAuthenticator.dart';
import 'package:senior_project/View-Model/providers/public/theme_provider.dart';
import 'package:senior_project/View/router/routing_page.dart';
import 'package:senior_project/View/teacher_ui/create_task_page.dart';
import 'package:senior_project/View/teacher_ui/edit_task_page.dart';

import '../../Repo/api_student.dart';

class TeacherTasks extends StatefulWidget {
  const TeacherTasks({Key? key}) : super(key: key);

  @override
  State<TeacherTasks> createState() => _TeacherTasksState();
}

class _TeacherTasksState extends State<TeacherTasks> {
  // ignore: prefer_typing_uninitialized_variables
  late List<String> grades = [''];
  StudentApi service = StudentApi();
  Future<List<Student>>? allStudents;
  List<Student>? retrievedStudents;
  Future<void> gettingBooks() async {
    allStudents = service.getAllStudents();
    retrievedStudents = await service.getAllStudents();
  }

  @override
  void initState() {
    super.initState();
    gettingBooks();
  }

  @override
  Widget build(BuildContext context) {
    var _appthemecontroller = Provider.of<ThemeProvide>(context);
    var _apptheme = _appthemecontroller.getAppTheme;
    String userSplit = context.read<UserAuthenticator>().useremail().toString();
    String userId = userSplit.substring(0, userSplit.indexOf('@'));
    final Stream<QuerySnapshot> _teacherTasks = FirebaseFirestore.instance
        .collection('Tasks')
        .where('Teacher-ID', isEqualTo: int.parse(userId))
        .snapshots();

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamed(context, 'routing');
        return true;
      },
      child: SafeArea(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            floatingActionButton: FloatingActionButton(
              backgroundColor: kprimary,
              onPressed: () {
                Future.delayed(const Duration(seconds: 3), () {
                  for (var i = 0; i <= retrievedStudents!.length; i++) {
                    if (grades.contains(retrievedStudents![i].grade) == false) {
                      grades.add(retrievedStudents![i].grade);
                    } else {}
                  }
                });
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            TaskPageCreation(thegrades: grades)));
              },
              child: const Icon(
                Icons.add,
              ),
            ),
            body: SingleChildScrollView(
              child: StreamBuilder(
                stream: _teacherTasks,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                        child: Text(
                      'An Error Occured',
                    ));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return Column(
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    DateTime date = data['Due'].toDate();
                    DateTime startdate = data['Start'].toDate();
                    DateTime nowDating = DateTime.now();
                    var result = nowDating.compareTo(date);
                    String kday = date.day.toString();
                    String kmonth = date.month.toString();
                    String kyear = date.year.toString();
                    String khour = date.hour.toString();
                    String kminutes = date.minute.toString();
                    return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TaskPageEditing(
                                        mytaskForm: TaskForm(
                                            data['Attachments'],
                                            data['Course-Name'],
                                            data['Description'],
                                            Timestamp.fromDate(date),
                                            data['Participants-Class'],
                                            data['Submissions'],
                                            Timestamp.fromDate(startdate),
                                            data['Teacher-ID'],
                                            data['Title'],
                                            data['Weight'],
                                            document.id),
                                      )));
                        },
                        child: Container(
                          margin: const EdgeInsets.all(20),
                          padding: const EdgeInsets.all(10),
                          height: 150,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              gradient: kmix, borderRadius: kcircular),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    data['Title'].toString(),
                                    style: GoogleFonts.roboto(
                                        color: kwhite,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Divider(
                                color: kwhite.withOpacity(0.6),
                                thickness: 1,
                              ),
                              Text(
                                data['Course-Name'].toString(),
                                style: GoogleFonts.roboto(
                                    color: kwhite,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.date_range,
                                    color: kwhite,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    '$kday-$kmonth-$kyear $khour:$kminutes',
                                    style: GoogleFonts.roboto(
                                        color: kwhite,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ));
                  }).toList());
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
