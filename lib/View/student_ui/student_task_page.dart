import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:senior_project/Models/student_results_form.dart';
import 'package:senior_project/Models/student_task.dart';
import 'package:senior_project/Repo/api_tasks.dart';
import 'package:senior_project/Utils/constants.dart';
import 'package:senior_project/Utils/themes/app_theme.dart';
import 'package:senior_project/View-Model/providers/auth/userAuthenticator.dart';
import 'package:senior_project/View-Model/providers/public/theme_provider.dart';
import 'package:senior_project/View/student_ui/reading_task_desc.dart';

class StudentTaskPage extends StatefulWidget {
  StudentTaskPage({Key? key, required this.studentTaskForm}) : super(key: key);
  StudentTaskForm studentTaskForm;
  @override
  State<StudentTaskPage> createState() => _StudentTaskPageState();
}

class _StudentTaskPageState extends State<StudentTaskPage> {
  PlatformFile? pickedTaskFile;
  Future pickTask() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        pickedTaskFile = result.files.first;
      });
    } else {}
  }

  Future getTasks() async {
    final storageRef = FirebaseStorage.instance.ref().child("tasks");
    final listResult = await storageRef.listAll();
    for (var prefix in listResult.prefixes) {
      //do something
    }
    for (var item in listResult.items) {
      setState(() {});
    }
  }

  Future getAttachments(String reference) async {
    Reference pathReference = FirebaseStorage.instance.ref().child(reference);
    final url = await pathReference.getDownloadURL();
    final appDocDirectory = await getApplicationDocumentsDirectory();
    File filePath = File("${appDocDirectory.path}/$reference");

    await Dio().download(url, filePath);
  }

  TasksApi service = TasksApi();
  Future<Map<String, dynamic>>? statusFuture;
  Map<String, dynamic>? resultsList;
  Future<void> gettingStatus() async {
    statusFuture = service.getStudenSpecificGrade(
        widget.studentTaskForm.docId, widget.studentTaskForm.userId);
    resultsList = await service.getStudenSpecificGrade(
        widget.studentTaskForm.docId, widget.studentTaskForm.userId);
  }

  @override
  void initState() {
    super.initState();
    gettingStatus();
    log('userId ${widget.studentTaskForm.userId}');
  }

  @override
  Widget build(BuildContext context) {
    var _apptheme = Provider.of<ThemeProvide>(context);
    String userSplit = context.read<UserAuthenticator>().useremail().toString();
    String userId = userSplit.substring(0, userSplit.indexOf('@'));
    Future uploadFile() async {
      final path =
          'tasks/${widget.studentTaskForm.docId}/Results/$userId/${pickedTaskFile!.name}';
      final file = File(pickedTaskFile!.path!);
      final ref = FirebaseStorage.instance.ref().child(path);
      ref.putFile(file);
    }

    return SafeArea(
      child: Scaffold(
        /*  bottomSheet: BottomSheet(
            enableDrag: false,
            onClosing: () {
              Navigator.pop(context);
            },
            builder: (context) {
              return SingleChildScrollView(
                child: Container(
                    height: 140,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: kprimary,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Documents',
                              style: GoogleFonts.roboto(
                                  color: kwhite,
                                  fontWeight: _apptheme
                                      .getAppTheme.bodyLarge.fontWeight,
                                  fontSize:
                                      _apptheme.getAppTheme.bodyLarge.fontSize),
                            ),
                            IconButton(
                                onPressed: pickTask,
                                icon: Icon(
                                  Icons.add,
                                  color: kwhite,
                                ))
                          ],
                        ),
                        TextButton(
                            onPressed: uploadFile,
                            child: Text(
                              'Submit',
                              style: GoogleFonts.roboto(
                                  color: kwhite,
                                  fontWeight: _apptheme
                                      .getAppTheme.bodyLarge.fontWeight,
                                  fontSize:
                                      _apptheme.getAppTheme.bodyLarge.fontSize),
                            ))
                      ],
                    )),
              );
            }),*/
        backgroundColor: _apptheme.getAppTheme == AppTheme.lightMode
            ? Theme.of(context).scaffoldBackgroundColor
            : darkModeBackground,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: _apptheme.getAppTheme == AppTheme.lightMode
              ? Theme.of(context).scaffoldBackgroundColor
              : darkModeBackground,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios_sharp,
                size: 30, color: _apptheme.getAppTheme.bodyLarge.color),
          ),
        ),
        body: Builder(builder: (context) {
          return Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.studentTaskForm.tasktitle,
                        style: GoogleFonts.roboto(
                            color: _apptheme.getAppTheme == AppTheme.lightMode
                                ? kblack
                                : kwhite,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.studentTaskForm.taskname,
                        style: GoogleFonts.roboto(
                            color: _apptheme.getAppTheme == AppTheme.lightMode
                                ? kblack.withOpacity(0.7)
                                : kwhite.withOpacity(0.7),
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      FutureBuilder(
                        future: statusFuture,
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                'An Error has occured!',
                                style: _apptheme.getAppTheme.bodyLarge,
                              ),
                            );
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          String result = resultsList!['Score'].toString();
                          return result.isNotEmpty
                              ? Text(
                                  '${result.toString()}/100',
                                  style: _apptheme.getAppTheme.bodyMedium,
                                )
                              : Text('100 points',
                                  style: _apptheme.getAppTheme.bodyMedium);
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.all(20),
                        height: 100,
                        width: 250,
                        decoration: BoxDecoration(
                            color: _apptheme.getAppTheme == AppTheme.lightMode
                                ? kprimary
                                : darkModeContainers,
                            borderRadius: kbottomcircular),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Due Date',
                                  style: _apptheme.getAppTheme.titleMedium,
                                ),
                                Icon(
                                  Icons.date_range,
                                  color: _apptheme.getAppTheme ==
                                          AppTheme.lightMode
                                      ? kwhite
                                      : Colors.grey,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              widget.studentTaskForm.deadline,
                              style: GoogleFonts.roboto(
                                  color: kwhite,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        widget.studentTaskForm.taskdesc,
                        style: _apptheme.getAppTheme.bodyMedium,
                        overflow: TextOverflow.fade,
                        maxLines: 6,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ReadingTasks(
                                            desc: widget
                                                .studentTaskForm.taskdesc)));
                              },
                              child: Text(
                                'Read more...',
                                style: _apptheme.getAppTheme.bodyMedium,
                              )),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Attachments',
                        style: _apptheme.getAppTheme.bodyLarge,
                      ),
                      const SizedBox(height: 20),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () async {
                          await getAttachments(
                              widget.studentTaskForm.attachments);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 25, top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  height: 100,
                                  width: 150,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: kblack),
                                      borderRadius: kbottomcircular)),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(widget.studentTaskForm.attachments.substring(
                                  widget.studentTaskForm.attachments
                                          .indexOf('Teacher/') +
                                      8,
                                  widget.studentTaskForm.attachments.length))
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // ignore: prefer_const_constructors
                    ],
                  ),
                ),
              ),
              DraggableScrollableSheet(
                initialChildSize: 0.15,
                minChildSize: 0.15,
                maxChildSize: 0.6,
                builder:
                    (BuildContext context, ScrollController scrollController) {
                  return SingleChildScrollView(
                    controller: scrollController,
                    child: Container(
                        height: 400,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: ksecondary,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Documents',
                                  style: GoogleFonts.roboto(
                                      color: kwhite,
                                      fontWeight: _apptheme
                                          .getAppTheme.bodyLarge.fontWeight,
                                      fontSize: _apptheme
                                          .getAppTheme.bodyLarge.fontSize),
                                ),
                                IconButton(
                                    onPressed: pickTask,
                                    icon: Icon(
                                      Icons.add,
                                      color: kwhite,
                                    ))
                              ],
                            ),
                            const Spacer(),
                            pickedTaskFile != null
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        right: 25, top: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            height: 100,
                                            width: 150,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: kwhite, width: 3),
                                                borderRadius: kbottomcircular)),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          widget.studentTaskForm.attachments
                                              .substring(
                                                  widget.studentTaskForm
                                                          .attachments
                                                          .indexOf('Teacher/') +
                                                      8,
                                                  widget.studentTaskForm
                                                      .attachments.length),
                                          style: GoogleFonts.roboto(
                                              color: kwhite,
                                              fontWeight: _apptheme.getAppTheme
                                                  .bodyLarge.fontWeight,
                                              fontSize: _apptheme.getAppTheme
                                                  .bodyLarge.fontSize),
                                        )
                                      ],
                                    ),
                                  )
                                : Container(),
                            Container(
                              height: 80,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  gradient: _apptheme.getAppTheme ==
                                          AppTheme.lightMode
                                      ? kmix
                                      : lightkmix,
                                  borderRadius: kcircular),
                              child: MaterialButton(
                                  onPressed: () async {
                                    uploadFile();
                                    await FirebaseFirestore.instance
                                        .collection('Tasks')
                                        .doc(widget.studentTaskForm.docId)
                                        .collection('Results')
                                        .doc(userId)
                                        .update({'Status': 'Done'});
                                    DraggableScrollableActuator.reset(context);
                                  },
                                  child: Text(
                                    'Submit',
                                    style: GoogleFonts.roboto(
                                        color: kwhite,
                                        fontWeight: _apptheme
                                            .getAppTheme.bodyLarge.fontWeight,
                                        fontSize: _apptheme
                                            .getAppTheme.bodyLarge.fontSize),
                                  )),
                            ),
                          ],
                        )),
                  );
                },
              ),
            ],
          );
        }),
      ),
    );
  }
}
