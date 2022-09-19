import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:senior_project/Models/ratingCal.dart';
import 'package:senior_project/Utils/constants.dart';
import 'package:senior_project/Utils/themes/app_theme.dart';

import '../../View-Model/providers/public/theme_provider.dart';

class BlogPage extends StatefulWidget {
  BlogPage(
      {Key? key,
      required this.docId,
      required this.image,
      required this.title,
      required this.body,
      required this.publisher,
      required this.date,
      required this.rating,
      required this.raters})
      : super(key: key);
  String image;
  String publisher;
  String date;
  // ignore: prefer_typing_uninitialized_variables
  double rating;
  String docId;
  String title;
  String body;
  int raters;
  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  @override
  void initState() {
    super.initState();
  }

  var doc_id2;
  Future<String>? imageUrl;
  String? url;
  Future<void> getImageUrl() async {
    final ref = FirebaseStorage.instance.ref().child(widget.image);
    imageUrl = ref.getDownloadURL();
    url = await ref.getDownloadURL();
  }

  Future<void> getting() async {
    DocumentReference doc_ref =
        FirebaseFirestore.instance.collection("board").doc();

    DocumentSnapshot docSnap = await doc_ref.get();
    doc_id2 = docSnap.reference.id;
  }

  RatingQ rq = RatingQ(-1, -1.0);
  @override
  Widget build(BuildContext context) {
    var _appthemecontroller = Provider.of<ThemeProvide>(context);
    var _apptheme = _appthemecontroller.getAppTheme;

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
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder(
                  future: getImageUrl(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'An Error has occured!',
                          style: _apptheme.bodyLarge,
                        ),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return Container(
                      width: double.infinity,
                      height: 300,
                      decoration: BoxDecoration(
                          borderRadius: kcircular,
                          image: DecorationImage(
                              image: NetworkImage(
                                url.toString(),
                              ),
                              fit: BoxFit.cover)),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Text(
                    widget.date,
                    style: GoogleFonts.roboto(
                        color: _apptheme == AppTheme.lightMode
                            ? Colors.black.withOpacity(0.5)
                            : Colors.white.withOpacity(0.5),
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    widget.title,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.roboto(
                        color:
                            _apptheme == AppTheme.lightMode ? kbutton : kwhite,
                        fontSize: 28,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Html(data: widget.body)),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Text('By: ${widget.publisher}',
                      style: _apptheme.bodyMedium),
                ),
                const SizedBox(
                  height: 20,
                ),
                rq.rating <= 0
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: RatingBar.builder(
                            initialRating: 2.5,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              int num = widget.raters + 1;
                              double rate;
                              rate = (rating + widget.rating) / (num / 1.0);
                              widget.rating += rate;
                              rq.raters = num;
                              rq.rating = rate;
                              log('rating ${rq.rating}  raters ${rq.raters}');
                              setState(() {
                                rq.submitRating(widget.docId);
                              });
                            },
                          ),
                        ),
                      )
                    : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
