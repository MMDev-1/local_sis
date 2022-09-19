import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:senior_project/Utils/constants.dart';
import 'package:senior_project/View-Model/providers/auth/userAuthenticator.dart';

class NotificationSeciton extends StatefulWidget {
  const NotificationSeciton({Key? key}) : super(key: key);

  @override
  State<NotificationSeciton> createState() => _NotificationSecitonState();
}

class _NotificationSecitonState extends State<NotificationSeciton> {
  @override
  Widget build(BuildContext context) {
    String userSplit = context.read<UserAuthenticator>().useremail().toString();
    String userId = userSplit.substring(0, userSplit.indexOf('@'));
    final Stream<QuerySnapshot> allNotifications = FirebaseFirestore.instance
        .collection('Student')
        .where('ID', isEqualTo: int.parse(userId))
        .snapshots();
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: StreamBuilder<QuerySnapshot>(
            stream: allNotifications,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    'An Error have Occured!',
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Column(
                  children: snapshot.data!.docs.map((DocumentSnapshot doc) {
                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                return SizedBox(
                  height: MediaQuery.of(context).size.height / 1.2,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: data['Notifications'].length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['Notifications'][index]
                                  .toString()
                                  .split('##SPLIT##')
                                  .toList()[0]
                                  .toString(),
                              style: GoogleFonts.roboto(
                                  color: kblack,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                              data['Notifications'][index]
                                  .toString()
                                  .split('##SPLIT##')
                                  .toList()[2]
                                  .toString(),
                              style: GoogleFonts.roboto(
                                  color: kblack,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16),
                            ),
                            Divider(
                              thickness: 2,
                              color: kblack,
                            )
                          ],
                        ),
                      );
                    },
                  ),
                );
              }).toList());
            },
          ),
        ),
      ),
    );
  }
}
