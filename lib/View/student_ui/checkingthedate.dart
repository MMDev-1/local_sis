import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:senior_project/View-Model/providers/toggle_provider.dart';

class CheeckingDateee extends StatefulWidget {
  const CheeckingDateee({Key? key}) : super(key: key);

  @override
  State<CheeckingDateee> createState() => _CheeckingDateeeState();
}

class _CheeckingDateeeState extends State<CheeckingDateee> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _taskStream =
        FirebaseFirestore.instance.collection('Tasks').snapshots();
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder<QuerySnapshot>(
          stream: _taskStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                  child: Text(
                'An Error Occured',
              ));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Column(
                children: snapshot.data!.docs.map((DocumentSnapshot doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              DateTime date = data['deadline'].toDate();
              DateTime nowDating = DateTime.now();
              var result = nowDating.compareTo(date);
              return Center(
                  child: Column(
                children: [
                  Text(result.toString(),
                      style: TextStyle(fontSize: 30, color: Colors.red)),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    date.toString(),
                    style: TextStyle(color: Colors.green, fontSize: 30),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    DateTime.now().toString(),
                    style: TextStyle(fontSize: 30, color: Colors.black),
                  )
                ],
              ));
            }).toList());
          },
        ),
      ),
    );
  }
}
