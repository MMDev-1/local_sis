import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class Absence {
  String studentName;
  DateTime absenceDate;
  Absence(this.studentName, this.absenceDate);
  void setAbsence() async {
    final db = FirebaseFirestore.instance.collection('Attendance');
    Map<String, dynamic> data = {
      'Student-Name': studentName,
      'Absence-Date': absenceDate
    };
    db.doc().set(data).then((value) => log('Absence Sent'));
  }
}
