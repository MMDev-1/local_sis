import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senior_project/Models/top_bar.dart';
import 'package:senior_project/Utils/constants.dart';
import 'package:senior_project/Utils/themes/app_theme.dart';
import 'package:senior_project/View-Model/providers/auth/userAuthenticator.dart';
import 'package:senior_project/View-Model/providers/public/theme_provider.dart';
import 'package:senior_project/View/student_ui/blog_page.dart';
import 'package:intl/intl.dart';

class StudentHome extends StatefulWidget {
  const StudentHome({Key? key}) : super(key: key);

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  
  @override
  void initState() {
    super.initState();
  }

  Future<String>? imageUrl;
  String? images;
  int index = 0;
  // ignore: prefer_typing_uninitialized_variables
  var ratingnum;

  bool isAssigned = false;
  @override
  Widget build(BuildContext context) {
    String userSplit = context.read<UserAuthenticator>().useremail().toString();
    String userId = userSplit.substring(0, userSplit.indexOf('@'));
    final Stream<QuerySnapshot> allBlogs =
        FirebaseFirestore.instance.collection('Blogs').snapshots();
    final Stream<QuerySnapshot> _data1 = FirebaseFirestore.instance
        .collection('Student')
        .where('ID', isEqualTo: int.parse(userId))
        .snapshots();

    var _appthemecontroller = Provider.of<ThemeProvide>(context);
    var _apptheme = _appthemecontroller.getAppTheme;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                log(userId.toString());
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Tasks',
                    style: _apptheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 180,
              child: StreamBuilder<QuerySnapshot>(
                stream: _data1,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
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

                  return Stack(
                      children: snapshot.data!.docs.map((DocumentSnapshot doc) {
                    Map<String, dynamic> data =
                        doc.data() as Map<String, dynamic>;
                    final Stream<QuerySnapshot> _data2 = FirebaseFirestore
                        .instance
                        .collection('Tasks')
                        .where('Participants-Class', isEqualTo: data['Grade'])
                        .snapshots();
                    return StreamBuilder<QuerySnapshot>(
                      stream: _data2,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot2) {
                        if (snapshot2.hasError) {
                          return const Center(
                              child: Text(
                            'An Error Occured',
                          ));
                        }
                        if (snapshot2.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        Future.delayed(const Duration(seconds: 2), () {});
                        return ListView(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            children: snapshot2.data!.docs
                                .map((DocumentSnapshot doc2) {
                              Map<String, dynamic> data2 =
                                  doc2.data() as Map<String, dynamic>;
                              DateTime date = data2['Due'].toDate();
                              DateTime nowDating = DateTime.now();
                              var result = nowDating.compareTo(date);
                              String kday = date.day.toString();
                              String kmonth = date.month.toString();
                              String kyear = date.year.toString();
                              String khour = date.hour.toString();
                              String kminutes = date.minute.toString();
                              String formattedDate =
                                  DateFormat('EEEE').format(date);
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  height: 180,
                                  width: 300,
                                  decoration: BoxDecoration(
                                      gradient: kmix, borderRadius: kcircular),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            data2['Course-Name'],
                                            style: _apptheme.titleMedium,
                                          ),
                                          Text(
                                            '$formattedDate ${kday}th,$kyear',
                                            style: _apptheme.titleSmall,
                                          ),
                                        ],
                                      ),
                                      Text(
                                        data2['Participants-Class'].toString(),
                                        textAlign: TextAlign.left,
                                        style: _apptheme.titleSmall,
                                      ),
                                      Text(
                                        data2['Description'],
                                        textAlign: TextAlign.left,
                                        style: _apptheme.titleSmall,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList());
                      },
                    );
                  }).toList());
                },
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
