import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:senior_project/Utils/constants.dart';
import 'package:senior_project/View-Model/providers/auth/userAuthenticator.dart';
import 'package:senior_project/View-Model/providers/public/theme_provider.dart';
import 'package:senior_project/View-Model/providers/router/teacher_classes_provider.dart';
import 'package:senior_project/View/teacher_ui/attendance.dart';

class TeacherClasses extends StatefulWidget {
  const TeacherClasses({Key? key}) : super(key: key);

  @override
  State<TeacherClasses> createState() => _TeacherClassesState();
}

class _TeacherClassesState extends State<TeacherClasses> {
  @override
  Widget build(BuildContext context) {
    var _appthemecontroller = Provider.of<ThemeProvide>(context);
    var _apptheme = _appthemecontroller.getAppTheme;
    String userSplit = context.read<UserAuthenticator>().useremail().toString();
    String userId = userSplit.substring(0, userSplit.indexOf('@'));
    final Stream<QuerySnapshot> _teacherClasses = FirebaseFirestore.instance
        .collection('Courses')
        .where('Teacher-ID', isEqualTo: userId)
        .snapshots();
    return SingleChildScrollView(
      child: StreamBuilder<QuerySnapshot>(
        stream: _teacherClasses,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'An Error have Occured!',
                style: _apptheme.bodyLarge,
              ),
            );
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
                context.read<ClassesProvider>().setGrade = data['Participants'];
                context.read<ClassesProvider>().setName = data['Course-Name'];
                context.read<ClassesProvider>().setlName = data['Teacher-ID'];

                Navigator.pushNamed(context, 'teacher_router');
              },
              child: Container(
                height: 120,
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(left: 20, bottom: 20, right: 20),
                padding: const EdgeInsets.all(20.0),
                decoration:
                    BoxDecoration(gradient: kmix, borderRadius: kcircular),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['Course-Name'],
                      style: GoogleFonts.roboto(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Grade ${data['Participants']}',
                      style: GoogleFonts.roboto(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            );
          }).toList());
        },
      ),
    );
  }
}
