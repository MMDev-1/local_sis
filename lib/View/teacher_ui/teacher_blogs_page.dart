import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:senior_project/Utils/constants.dart';
import 'package:senior_project/Utils/themes/app_theme.dart';
import 'package:senior_project/View-Model/providers/auth/userAuthenticator.dart';
import 'package:senior_project/View-Model/providers/public/theme_provider.dart';
import 'package:senior_project/View/student_ui/blog_page.dart';
import 'package:shimmer/shimmer.dart';

class TeacherBlogsPage extends StatefulWidget {
  const TeacherBlogsPage({Key? key}) : super(key: key);

  @override
  State<TeacherBlogsPage> createState() => _TeacherBlogsPageState();
}

class _TeacherBlogsPageState extends State<TeacherBlogsPage> {
  Future<String>? imageUrl;
  String? images;
  var _ratingnum;
  @override
  Widget build(BuildContext context) {
    var _appthemecontroller = Provider.of<ThemeProvide>(context);
    var _apptheme = _appthemecontroller.getAppTheme;
    final Stream<QuerySnapshot> AllBllogs =
        FirebaseFirestore.instance.collection('Blogs').snapshots();
    return SafeArea(
      child: Scaffold(
        backgroundColor: _apptheme == AppTheme.lightMode
            ? Theme.of(context).scaffoldBackgroundColor
            : darkModeBackground,
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
        floatingActionButton: FloatingActionButton(
          backgroundColor:
              _apptheme == AppTheme.lightMode ? kbutton : darkModeContainers,
          onPressed: () => Navigator.pushNamed(context, 'create_blog'),
          child: Icon(
            Icons.add,
            color: kwhite,
            size: 30,
          ),
        ),
        body: SingleChildScrollView(
          child: StreamBuilder<QuerySnapshot>(
            stream: AllBllogs,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'An Error have Occured!',
                    style: _apptheme.bodyLarge,
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return blogsShimmer();
              }
              return Column(
                  children: snapshot.data!.docs.map((DocumentSnapshot doc) {
                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

                Future<void> getImageUrl() async {
                  final ref =
                      FirebaseStorage.instance.ref().child(data['image']);
                  imageUrl = ref.getDownloadURL();
                  images = await ref.getDownloadURL();
                }

                _ratingnum = data['rating'];
                double _ratingTotal =
                    double.parse(_ratingnum.toStringAsFixed(1));

                return GestureDetector(
                    onTap: () {
                      log(data['image']);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BlogPage(
                                docId:doc.id,
                                  image: data['image'],
                                  date: data['history'],
                                  title: data['title'],
                                  body: data['body'],
                                  publisher: data['publisher'],
                                  rating: _ratingTotal,
                                  raters: data['Raters'])));
                    },
                    child: Container(
                      height: 120,
                      padding: const EdgeInsets.all(2),
                      margin: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          borderRadius: kcircular, color: Colors.transparent),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: FutureBuilder(
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
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return Container(
                                  decoration: BoxDecoration(
                                      borderRadius: kcircular,
                                      image: DecorationImage(
                                          image:
                                              NetworkImage(images.toString()),
                                          fit: BoxFit.cover)),
                                );
                              },
                            ),
                          ),
                          Expanded(
                              flex: 2,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 18, bottom: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      data['title'],
                                      maxLines: 2,
                                      style: GoogleFonts.roboto(
                                          color: _apptheme == AppTheme.lightMode
                                              ? kblack
                                              : kwhite,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      data['history'].toString(),
                                      style: GoogleFonts.roboto(
                                          color: _apptheme == AppTheme.lightMode
                                              ? kblack.withOpacity(0.7)
                                              : kwhite.withOpacity(0.7),
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          _ratingTotal.toString(),
                                          style: _apptheme.bodySmall,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.star_rate,
                                          color: kprimary,
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ))
                        ],
                      ),
                    ));
              }).toList());
            },
          ),
        ),
      ),
    );
  }

  Shimmer blogsShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.7),
      highlightColor: Colors.black.withOpacity(0.04),
      child: Container(
        margin: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(radius: 25, backgroundColor: kblack),
                const SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: kblack,
                      width: 70,
                      height: 20,
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Container(
                      color: kblack,
                      width: 50,
                      height: 20,
                    )
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              height: 300,
              color: kblack,
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Container(
                  color: kblack,
                  width: 150,
                  height: 30,
                )),
            const SizedBox(
              height: 15,
            ),
            Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Container(
                  color: kblack,
                  width: 200,
                  height: 30,
                )),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    color: kblack,
                    width: 50,
                    height: 30,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Container(
                    color: kblack,
                    width: 50,
                    height: 30,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
