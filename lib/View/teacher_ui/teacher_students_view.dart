import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:senior_project/Models/student_info.dart';
import 'package:senior_project/Utils/constants.dart';
import 'package:senior_project/Utils/themes/app_theme.dart';
import 'package:senior_project/View-Model/providers/public/theme_provider.dart';
import 'package:senior_project/View/teacher_ui/student_info_page.dart';

class TeacherStudentsView extends StatefulWidget {
  TeacherStudentsView({Key? key, required this.grade}) : super(key: key);
  String grade;
  @override
  State<TeacherStudentsView> createState() => _TeacherStudentsViewState();
}

class _TeacherStudentsViewState extends State<TeacherStudentsView> {
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
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => StudentInfoPage(
                              thestudent: Student(
                                  data['email'],
                                  data['Birth-Date'],
                                  data['Address'],
                                  data['Grade'],
                                  data['ID'],
                                  data['First-Name'],
                                  data['Primary-Number'],
                                  data['Last-Name'],['0']))));
                },
                child: Container(
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
                    ],
                  ),
                ),
              );
            }).toList());
          },
        ),
      ),
    ));
  }
}
