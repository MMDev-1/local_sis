import 'package:cloud_firestore/cloud_firestore.dart';

class PetitionRequest {
  String type;
  String cause;
  String from;
  String to;
  String details;
  String id;
  String petId;
  String attachments;
  PetitionRequest(this.type, this.cause, this.from, this.to, this.details,
      this.id, this.petId,this.attachments);
  void sendRequest() async {
    var db = FirebaseFirestore.instance.collection('Petitions');
    Map<String, dynamic> requestLeave = {
      'from date': from,
      'to date': to,
      'student id': id,
      'petition id': petId,
      'cause': cause,
      'petition details': details,
      'type': type,
      'attachments':attachments,
      'status':'pending'
    };
    db.doc().set(requestLeave).then((value) => print('object'));
  }
}
