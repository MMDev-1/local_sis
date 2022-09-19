import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:senior_project/Models/student_petition.dart';
import 'package:senior_project/Repo/api_petitions.dart';
import 'package:senior_project/Utils/constants.dart';
import 'package:senior_project/Utils/themes/app_theme.dart';
import 'package:senior_project/View-Model/providers/auth/userAuthenticator.dart';
import 'package:senior_project/View-Model/providers/public/theme_provider.dart';

class StudentLeaves extends StatefulWidget {
  const StudentLeaves({Key? key}) : super(key: key);

  @override
  State<StudentLeaves> createState() => _StudentLeavesState();
}

class _StudentLeavesState extends State<StudentLeaves> {
  PeititonsApi service = PeititonsApi();

  @override
  Widget build(BuildContext context) {
    String userSplit = context.read<UserAuthenticator>().useremail().toString();
    String userId = userSplit.substring(0, userSplit.indexOf('@'));
    var _apptheme = Provider.of<ThemeProvide>(context);
    final Stream<QuerySnapshot> _studentPetitions = FirebaseFirestore.instance
        .collection('Petitions')
        .where('student id', isEqualTo: userId)
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
          child: Container(
            color: _apptheme.getAppTheme == AppTheme.lightMode
                ? Theme.of(context).scaffoldBackgroundColor
                : darkModeBackground,
            child: StreamBuilder<QuerySnapshot>(
              stream: _studentPetitions,
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
                  return SizedBox(
                    height: MediaQuery.of(context).size.height / 1.5,
                    width: double.infinity,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: kprimary,
                      ),
                    ),
                  );
                }
                return Column(
                    children: snapshot.data!.docs.map((DocumentSnapshot doc) {
                  Map<String, dynamic> petitions =
                      doc.data() as Map<String, dynamic>;
                  return studentLeaves(_apptheme, petitions);
                }).toList());
              },
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: _apptheme.getAppTheme == AppTheme.lightMode
              ? kbutton
              : darkModeContainers,
          onPressed: () =>
              Navigator.pushNamed(context, 'student_leave_request'),
          child: Icon(
            Icons.add,
            color: kwhite,
            size: 30,
          ),
        ),
      ),
    );
  }

  Column studentLeaves(ThemeProvide _apptheme, Map<String, dynamic> petitions) {
    return Column(
      children: [
        Container(
          height: 200,
          margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          padding: const EdgeInsets.all(15.0),
          width: double.infinity,
          decoration: BoxDecoration(
              color: _apptheme.getAppTheme == AppTheme.lightMode
                  ? ksecondary
                  : darkModeContainers,
              borderRadius: kcircular),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    petitions['cause'],
                    style: _apptheme.getAppTheme.titleLarge,
                  ),
                  const Spacer(),
                  Text(
                    '${petitions['from date']} - ${petitions['to date']}',
                    style: _apptheme.getAppTheme.titleSmall,
                  ),
                  const Spacer(
                    flex: 2,
                  ),
                  Text(
                    petitions['type'],
                    style: _apptheme.getAppTheme.titleLarge,
                  )
                ],
              ),
              const Spacer(),
              Container(
                height: 40,
                width: 90,
                decoration: BoxDecoration(
                    borderRadius: kmaximumCircular,
                    color: _apptheme.getAppTheme == AppTheme.lightMode
                        ? Theme.of(context).scaffoldBackgroundColor
                        : kwhite),
                child: Center(
                  child: Text(
                    petitions['status'],
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w700,
                      color: kblack,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
