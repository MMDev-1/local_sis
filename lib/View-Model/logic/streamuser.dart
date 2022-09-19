import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:senior_project/Models/student_info.dart';

class UserStreaming {
  final _db = FirebaseFirestore.instance;
  Future<String> getUserGradeById(String id) async {
    QuerySnapshot<Map<String, dynamic>> data =
        await _db.collection('Student').where('id', isEqualTo: id).get();
    return data.docs.map((e) => e.data()['grade']).toString();
  }
}
