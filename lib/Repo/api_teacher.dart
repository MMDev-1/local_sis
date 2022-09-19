import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:senior_project/Models/teacher_info.dart';

class TeacherApi {
  final _db = FirebaseFirestore.instance;
  Future<List<Teacher>> getStudentByEmail(String email) async {
    QuerySnapshot<Map<String, dynamic>> data =
        await _db.collection('Teacher').where('Email', isEqualTo: email).get();
    return data.docs.map((e) => Teacher.fromSnapshot(e)).toList();
  }
}
