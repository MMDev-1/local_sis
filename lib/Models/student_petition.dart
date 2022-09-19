import 'package:cloud_firestore/cloud_firestore.dart';

class Petition {
  String name;
  String type;
  String todate;
  int studentId;
  int petitionId;
  String status;
  String result;
  String fromdate;
  String cause;
  String attachments;
  Petition(
      this.attachments,
      this.cause,
      this.fromdate,
      this.name,
      this.petitionId,
      this.result,
      this.status,
      this.studentId,
      this.todate,
      this.type);
  Petition.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snap)
      : attachments = snap['attachments'],
        cause = snap['cause'],
        fromdate = snap['from date'],
        name = snap['name'],
        petitionId = snap['petition id'],
        result = snap['result'],
        status = snap['status'],
        studentId = snap['student id'],
        todate = snap['to date'],
        type = snap['type'];
}
