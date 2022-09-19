import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:senior_project/Utils/constants.dart';
import 'package:senior_project/Utils/themes/app_theme.dart';
import 'package:senior_project/View-Model/providers/public/theme_provider.dart';
import 'package:senior_project/View-Model/providers/router/grade_provider_id.dart';
import 'package:senior_project/View-Model/providers/router/teacher_classes_provider.dart';
import 'package:intl/intl.dart';
import 'package:senior_project/View/teacher_ui/teacher_grading_students.dart';

class TeacherGrades extends StatefulWidget {
  const TeacherGrades({Key? key}) : super(key: key);

  @override
  State<TeacherGrades> createState() => _TeacherGradesState();
}

class _TeacherGradesState extends State<TeacherGrades> {
  @override
  Widget build(BuildContext context) {
    var _apptheme = Provider.of<ThemeProvide>(context);
    String grade = context.read<ClassesProvider>().getGrade;
    final Stream<QuerySnapshot> _teachergrads = FirebaseFirestore.instance
        .collection('Tasks')
        .where('Participants-Class', isEqualTo: grade)
        .snapshots();
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 5),
                child: Text(
                  'Grade $grade',
                  style: _apptheme.getAppTheme.bodyLarge,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 10, bottom: 10),
                child: Divider(
                  color: kblack,
                  thickness: 2,
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: _teachergrads,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Error'),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return Column(
                      children: snapshot.data!.docs.map((DocumentSnapshot doc) {
                    Map<String, dynamic> data =
                        doc.data() as Map<String, dynamic>;

                    DateTime postDate = data['Start'].toDate();
                    String monthPosted = DateFormat('EEEE').format(postDate);
                    String postedDate = monthPosted;
                    String postedDates =
                        '${postDate.day.toString()} $postedDate ${postDate.year.toString()}';
                    return GestureDetector(
                      onTap: () {
                        context.read<GradeProviderId>().setdocId = doc.id;
                        log(context
                            .read<GradeProviderId>()
                            .getdocId
                            .toString());
                        Navigator.pushNamed(context, 'grades_for_students');
                      },
                      child: Container(
                        height: 110,
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(
                            left: 20, right: 10, bottom: 15),
                        decoration: BoxDecoration(
                            borderRadius: kcircular, gradient: kmix),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: kwhite),
                              child: Icon(
                                Icons.task,
                                color: kprimary,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Spacer(),
                                Text(
                                  data['Course-Name'],
                                  style: GoogleFonts.roboto(
                                    fontSize: _apptheme
                                        .getAppTheme.bodyMedium.fontSize,
                                    fontWeight: _apptheme
                                        .getAppTheme.bodyMedium.fontWeight,
                                    color: kwhite,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  postedDates,
                                  style: GoogleFonts.roboto(
                                    fontSize: _apptheme
                                        .getAppTheme.bodyMedium.fontSize,
                                    fontWeight: _apptheme
                                        .getAppTheme.bodyMedium.fontWeight,
                                    color: kwhite.withOpacity(0.7),
                                  ),
                                ),
                                const Spacer(),
                              ],
                            ),
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
    );
  }
}
