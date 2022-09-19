import 'package:cloud_firestore/cloud_firestore.dart';

class StudentResultsForm {
  String status;
  String score;
  StudentResultsForm(this.status, this.score);
  StudentResultsForm.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : status = doc.data()!['Status'].toString(),
        score = doc.data()!['Score'].toString();
}
