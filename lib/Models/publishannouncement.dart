import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class PublishAnnouncement {
  String message;
  String title;
  String date;
  String teacherId;
  String tclass;
  PublishAnnouncement(
      this.tclass, this.date, this.message, this.teacherId, this.title);
  void SendAnnouncement() async {
    final db = FirebaseFirestore.instance.collection('Announcements');
    Map<String, dynamic> results = {
      'Title': title,
      'Teacher-ID': teacherId,
      'Message': message,
      'Replies': [],
      'Date': date,
      'Class': tclass,
    };
    db
        .doc()
        .set(results)
        .then((value) => log('Announcement Published Successfully'));
  }
}
