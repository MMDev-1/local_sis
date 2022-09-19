import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:senior_project/Models/books.dart';

class LibraryApi {
  final _db = FirebaseFirestore.instance;

  Future<List<Books>> getAllBooks() async {
    QuerySnapshot<Map<String, dynamic>> data =
        await _db.collection('Library').get();
    return data.docs.map((e) => Books.fromSnapshot(e)).toList();
  }

  Future<String> getBookById(String? id) async {
    var onebook =
        await _db.collection('Library').where('id', isEqualTo: id).get();
    return onebook.docs.map((e) => e.data()['id'].toString()).toString();
  }
}
