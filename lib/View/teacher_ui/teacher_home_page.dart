import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senior_project/Utils/constants.dart';
import 'package:senior_project/Utils/themes/app_theme.dart';
import 'package:senior_project/View-Model/providers/auth/userAuthenticator.dart';
import 'package:senior_project/View-Model/providers/public/theme_provider.dart';
import 'package:senior_project/View/student_ui/blog_page.dart';
import 'package:intl/intl.dart';

class TeacherHome extends StatefulWidget {
  const TeacherHome({Key? key}) : super(key: key);

  @override
  State<TeacherHome> createState() => _TeacherHomeState();
}

class _TeacherHomeState extends State<TeacherHome> {
  Future<String>? imageUrl;
  String? images;
  int index = 0;
  // ignore: prefer_typing_uninitialized_variables
  var ratingnum;
  final Stream<QuerySnapshot> allBlogs =
      FirebaseFirestore.instance.collection('Blogs').snapshots();
  bool isAssigned = false;
  @override
  Widget build(BuildContext context) {
    var _appthemecontroller = Provider.of<ThemeProvide>(context);
    var _apptheme = _appthemecontroller.getAppTheme;
    String userSplit = context.read<UserAuthenticator>().useremail().toString();
    String userId = userSplit.substring(0, userSplit.indexOf('@'));
    final Stream<QuerySnapshot> _teacherHomePageSchedule = FirebaseFirestore
        .instance
        .collection('Courses')
        .where('Teacher-ID', isEqualTo: userId)
        .snapshots();
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Today Classes',
                  style: _apptheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            index == 0
                ? StreamBuilder<QuerySnapshot>(
                    stream: _teacherHomePageSchedule,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text('An Error has Occured'),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return GestureDetector(
                        onTap: () {
                          DateTime nows = DateTime.now();
                          String formattedDate =
                              DateFormat('EEEE').format(nows);
                          log(formattedDate);
                        },
                        child: SizedBox(
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          child: ListView(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              children: snapshot.data!.docs
                                  .map((DocumentSnapshot doc) {
                                Map<String, dynamic> data =
                                    doc.data() as Map<String, dynamic>;
                                List studentDays = data['Timeline'];
                                String? studentTimes;

                                DateTime nows = DateTime.now();
                                String formattedDate =
                                    DateFormat('EEEE').format(nows);
                                for (var i = 0;
                                    i <= studentDays.length - 1;
                                    i++) {
                                  if (studentDays[i]
                                          .toString()
                                          .contains('Mon') &&
                                      formattedDate == 'Monday') {
                                    studentTimes = studentDays[i]
                                        .toString()
                                        .substring(
                                            studentDays.toString().indexOf('-'),
                                            studentDays[i].toString().length);
                                    isAssigned = true;
                                  } else if (studentDays[i]
                                          .toString()
                                          .contains('Tue') &&
                                      formattedDate == 'Tuesday') {
                                    studentTimes = studentDays[i]
                                        .toString()
                                        .substring(
                                            studentDays
                                                    .toString()
                                                    .indexOf('-') +
                                                1,
                                            studentDays[i].toString().length);
                                    isAssigned = true;
                                  } else if (studentDays[i]
                                          .toString()
                                          .contains('Wed') &&
                                      formattedDate == 'Wednesday') {
                                    studentTimes = studentDays[i]
                                        .toString()
                                        .substring(
                                            studentDays
                                                    .toString()
                                                    .indexOf('-') +
                                                3,
                                            studentDays[i].toString().length);
                                    isAssigned = true;
                                  } else if (studentDays[i]
                                          .toString()
                                          .contains('Thur') &&
                                      formattedDate == 'Thursday') {
                                    studentTimes = studentDays[i]
                                        .toString()
                                        .substring(
                                            studentDays
                                                    .toString()
                                                    .indexOf('-') +
                                                2,
                                            studentDays[i].toString().length);
                                    isAssigned = true;
                                  } else if (studentDays[i]
                                          .toString()
                                          .contains('Fri') &&
                                      formattedDate == 'Friday') {
                                    studentTimes = studentDays[i]
                                        .toString()
                                        .substring(
                                            studentDays.toString().indexOf('-'),
                                            studentDays[i].toString().length);
                                    isAssigned = true;
                                  } else if (studentDays[i]
                                          .toString()
                                          .contains('Sat') &&
                                      formattedDate == 'Saturday') {
                                    log('Saturdayyyyy');
                                    isAssigned = true;
                                    log('Saturday Assign $isAssigned');
                                    studentTimes = studentDays[i]
                                        .toString()
                                        .substring(
                                            0,
                                            studentDays
                                                    .toString()
                                                    .indexOf('-') +
                                                1);
                                    log(studentTimes);
                                    log(formattedDate);
                                  } else if (studentDays[i]
                                          .toString()
                                          .contains('Sun') &&
                                      formattedDate == 'Sunday') {
                                    studentTimes = studentDays[i]
                                        .toString()
                                        .substring(
                                            studentDays.toString().indexOf('-'),
                                            studentDays[i].toString().length);
                                    isAssigned = true;
                                  }
                                }
                                if (isAssigned == false) {
                                  if (index <= 1) {
                                    index++;
                                  }
                                }
                                return isAssigned == true
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          padding: const EdgeInsets.all(20),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.15,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              5.2,
                                          decoration:
                                              _apptheme == AppTheme.lightMode
                                                  ? BoxDecoration(
                                                      gradient: kmix,
                                                      borderRadius: kcircular)
                                                  : BoxDecoration(
                                                      color: darkModeContainers,
                                                      borderRadius: kcircular),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    data['Course-Name'],
                                                    style: TextStyle(
                                                        color: kwhite,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: _apptheme
                                                            .bodyMedium
                                                            .fontSize),
                                                  ),
                                                  Text(
                                                    studentTimes!,
                                                    style: TextStyle(
                                                        color: kwhite
                                                            .withOpacity(0.8),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: _apptheme
                                                            .bodySmall
                                                            .fontSize),
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
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2.0,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 20,
                                                      backgroundColor: kwhite,
                                                      child: Text(
                                                        data['Participants'],
                                                        style: TextStyle(
                                                            fontWeight:
                                                                _apptheme
                                                                    .bodyLarge
                                                                    .fontWeight,
                                                            fontSize: _apptheme
                                                                .bodySmall
                                                                .fontSize,
                                                            color: _apptheme ==
                                                                    AppTheme
                                                                        .lightMode
                                                                ? ksecondary
                                                                : kblack),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    : Container(); //First Container Ending
                              }).toList()),
                        ),
                      );
                    },
                  )
                : Container(
                    width: MediaQuery.of(context).size.width,
                    height: 75,
                    decoration: _apptheme == AppTheme.lightMode
                        ? BoxDecoration(gradient: kmix, borderRadius: kcircular)
                        : BoxDecoration(
                            color: darkModeContainers, borderRadius: kcircular),
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
                          'Today is a Holiday :)',
                          style: TextStyle(
                              color: kwhite,
                              fontSize: 25,
                              fontWeight: _apptheme.headlineLarge.fontWeight),
                        )
                      ],
                    ),
                  ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Popular Blogs',
              style: _apptheme.bodyMedium,
            ),
            const SizedBox(
              height: 20,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: allBlogs,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
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
                  Map<String, dynamic> data =
                      doc.data() as Map<String, dynamic>;
                  Future<void> getImageUrl() async {
                    final ref =
                        FirebaseStorage.instance.ref().child(data['image']);
                    imageUrl = ref.getDownloadURL();
                    images = await ref.getDownloadURL();
                  }

                  ratingnum = data['rating'];
                  double ratingtotal =
                      double.parse(ratingnum.toStringAsFixed(1));
                  return data['ispopular'] == true
                      ? GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BlogPage(
                                        docId: doc.id,
                                        image: data['image'],
                                        date: data['history'],
                                        title: data['title'],
                                        body: data['body'],
                                        publisher: data['publisher'],
                                        rating: ratingtotal,
                                        raters: data['Raters'])));
                          },
                          child: Container(
                            height: 180,
                            margin: const EdgeInsets.only(bottom: 15),
                            decoration: BoxDecoration(
                                borderRadius: kcircular,
                                color: Colors.transparent),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                    flex: 1,
                                    child: Stack(
                                      children: [
                                        FutureBuilder(
                                          future: getImageUrl(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot snapshot) {
                                            if (snapshot.hasError) {
                                              return Center(
                                                child: Text(
                                                  'An Error has occured!',
                                                  style: _apptheme.bodyLarge,
                                                ),
                                              );
                                            }
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            }
                                            return Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: kcircular,
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          images.toString()),
                                                      fit: BoxFit.cover)),
                                            );
                                          },
                                        ),
                                      ],
                                    )),
                                Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 18, top: 20, bottom: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            data['history'],
                                            style: _apptheme.bodySmall,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            data['title'],
                                            style: _apptheme.headlineSmall,
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                ratingtotal.toString(),
                                                style: _apptheme.bodySmall,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Icon(
                                                Icons.star,
                                                color:
                                                    _apptheme.bodySmall!.color,
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        )
                      : Container();
                }).toList());
              },
            ),
          ],
        ),
      ),
    );
  }
}
