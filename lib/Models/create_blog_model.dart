import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class CreateBlogModel {
  String title;
  String body;
  String image;
  String history;
  bool popular;
  String publisher;
  double rating;
  int raters;
  CreateBlogModel(this.body, this.history, this.image, this.popular,
      this.publisher, this.raters, this.rating, this.title);
  void createNewBlog(String id) async {
    final db = FirebaseFirestore.instance.collection('Blogs');
    Map<String, dynamic> results = {
      'title': title,
      'body': body,
      'image': image,
      'ispopular': popular,
      'publisher': publisher,
      'rating': rating,
      'Raters': raters,
      'history': history,
      'Full-Body': ''
    };
     db
        .doc(id)
        .set(results)
        .then((value) => log('Blog Created Successfully'));
  }
}
