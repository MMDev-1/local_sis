import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:senior_project/Models/commentOnAnnouncement.dart';
import 'package:senior_project/Utils/constants.dart';
import 'package:senior_project/View-Model/providers/auth/userAuthenticator.dart';
import 'package:senior_project/View-Model/providers/public/theme_provider.dart';

class AnnouncementsCommentsPage extends StatefulWidget {
  AnnouncementsCommentsPage(
      {Key? key,
      required this.replies,
      required this.message,
      required this.counter,
      required this.docId,
      required this.name,
      required this.grade})
      : super(key: key);
  List replies;
  String message;
  String grade;
  int counter;
  String docId;
  String name;
  @override
  State<AnnouncementsCommentsPage> createState() =>
      _AnnouncementsCommentsPageState();
}

class _AnnouncementsCommentsPageState extends State<AnnouncementsCommentsPage> {
  final TextEditingController _commentController = TextEditingController();
  List<String> rep = [];
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> allAnnouncements = FirebaseFirestore.instance
        .collection('Announcements')
        .where('Message', isEqualTo: widget.message)
        .snapshots();
    var _appthemecontroller = Provider.of<ThemeProvide>(context);
    var _apptheme = _appthemecontroller.getAppTheme;
    String userSplit = context.read<UserAuthenticator>().useremail().toString();
    String userId = userSplit.substring(0, userSplit.indexOf('@'));
    CommentOnAnnouncement ca = CommentOnAnnouncement(
        'name',
        userId,
        '${DateTime.now().day.toString()}-${DateTime.now().month.toString()}-${DateTime.now().year.toString()} at ${DateTime.now().hour.toString()}:${DateTime.now().minute.toString()}:${DateTime.now().second.toString()}',
        'message');
    return SafeArea(
        child: Scaffold(
            body: Container(
      margin: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: allAnnouncements,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'An Error have Occured!',
                      style: _apptheme.getAppTheme.bodyLarge,
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
                  Map<String, dynamic> data =
                      doc.data() as Map<String, dynamic>;
                  return SizedBox(
                    height: MediaQuery.of(context).size.height / 1.23,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: widget.counter,
                        itemBuilder: (context, index) {
                          if (rep.contains(data['Replies'][index].toString()) ==
                              false) {
                            rep.add(data['Replies'][index].toString());
                          }
                          log(data['Replies'].toString());
                          return Container(
                            margin: const EdgeInsets.all(8),
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data['Replies'][index]
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
                                  height: 5,
                                ),
                                Text(
                                    data['Replies'][index]
                                        .toString()
                                        .split('##SPLIT##')
                                        .toList()[2]
                                        .toString(),
                                    style: GoogleFonts.roboto(
                                        color: kblack.withOpacity(0.6),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14)),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  data['Replies'][index]
                                      .toString()
                                      .split('##SPLIT##')
                                      .toList()[3]
                                      .toString(),
                                  style: GoogleFonts.roboto(
                                      color: kblack,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                ),
                              ],
                            ),
                          );
                        }),
                  );
                }).toList());
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: TextField(
                    autofocus: false,
                    controller: _commentController,
                    decoration: const InputDecoration.collapsed(
                        hintText: 'Class Comment'),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        ca.message = _commentController.text;
                        rep.add(
                            '${widget.name}##SPLIT##$userId##SPLIT##${ca.date}##SPLIT##${ca.message}');
                        ca.commentonthepost(widget.docId, rep);
                      });
                      _commentController.clear();
                    },
                    icon: const Icon(Icons.send))
              ],
            ),
          ],
        ),
      ),
    )));
  }
}
