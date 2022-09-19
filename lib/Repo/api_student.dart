import 'package:cloud_firestore/cloud_firestore.dart';

import '../Models/student_info.dart';

class StudentApi {
  final _db = FirebaseFirestore.instance;
  Future<List<Student>> getStudentByEmail(String email) async {
    QuerySnapshot<Map<String, dynamic>> data =
        await _db.collection('Student').where('email', isEqualTo: email).get();
    return data.docs.map((e) => Student.fromSnapshot(e)).toList();
  }
  Future<List<Student>> getStudentById(String email) async {
    QuerySnapshot<Map<String, dynamic>> data =
        await _db.collection('Student').where('ID', isEqualTo: email).get();
    return data.docs.map((e) => Student.fromSnapshot(e)).toList();
  }
  Future<List<Student>> getAllStudents() async{
      QuerySnapshot<Map<String, dynamic>> data =
        await _db.collection('Student').get();
    return data.docs.map((e) => Student.fromSnapshot(e)).toList();
  }
  Future<List<Student>> getStudentIdByGrade(String grade) async{
      QuerySnapshot<Map<String, dynamic>> data =
        await _db.collection('Student').where('Grade',isEqualTo: grade).get();
    return data.docs.map((e) => Student.fromSnapshot(e)).toList();
  }
}
