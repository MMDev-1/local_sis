import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:senior_project/Models/student_results_form.dart';
import 'package:senior_project/Models/tasks.dart';

class TasksApi {
  String? status;
  final _db = FirebaseFirestore.instance;

  Future<List<Tasks>> getAllTasks() async {
    QuerySnapshot<Map<String, dynamic>> data =
        await _db.collection('Tasks').get();
    return data.docs.map((e) => Tasks.fromSnapshot(e)).toList();
  }

  Future<List<StudentResultsForm>> getStudentTaskStatus(
      String taskId, String userId) async {
    QuerySnapshot<Map<String, dynamic>> data =
        await _db.collection('Tasks').doc(taskId).collection('Results').get();
    return data.docs.map((e) => StudentResultsForm.fromSnapshot(e)).toList();
  }

  Future<Map<String,dynamic>> getStudenSpecificGrade(String taskId, String userId) async {
    DocumentSnapshot doc = await _db
        .collection('Tasks')
        .doc(taskId)
        .collection('Results')
        .doc(userId)
        .get();
    return doc.data() as Map<String,dynamic>;
  }
}
