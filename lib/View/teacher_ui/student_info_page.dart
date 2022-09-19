import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:senior_project/Models/student_info.dart';
import 'package:senior_project/Utils/constants.dart';
import 'package:senior_project/Utils/themes/app_theme.dart';
import 'package:senior_project/View-Model/providers/public/theme_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentInfoPage extends StatefulWidget {
  StudentInfoPage({Key? key, required this.thestudent}) : super(key: key);
  Student thestudent;
  @override
  State<StudentInfoPage> createState() => _StudentInfoPageState();
}

class _StudentInfoPageState extends State<StudentInfoPage> {
  @override
  Widget build(BuildContext context) {
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
        child: Stack(
          children: [
            Container(
              color: _apptheme.getAppTheme == AppTheme.lightMode
                  ? kprimary
                  : darkModeBackground,
              height: MediaQuery.of(context).size.height,
              child: Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.15),
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
                        widget.thestudent.name,
                        style: _apptheme.getAppTheme.bodyMedium,
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      Text(
                        '@ ${widget.thestudent.id}',
                        style: _apptheme.getAppTheme.bodyMedium,
                      ),
                      const SizedBox(
                        height: 7,
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
                        '${widget.thestudent.name} ${widget.thestudent.lname}',
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
                        widget.thestudent.grade,
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
                        widget.thestudent.birthdate,
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
                        widget.thestudent.phone,
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
                        widget.thestudent.email,
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
                        widget.thestudent.address,
                        style: _apptheme.getAppTheme.bodyMedium,
                      )
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      gradient: kmix, borderRadius: kbottomcircular),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.call,
                        color: kwhite,
                      ),
                      MaterialButton(
                        onPressed: () async {
                          launch('tel:${widget.thestudent.phone}');
                        },
                        child: Text(
                          'Call Now',
                          style: GoogleFonts.roboto(
                              color: kwhite,
                              fontWeight: FontWeight.bold,
                              fontSize: 25),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
