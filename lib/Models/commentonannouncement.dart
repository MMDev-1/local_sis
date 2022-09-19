import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class CommentOnAnnouncement {
  String date;
  String message;
  String id;
  String name;
  CommentOnAnnouncement(this.name, this.id, this.date, this.message);
  void commentonthepost(String docId,List<String> allReplies) async {
    Map<String, dynamic> results = {
      'Replies': '$name##SPLIT##$id##SPLIT##$date##SPLIT##$message'
    };
    await FirebaseFirestore.instance
        .collection('Announcements')
        .doc(docId)
        .update({
      'Replies': allReplies
    }).then((value) => log('Commented SuccessFully'));
  }
}
