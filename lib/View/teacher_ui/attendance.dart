import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:senior_project/Models/student_absence.dart';
import 'package:senior_project/Utils/constants.dart';
import 'package:senior_project/Utils/themes/app_theme.dart';
import 'package:senior_project/View-Model/providers/public/theme_provider.dart';
import 'package:switcher_button/switcher_button.dart';

// ignore: must_be_immutable
class Attendance extends StatefulWidget {
  Attendance({Key? key, required this.grade}) : super(key: key);
  String grade;
  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  Absence abs = Absence('studentName', DateTime.now());
  List<String> students = [''];
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _studentSchedule = FirebaseFirestore.instance
        .collection('Student')
        .where('Grade', isEqualTo: widget.grade.toString())
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
        actions: [
          TextButton(
              onPressed: () {
                if (abs.studentName != 'studentName' || abs.studentName != '') {
                  for (var i = 0; i <= students.length - 1; i++) {
                    abs.studentName = students[i];
                    if (abs.studentName.isEmpty == false) {
                      abs.setAbsence();
                    }
                  }
                }
              },
              child: Text(
                'Save',
                style: GoogleFonts.roboto(
                    color: kprimary, fontSize: 20, fontWeight: FontWeight.bold),
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
          stream: _studentSchedule,
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
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              return Container(
                height: 100,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: kcircular,
                  gradient: kmix,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: kwhite,
                      child: Text(
                        '${data['First-Name'].toString().substring(0, 1)}${data['Last-Name'].toString().substring(0, 1)}',
                        style: _apptheme.getAppTheme.bodyMedium,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${data['First-Name']} ${data['Last-Name']}',
                          style: GoogleFonts.roboto(
                              color: kwhite,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(data['ID'].toString(),
                            style: GoogleFonts.roboto(
                                color: kwhite,
                                fontSize: 16,
                                fontWeight: FontWeight.w700))
                      ],
                    ),
                    const Spacer(),
                    SwitcherButton(
                      value: true,
                      onChange: (value) {
                        log(value.toString());
                        if (value == false) {
                          abs.studentName =
                              '${data['First-Name']} ${data['Last-Name']}';
                          students.add(abs.studentName);
                        }
                      },
                    )
                  ],
                ),
              );
            }).toList());
          },
        ),
      ),
    ));
  }
}
