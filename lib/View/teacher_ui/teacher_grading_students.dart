import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:senior_project/Models/student_grades_upload.dart';
import 'package:senior_project/Utils/constants.dart';
import 'package:senior_project/Utils/themes/app_theme.dart';
import 'package:senior_project/View-Model/providers/public/theme_provider.dart';
import 'package:senior_project/View-Model/providers/router/grade_provider_id.dart';

class StudentGrading extends StatefulWidget {
  const StudentGrading({Key? key}) : super(key: key);

  @override
  State<StudentGrading> createState() => _StudentGradingState();
}

class _StudentGradingState extends State<StudentGrading> {
  UploadStudentGrades _uploadStudentGrades = UploadStudentGrades(0);

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _grading = FirebaseFirestore.instance
        .collection('Tasks')
        .doc(context.read<GradeProviderId>().getdocId)
        .collection('Results')
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
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
          stream: _grading,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                children: snapshot.data!.docs.map((DocumentSnapshot doc) {
              final TextEditingController _gradesController =
                  TextEditingController();
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

              final Stream<QuerySnapshot> _grades = FirebaseFirestore.instance
                  .collection('Student')
                  .where('ID', isEqualTo: int.parse(doc.id))
                  .snapshots();

              return Column(
                children: [
                  Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        StreamBuilder<QuerySnapshot>(
                          stream: _grades,
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return const Center(
                                  child: Text(
                                'An Error Occured',
                              ));
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return Column(
                                children: snapshot.data!.docs
                                    .map((DocumentSnapshot docs) {
                              Map<String, dynamic> datas =
                                  docs.data() as Map<String, dynamic>;
                              return CircleAvatar(
                                radius: 25,
                                backgroundColor: kprimary,
                                child: Center(
                                  child: Text(
                                    '${datas['First-Name'].toString().substring(0, 1)}${datas['Last-Name'].toString().substring(0, 1)}',
                                    style: GoogleFonts.roboto(
                                        color: kwhite,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              );
                            }).toList());
                          },
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: _grades,
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return const Center(
                                  child: Text(
                                'An Error Occured',
                              ));
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return Column(
                                children: snapshot.data!.docs
                                    .map((DocumentSnapshot docs) {
                              Map<String, dynamic> datas =
                                  docs.data() as Map<String, dynamic>;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      '${datas['First-Name']} ${datas['Last-Name']}',
                                      style: _apptheme.getAppTheme.bodyMedium),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(doc.id.toString(),
                                      style: _apptheme.getAppTheme.bodyMedium)
                                ],
                              );
                            }).toList());
                          },
                        ),
                        const Spacer(),
                        data['Score'] != null && data['Score'] > 0
                            ? Text(
                                data['Score'].toString(),
                                style: GoogleFonts.roboto(
                                    fontSize: _apptheme
                                        .getAppTheme.bodyMedium.fontSize,
                                    fontWeight: _apptheme
                                        .getAppTheme.bodyMedium.fontWeight,
                                    color: data['Score'] < 50
                                        ? Colors.red
                                        : data['Score'] < 70
                                            ? Colors.yellow
                                            : Colors.green),
                              )
                            : SizedBox(
                                height: 50,
                                width: 76,
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  controller: _gradesController,
                                  onSubmitted: (text) {
                                    _uploadStudentGrades.score =
                                        text.isNotEmpty ? int.parse(text) : 0;
                                    _uploadStudentGrades.uploadGrades(
                                        context, doc.id);
                                  },
                                  decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(width: 1, color: kblack),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(width: 1, color: kblack),
                                        borderRadius: BorderRadius.circular(5),
                                      )),
                                ),
                              ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Divider(
                      thickness: 2,
                    ),
                  )
                ],
              );
            }).toList());
          },
        ),
      ),
    ));
  }
}
