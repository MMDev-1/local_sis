import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:senior_project/Models/student_petition.dart';

class PeititonsApi {
  final _db = FirebaseFirestore.instance;
  Stream<List<Petition>> getPetitionsbyId(String id) {
    return _db
        .collection('Peitions')
        .where('student id', isEqualTo: id)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => Petition.fromSnapshot(e)).toList());
  }
}
