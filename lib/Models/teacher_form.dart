import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:senior_project/View-Model/providers/id_provider.dart';
import 'package:uuid/uuid.dart';

class TaskForm {
  String title;
  Timestamp duedate;
  Timestamp startdate;
  String weight;
  String submissions;
  String participants;
  int teacherid;
  String description;
  String coursename;
  String attachments;
  String docId;
  TaskForm(
      this.attachments,
      this.coursename,
      this.description,
      this.duedate,
      this.participants,
      this.submissions,
      this.startdate,
      this.teacherid,
      this.title,
      this.weight,this.docId);
  var uuid = const Uuid();

  void createTask(String userID, BuildContext context) async {
    var db = FirebaseFirestore.instance.collection('Tasks');
    Map<String, dynamic> taskform = {
      'Attachments': attachments,
      'Course-Name': coursename,
      'Description': description,
      'Due': duedate,
      'Participants-Class': participants,
      'Submissions': submissions,
      'Teacher-ID': teacherid,
      'Title': title,
      'Weight': weight,
      'Start': startdate
    };

    Map<String, dynamic> results = {'status': 'pending', 'Score': 0.0};

    final version = context.read<IdProvider>().getID;
    db.doc(version).set(taskform).then((value) => log('Task Created $version'));
  }

  void editTask(String version, BuildContext context) async {
    var db = FirebaseFirestore.instance.collection('Tasks');
    Map<String, dynamic> taskform = {
      'Attachments': attachments,
      'Course-Name': coursename,
      'Description': description,
      'Due': duedate,
      'Participants-Class': participants,
      'Submissions': submissions,
      'Teacher-ID': teacherid,
      'Title': title,
      'Weight': weight,
      'Start': startdate
    };

    Map<String, dynamic> results = {'status': 'pending', 'Score': 0.0};

    db
        .doc(version)
        .update(taskform)
        .then((value) => log('Task Created $version'));
  }

  void deleteTask() async {
    final db = FirebaseFirestore.instance;
    await db.collection('Tasks').doc().delete();
  }
}
