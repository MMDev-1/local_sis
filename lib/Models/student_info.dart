import 'package:cloud_firestore/cloud_firestore.dart';

class Student {
  String email;
  String birthdate;
  String address;
  String name;
  String phone;
  String grade;
  String lname;
  int id;
  List notificationsCount;
  Student(this.email, this.birthdate, this.address, this.grade, this.id,
      this.name, this.phone, this.lname, this.notificationsCount);
  Student.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document)
      : email = document.data()!['email'],
        birthdate = document.data()!['Birth-Date'],
        address = document.data()!['Grade'],
        name = document.data()!['First-Name'],
        phone = document.data()!['Primary-Number'],
        grade = document.data()!['Grade'],
        id = document.data()!['ID'],
        lname = document.data()!['Last-Name'],
        notificationsCount = document.data()!['Notifications'];
}
