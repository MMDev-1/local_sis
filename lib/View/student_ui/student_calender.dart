import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_week/flutter_calendar_week.dart';
import 'package:provider/provider.dart';
import 'package:senior_project/Models/books.dart';
import 'package:senior_project/Models/student_info.dart';
import 'package:senior_project/Utils/constants.dart';
import 'package:senior_project/Utils/themes/app_theme.dart';
import 'package:senior_project/View-Model/logic/streamUser.dart';
import 'package:senior_project/View-Model/providers/auth/userAuthenticator.dart';
import 'package:senior_project/View-Model/providers/public/theme_provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';

class StudentCalender extends StatefulWidget {
  StudentCalender({Key? key, required this.grade}) : super(key: key);
  String grade;
  @override
  State<StudentCalender> createState() => _StudentCalenderState();
}

class _StudentCalenderState extends State<StudentCalender> {
  final CalendarWeekController _controller = CalendarWeekController();
  var months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  @override
  void iniState() {
    super.initState();
    log('message');
  }

  UserStreaming us = UserStreaming();

  @override
  Widget build(BuildContext context) {
    var _appthemecontroller = Provider.of<ThemeProvide>(context);
    final _apptheme = _appthemecontroller.getAppTheme;
    var size = MediaQuery.of(context).size;
    bool isAssigned = false;
    final Stream<QuerySnapshot> _studentSchedule = FirebaseFirestore.instance
        .collection('Courses')
        .where('Participants', isEqualTo: widget.grade.toString())
        .snapshots();

    return SafeArea(
      child: Scaffold(
        backgroundColor: _apptheme == AppTheme.lightMode
            ? Theme.of(context).scaffoldBackgroundColor
            : kblack,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: _apptheme == AppTheme.lightMode
              ? Theme.of(context).scaffoldBackgroundColor
              : darkModeBackground,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios_sharp,
                size: 30, color: _apptheme.bodyLarge.color),
          ),
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          CalendarWeek(
            backgroundColor: _apptheme == AppTheme.lightMode
                ? Theme.of(context).scaffoldBackgroundColor
                : kblack,
            controller: _controller,
            height: MediaQuery.of(context).size.height / 7,
            showMonth: false,
            weekendsStyle: TextStyle(
                color: _apptheme == AppTheme.lightMode ? kblack : kwhite),
            dayOfWeekStyle: TextStyle(
                color: _apptheme == AppTheme.lightMode ? kblack : kwhite),
            todayDateStyle: TextStyle(color: kwhite),
            pressedDateStyle: TextStyle(color: kwhite),
            dateStyle: TextStyle(
                color: _apptheme == AppTheme.lightMode ? kblack : kwhite),
            minDate: DateTime.now().add(
              const Duration(days: -365),
            ),
            maxDate: DateTime.now().add(
              const Duration(days: 365),
            ),
            onDatePressed: (DateTime datetime) {
              // Do something
              setState(() {});
            },
            onDateLongPressed: (DateTime datetime) {
              // Do something
            },
            onWeekChanged: () {},
            decorations: [
              DecorationItem(
                  decorationAlignment: FractionalOffset.bottomRight,
                  date: DateTime.now(),
                  decoration: Icon(
                    Icons.today,
                    color: ksecondary,
                  )),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 10),
            child: Text(
              '${_controller.selectedDate.day.toString()}  ${months[_controller.selectedDate.month - 1]} ${_controller.selectedDate.year.toString()}',
              style: _apptheme.bodyMedium,
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: _studentSchedule,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'An Error have Occured!',
                    style: _apptheme.getAppTheme.bodyLarge,
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey.withOpacity(0.7),
                  highlightColor: Colors.black.withOpacity(0.04),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          width: size.width,
                          height: MediaQuery.of(context).size.height / 4.4,
                          decoration: _apptheme == AppTheme.lightMode
                              ? BoxDecoration(
                                  gradient: kmix, borderRadius: kcircular)
                              : BoxDecoration(
                                  color: darkModeContainers,
                                  borderRadius: kcircular),
                        )
                      ],
                    ),
                  ),
                );
              }
              return Column(
                  children: snapshot.data!.docs.map((DocumentSnapshot doc) {
                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                List studentDays = data['Timeline'];
                String? studentTimes;

                DateTime nows = _controller.selectedDate;
                String formattedDate = DateFormat('EEEE').format(nows);
                if (studentDays.isNotEmpty &&
                    studentDays[0].toString().contains('Mon') &&
                    formattedDate == 'Monday') {
                  studentTimes = studentDays[0].toString().substring(
                      studentDays.toString().indexOf('-'),
                      studentDays[0].toString().length);
                  isAssigned = true;
                } else if (studentDays.length >= 2 &&
                    studentDays[1].toString().contains('Tue') &&
                    formattedDate == 'Tuesday') {
                  studentTimes = studentDays[1].toString().substring(
                      studentDays.toString().indexOf('-') + 1,
                      studentDays[1].toString().length);
                  isAssigned = true;
                } else if (studentDays.length >= 3 &&
                    studentDays[2].toString().contains('Wed') &&
                    formattedDate == 'Wednesday') {
                  studentTimes = studentDays[2].toString().substring(
                      studentDays.toString().indexOf('-') + 3,
                      studentDays[2].toString().length);
                  isAssigned = true;
                } else if (studentDays.length >= 4 &&
                    studentDays[3].toString().contains('Thur') &&
                    formattedDate == 'Thursday') {
                  studentTimes = studentDays[3].toString().substring(
                      studentDays.toString().indexOf('-') + 2,
                      studentDays[3].toString().length);
                  isAssigned = true;
                } else if (studentDays.length >= 5 &&
                    studentDays[4].toString().contains('Fri') &&
                    formattedDate == 'Friday') {
                  studentTimes = studentDays[4].toString().substring(
                      studentDays.toString().indexOf('-'),
                      studentDays[4].toString().length);
                  isAssigned = true;
                } else if (studentDays.length >= 6 &&
                    studentDays[5].toString().contains('Sat') &&
                    formattedDate == 'Saturday') {
                  studentTimes = studentDays[5].toString().substring(
                      studentDays.toString().indexOf('-'),
                      studentDays[5].toString().length);
                  isAssigned = true;
                } else if (studentDays.length >= 7 &&
                    studentDays[6].toString().contains('Sun') &&
                    formattedDate == 'Sunday') {
                  studentTimes = studentDays[6].toString().substring(
                      studentDays.toString().indexOf('-'),
                      studentDays[6].toString().length);
                  isAssigned = true;
                }

                return isAssigned == true
                    ? scheduleBody(studentTimes, size, context, _apptheme, data)
                    : noMeetingsBody(size, _apptheme);
              }).toList());
            },
          ),
        ]),
      ),
    );
  }

  Padding scheduleBody(String? studentTimes, Size size, BuildContext context,
      _apptheme, Map<String, dynamic> data) {
    return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: studentTimes != null
            ? Container(
                padding: const EdgeInsets.all(15),
                width: size.width,
                height: MediaQuery.of(context).size.height / 5.2,
                decoration: _apptheme == AppTheme.lightMode
                    ? BoxDecoration(gradient: kmix, borderRadius: kcircular)
                    : BoxDecoration(
                        color: darkModeContainers, borderRadius: kcircular),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          data['Course-Name'],
                          style: TextStyle(
                              color: kwhite,
                              fontWeight: FontWeight.w500,
                              fontSize: _apptheme.bodyMedium.fontSize),
                        ),
                        Text(
                          studentTimes,
                          style: TextStyle(
                              color: kwhite.withOpacity(0.8),
                              fontWeight: FontWeight.w500,
                              fontSize: _apptheme.bodySmall.fontSize),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: size.width / 2.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: kwhite,
                            child: Text(
                              data['Participants'],
                              style: TextStyle(
                                  fontWeight: _apptheme.bodyLarge.fontWeight,
                                  fontSize: _apptheme.bodySmall.fontSize,
                                  color: _apptheme == AppTheme.lightMode
                                      ? ksecondary
                                      : kblack),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            : Container());
  }

  Padding noMeetingsBody(Size size, _apptheme) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Container(
        width: size.width,
        height: 75,
        decoration: _apptheme == AppTheme.lightMode
            ? BoxDecoration(gradient: kmix, borderRadius: kcircular)
            : BoxDecoration(color: darkModeContainers, borderRadius: kcircular),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              width: 13,
            ),
            Container(
              width: 10,
              height: 45,
              decoration: BoxDecoration(
                color: kwhite,
                borderRadius: kmaximumCircular,
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              'No Meetings',
              style: TextStyle(
                  color: kwhite,
                  fontSize: 25,
                  fontWeight: _apptheme.headlineLarge.fontWeight),
            )
          ],
        ),
      ),
    );
  }
}
