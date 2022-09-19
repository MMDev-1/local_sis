import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:senior_project/View-Model/providers/router/grade_provider_id.dart';

class UploadStudentGrades {
  int score;
  UploadStudentGrades(this.score);
  void uploadGrades(
    BuildContext context,
    String id,
  ) {
    final db = FirebaseFirestore.instance
        .collection('Tasks')
        .doc(context.read<GradeProviderId>().getdocId)
        .collection('Results');
    Map<String, dynamic> results = {
      'Score':score
    };
    db
        .doc(id)
        .update(results)
        .then((value) => log('Grades Updated Successfully'));
  }
}
