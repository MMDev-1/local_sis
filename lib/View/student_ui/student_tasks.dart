import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';
import 'package:senior_project/Models/student_results_form.dart';
import 'package:senior_project/Models/student_task.dart';
import 'package:senior_project/Repo/api_tasks.dart';
import 'package:senior_project/Utils/constants.dart';
import 'package:senior_project/Utils/themes/app_theme.dart';
import 'package:senior_project/View-Model/providers/auth/userAuthenticator.dart';
import 'package:senior_project/View-Model/providers/public/theme_provider.dart';
import 'package:senior_project/View-Model/providers/toggle_provider.dart';
import 'package:senior_project/View/student_ui/student_task_page.dart';

class StudentTasks extends StatefulWidget {
  StudentTasks({Key? key, required this.grade}) : super(key: key);
  String grade;
  @override
  State<StudentTasks> createState() => _StudentTasksState();
}

class _StudentTasksState extends State<StudentTasks> {
  List typeOfTasks = ['Pending', 'All Tasks'];
  TasksApi service = TasksApi();
  Future<List<StudentResultsForm>>? statusFuture;
  List<StudentResultsForm>? resultsList;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _apptheme = Provider.of<ThemeProvide>(context);
    final Stream<QuerySnapshot> _taskStream = FirebaseFirestore.instance
        .collection('Tasks')
        .where('Participants-Class', isEqualTo: widget.grade)
        .snapshots();
    int indexGetter = context.read<ToggleProvider>().getIndex;
    var indexing = context.read<ToggleProvider>();
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
          child: GestureDetector(
            onTap: () {},
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              indexing.setIndex = 0;
                            });
                          },
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              color: indexGetter == 0
                                  ? kprimary
                                  : Colors.grey.shade400,
                              borderRadius: finalCircular,
                            ),
                            child: Center(
                              child: Text('All Tasks',
                                  style: GoogleFonts.roboto(
                                      color: indexGetter == 1 ? kblack : kwhite,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              indexing.setIndex = 1;
                            });
                          },
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              color: indexGetter == 1
                                  ? kprimary
                                  : Colors.grey.shade400,
                              borderRadius: finalCircular,
                            ),
                            child: Center(
                              child: Text('Pending',
                                  style: GoogleFonts.roboto(
                                      color: indexGetter == 0 ? kblack : kwhite,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                indexGetter == 1
                    ? pendingTasks(context, _taskStream, _apptheme)
                    : allTasks(context, _taskStream, _apptheme)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column allTasks(BuildContext context,
      Stream<QuerySnapshot<Object?>> _taskStream, ThemeProvide _apptheme) {
    return Column(
      children: [
        const SizedBox(
          height: 30,
        ),
        StreamBuilder<QuerySnapshot>(
          stream: _taskStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                  child: Text('An Error Occured',
                      style: _apptheme.getAppTheme.bodyLarge));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Column(
                children: snapshot.data!.docs.map((DocumentSnapshot doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              //
              String userSplit =
                  context.read<UserAuthenticator>().useremail().toString();
              String userId = userSplit.substring(0, userSplit.indexOf('@'));
              Future<void> gettingStatus(String taskId, String ResultId) async {
                statusFuture = service.getStudentTaskStatus(doc.id, userId);
                resultsList =
                    await service.getStudentTaskStatus(doc.id, userId);
              }

              //
              DateTime date = data['Due'].toDate();
              DateTime nowDating = DateTime.now();
              var result = nowDating.compareTo(date);
              String kday = date.day.toString();
              String kmonth = date.month.toString();
              String kyear = date.year.toString();
              String khour = date.hour.toString();
              String kminutes = date.minute.toString();
              switch (kmonth) {
                case '1':
                  kmonth = 'Jan';
                  break;
                case '2':
                  kmonth = 'Feb';
                  break;
                case '3':
                  kmonth = 'Mar';
                  break;
                case '4':
                  kmonth = 'Apr';
                  break;
                case '5':
                  kmonth = 'May';
                  break;
                case '6':
                  kmonth = 'Jun';
                  break;
                case '7':
                  kmonth = 'Jul';
                  break;
                case '8':
                  kmonth = 'Aug';
                  break;
                case '9':
                  kmonth = 'Sep';
                  break;
                case '10':
                  kmonth = 'Oct';
                  break;
                case '11':
                  kmonth = 'Nov';
                  break;
                case '12':
                  kmonth = 'Dec';
                  break;
              }

              return Padding(
                  padding: const EdgeInsets.only(top: 10),
                  // ignore: unrelated_type_equality_checks
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StudentTaskPage(
                                    studentTaskForm: StudentTaskForm(
                                        data['Course-Name'],
                                        '$kday $kmonth $kyear at $khour:$kminutes',
                                        data['Description'],
                                        data['Submissions'],
                                        data['Title'],
                                        data['Attachments'],
                                        doc.id,
                                        userId),
                                  )));
                    },
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(25, 10, 20, 10),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: kwhite,
                          boxShadow: [kboxshadow2],
                          borderRadius: kcircular),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              /*     Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: result <= 1 &&
                                                  data['status']
                                                          .toString()
                                                          .toLowerCase() ==
                                                      'submitted'
                                              ? Border.all(
                                                  color: Colors.green, width: 3)
                                              : result == 1 &&
                                                      data['status']
                                                              .toString()
                                                              .toLowerCase() ==
                                                          'pending'
                                                  ? Border.all(
                                                      color: Colors.red,
                                                      width: 3)
                                                  : Border.all(
                                                      color: kbutton, width: 3),
                                          color: _apptheme.getAppTheme ==
                                                  AppTheme.lightMode
                                              ? kwhite
                                              : kblack),
                                      child: result <= 1 &&
                                              data['status']
                                                      .toString()
                                                      .toLowerCase() ==
                                                  'submitted'
                                          ? const Icon(
                                              Icons.check,
                                              color: Colors.green,
                                            )
                                          : result == 1 &&
                                                  data['status']
                                                          .toString()
                                                          .toLowerCase() ==
                                                      'pending'
                                              ? const Icon(
                                                  Icons.cancel,
                                                  color: Colors.red,
                                                )
                                              : null,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),*/
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${data['Course-Name']}',
                                    style: GoogleFonts.roboto(
                                        color: _apptheme.getAppTheme ==
                                                AppTheme.lightMode
                                            ? kblack
                                            : Colors.white.withOpacity(0.7),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    '$kday $kmonth , $kyear',
                                    style: GoogleFonts.roboto(
                                        color: _apptheme.getAppTheme ==
                                                AppTheme.lightMode
                                            ? Colors.black.withOpacity(0.7)
                                            : Colors.white.withOpacity(0.7),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17),
                                  )
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ));
            }).toList());
          },
        ),
      ],
    );
  }

  Column pendingTasks(BuildContext context,
      Stream<QuerySnapshot<Object?>> _taskStream, ThemeProvide _apptheme) {
    return Column(
      children: [
        const SizedBox(
          height: 30,
        ),
        StreamBuilder<QuerySnapshot>(
          stream: _taskStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                  child: Text('An Error Occured',
                      style: _apptheme.getAppTheme.bodyLarge));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Column(
                children: snapshot.data!.docs.map((DocumentSnapshot doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              DateTime date = data['Due'].toDate();
              DateTime nowDating = DateTime.now();
              var result = nowDating.compareTo(date);
              String kday = date.day.toString();
              String kmonth = date.month.toString();
              String kyear = date.year.toString();
              String khour = date.hour.toString();
              String kminutes = date.minute.toString();
              switch (kmonth) {
                case '1':
                  kmonth = 'Jan';
                  break;
                case '2':
                  kmonth = 'Feb';
                  break;
                case '3':
                  kmonth = 'Mar';
                  break;
                case '4':
                  kmonth = 'Apr';
                  break;
                case '5':
                  kmonth = 'May';
                  break;
                case '6':
                  kmonth = 'Jun';
                  break;
                case '7':
                  kmonth = 'Jul';
                  break;
                case '8':
                  kmonth = 'Aug';
                  break;
                case '9':
                  kmonth = 'Sep';
                  break;
                case '10':
                  kmonth = 'Oct';
                  break;
                case '11':
                  kmonth = 'Nov';
                  break;
                case '12':
                  kmonth = 'Dec';
                  break;
              }
              String userSplit =
                  context.read<UserAuthenticator>().useremail().toString();
              String userId = userSplit.substring(0, userSplit.indexOf('@'));
              return Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: data['participants'].toString().contains(userId) ==
                          true
                      ? data['status'].toString().toLowerCase() == 'pending'
                          ? GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => StudentTaskPage(
                                              studentTaskForm: StudentTaskForm(
                                                  data['course name'],
                                                  '$kday $kmonth $kyear at $khour:$kminutes',
                                                  data['task description'],
                                                  data['task name'],
                                                  data['task title'],
                                                  data['Attachments'],
                                                  doc.id,
                                                  userId),
                                            )));
                              },
                              child: result == 1 &&
                                      data['status'].toString().toLowerCase() ==
                                          'pending'
                                  ? Container()
                                  : Container(
                                      margin: const EdgeInsets.fromLTRB(
                                          25, 10, 20, 10),
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                          color: kwhite,
                                          boxShadow: [kboxshadow2],
                                          borderRadius: kcircular),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                width: 50,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        color: kbutton,
                                                        width: 3),
                                                    color: _apptheme
                                                                .getAppTheme ==
                                                            AppTheme.lightMode
                                                        ? kwhite
                                                        : kblack),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${data['course name']} ${data['task name']}',
                                                    style: GoogleFonts.roboto(
                                                        color: _apptheme
                                                                    .getAppTheme ==
                                                                AppTheme
                                                                    .lightMode
                                                            ? kblack
                                                            : Colors.white
                                                                .withOpacity(
                                                                    0.7),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    '$kday $kmonth , $kyear',
                                                    style: GoogleFonts.roboto(
                                                        color: _apptheme
                                                                    .getAppTheme ==
                                                                AppTheme
                                                                    .lightMode
                                                            ? Colors.black
                                                                .withOpacity(
                                                                    0.7)
                                                            : Colors.white
                                                                .withOpacity(
                                                                    0.7),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 17),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                            )
                          : Container()
                      : Container());
            }).toList());
          },
        ),
      ],
    );
  }

  Container myToggleSwitch(ToggleProvider toggling, ThemeProvide _apptheme) {
    return Container(
      margin: const EdgeInsets.all(20),
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
          borderRadius: finalCircular,
          border: Border.all(color: ksecondary),
          color: kwhite),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  toggling.setIndex = 0;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOutBack,
                decoration: BoxDecoration(
                    color: toggling.getIndex == 0 ? ksecondary : kprimary,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(100),
                        bottomLeft: Radius.circular(100))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Pending',
                      style: _apptheme.getAppTheme.titleLarge,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  toggling.setIndex = 1;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.bounceInOut,
                decoration: BoxDecoration(
                    color: toggling.getIndex == 1 ? ksecondary : kprimary,
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(100),
                        bottomRight: Radius.circular(100))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Submitted',
                      style: _apptheme.getAppTheme.titleLarge,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
