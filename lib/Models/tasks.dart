import 'package:cloud_firestore/cloud_firestore.dart';

class Tasks {
  String title;
  Timestamp duedate;
  int weight;
  String submissions;
  String participants;
  String teacherid;
  String description;
  String coursename;
  String attachments;
  Tasks(
      this.attachments,
      this.coursename,
      this.description,
      this.duedate,
      this.participants,
      this.submissions,
      this.teacherid,
      this.title,
      this.weight);

  Tasks.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document)
      : coursename = document.data()!['Course-Name'].toString(),
        description = document.data()!['Description'],
        duedate = document.data()!['Due'],
        participants = document.data()!['Participants-Class'],
        submissions = document.data()!['Submissions'],
        title = document.data()!['Title'],
        teacherid = document.data()!['Teacher-ID'].toString(),
        weight = document.data()!['Weight'],
        attachments = document.data()!['Attachments'];
}
