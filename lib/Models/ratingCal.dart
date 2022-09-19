import 'package:cloud_firestore/cloud_firestore.dart';

class RatingQ {
  double rating;
  int raters;
  RatingQ(this.raters, this.rating);
  void submitRating(String? doc) async {

    var db = FirebaseFirestore.instance.collection('Blogs');
    Map<String, dynamic> ratingQ = {'rating': rating, 'Raters': raters};
    db.doc(doc).update(ratingQ).then((value) => print('object'));
  }
}
