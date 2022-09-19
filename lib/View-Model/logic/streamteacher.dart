import 'package:cloud_firestore/cloud_firestore.dart';

class StreamTeahcer{
   final _db = FirebaseFirestore.instance;
  Future<String> getUserGradeById(String id) async {
    QuerySnapshot<Map<String, dynamic>> data =
        await _db.collection('Teacher').where('id', isEqualTo: id).get();
    return data.docs.map((e) => e.data()['grade']).toString();
  }
}