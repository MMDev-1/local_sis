import 'package:cloud_firestore/cloud_firestore.dart';

class Teacher {
  String email;
  String birthdate;
  String name;
  String phone;
  String lname;
  
  Teacher(this.email, this.birthdate,
      this.name, this.phone, this.lname);
  Teacher.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document)
      : email = document.data()!['Email'],
        birthdate = document.data()!['Birth-Date'],
        name = document.data()!['First-Name'],
        phone = document.data()!['Primary-Number'],
        lname = document.data()!['Last-Name'];
}
