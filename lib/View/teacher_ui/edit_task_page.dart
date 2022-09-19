// ignore_for_file: prefer_final_fields

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_material_pickers/helpers/show_scroll_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:senior_project/Models/teacher_form.dart';
import 'package:senior_project/Utils/constants.dart';
import 'package:senior_project/Utils/themes/app_theme.dart';
import 'package:senior_project/View-Model/providers/auth/userAuthenticator.dart';
import 'package:senior_project/View-Model/providers/id_provider.dart';
import 'package:senior_project/View-Model/providers/public/theme_provider.dart';
import 'package:unicons/unicons.dart';

class TaskPageEditing extends StatefulWidget {
  TaskPageEditing({Key? key, required this.mytaskForm}) : super(key: key);
  TaskForm mytaskForm;
  @override
  State<TaskPageEditing> createState() => _TaskPageEditingState();
}

class _TaskPageEditingState extends State<TaskPageEditing> {
  PlatformFile? pickedTaskFile;
  Future pickTask() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        pickedTaskFile = result.files.first;
      });
    } else {}
  }

  Future uploadFile() async {
    final id = context.read<IdProvider>().getID;
    final path = 'tasks/$id/Teacher/${pickedTaskFile!.name}';
    final file = File(pickedTaskFile!.path!);
    final ref = FirebaseStorage.instance.ref().child(path);
    ref.putFile(file);
  }

  final TextEditingController textTitle = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController taskDescription = TextEditingController();
  final TextEditingController courseController = TextEditingController();
  List<String> items = ['In-Class', 'Assignment', 'Quiz', 'Exam'];
  DateTime? end;
  DateTime? start;
  String dropdownValue = 'one';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var selectedUsState = "Grade";

  List<String> grades = <String>['7-A', '12-D', '7-B'];

  int? _value;
  @override
  void initState() {
    super.initState();
    textTitle.text = widget.mytaskForm.title;
    _weightController.text = widget.mytaskForm.weight.toString();
    taskDescription.text = widget.mytaskForm.description;
    courseController.text = widget.mytaskForm.coursename;
    _value = items.indexOf(widget.mytaskForm.submissions);
    end = widget.mytaskForm.duedate.toDate();
    start = widget.mytaskForm.startdate.toDate();
  }

  @override
  Widget build(BuildContext context) {
    TaskForm taskForm = TaskForm(
        'attachments',
        'coursename',
        'description',
        Timestamp.now(),
        'participants',
        'submissions',
        Timestamp.now(),
        123,
        'title',
        'weight',
        widget.mytaskForm.docId);
    var _appthemecontroller = Provider.of<ThemeProvide>(context);
    var _apptheme = _appthemecontroller.getAppTheme;
    String userSplit = context.read<UserAuthenticator>().useremail().toString();
    String userId = userSplit.substring(0, userSplit.indexOf('@'));
    final Stream<QuerySnapshot> _teacherClasses = FirebaseFirestore.instance
        .collection('Courses')
        .where('Teacher-ID', isEqualTo: userId)
        .snapshots();
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          key: _scaffoldKey,
          body: SingleChildScrollView(
            child: Container(
              color: _apptheme == AppTheme.lightMode
                  ? Theme.of(context).scaffoldBackgroundColor
                  : darkModeBackground,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Spacer(
                        flex: 1,
                      ),
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Edit Task',
                              style: _apptheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(Icons.close)),
                            ],
                          ))
                    ],
                  ),
                  Divider(
                    thickness: 2,
                    color: kblack,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Text(
                      'Course Name',
                      style: _apptheme.bodyLarge,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: TextField(
                      controller: courseController,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: kblack),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: kblack),
                            borderRadius: BorderRadius.circular(10),
                          )),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: Text(
                      'Task Title',
                      style: _apptheme.bodyLarge,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: TextField(
                      controller: textTitle,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: kblack),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: kblack),
                            borderRadius: BorderRadius.circular(15),
                          )),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: Text(
                      'Category',
                      style: _apptheme.bodyLarge,
                    ),
                  ),
                  Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 10),
                      child: SizedBox(
                        height: 60,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 1,
                            itemBuilder: (context, index) {
                              return Wrap(
                                direction: Axis.horizontal,
                                children: List<Widget>.generate(
                                  items.length,
                                  (int index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ChoiceChip(
                                        padding: const EdgeInsets.all(10),
                                        label: Text(
                                          '' + items[index],
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                        selected: _value == index,
                                        selectedColor: kbutton,
                                        disabledColor: ksecondary,
                                        elevation: 2,
                                        onSelected: (bool selected) {
                                          setState(() {
                                            _value = selected ? index : null;
                                          });
                                        },
                                      ),
                                    );
                                  },
                                ).toList(),
                              );
                            }),
                      )),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 25, right: 20, top: 10, bottom: 10),
                    child: GestureDetector(
                      onTap: () {
                        DatePicker.showDatePicker(context,
                            showTitleActions: true, onChanged: (date) {
                          log('change $date');
                        }, onConfirm: (date) {
                          log('confirm $date');
                          setState(() {
                            start = date;
                          });
                        }, currentTime: DateTime.now(), locale: LocaleType.en);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: kblack)),
                        child: start == null
                            ? Center(
                                child: Text(widget.mytaskForm.startdate
                                    .toDate()
                                    .toString()))
                            : Center(child: Text(start.toString())),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 25, right: 20, top: 10, bottom: 10),
                    child: GestureDetector(
                      onTap: () {
                        DatePicker.showDatePicker(context,
                            showTitleActions: true, onChanged: (date) {
                          log('change $date');
                        }, onConfirm: (date) {
                          log('confirm $date');
                          setState(() {
                            end = date;
                          });
                        }, currentTime: DateTime.now(), locale: LocaleType.en);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: kblack)),
                        child: end == null
                            ? Center(
                                child: Text(widget.mytaskForm.duedate
                                    .toDate()
                                    .toString()))
                            : Center(child: Text(end.toString())),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: Text(
                      'Weight',
                      style: _apptheme.bodyLarge,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 50,
                          width: 100,
                          child: TextField(
                            controller: _weightController,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 1, color: kblack),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 1, color: kblack),
                                  borderRadius: BorderRadius.circular(5),
                                )),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          '%',
                          style: GoogleFonts.roboto(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: Text(
                      'Participants',
                      style: _apptheme.bodyLarge,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 25, right: 20, top: 10),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showMaterialScrollPicker(
                              context: context,
                              title: "Pick Your Grade",
                              items: grades,
                              selectedItem: selectedUsState,
                              onChanged: (value) => setState(
                                  () => selectedUsState = value as String),
                            );
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                border: Border.all(color: kblack),
                                borderRadius: kbottomcircular),
                            child: const Icon(Icons.add),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          widget.mytaskForm.participants,
                          style: _apptheme.bodyLarge,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: Text(
                      'Attachments',
                      style: _apptheme.bodyLarge,
                    ),
                  ),
                  pickedTaskFile == null
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 25, top: 10),
                          child: Column(
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
                              Text(pickedTaskFile!.name.toString())
                            ],
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 25, right: 25, top: 25, bottom: 20),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      decoration: BoxDecoration(
                          borderRadius: kbottomcircular,
                          border: Border.all(color: kblack)),
                      child: TextButton.icon(
                          onPressed: pickTask,
                          icon: const Icon(Icons.upload),
                          label: const Text('Upload File')),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: Text(
                      'Description',
                      style: _apptheme.bodyLarge,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 20),
                    child: SizedBox(
                      height: 200,
                      child: TextField(
                        expands: true,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        controller: taskDescription,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1, color: kblack),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1, color: kblack),
                              borderRadius: BorderRadius.circular(10),
                            )),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 20),
                    child: Container(
                      height: 80,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          gradient: _apptheme == AppTheme.lightMode
                              ? kmix
                              : lightkmix,
                          borderRadius: kcircular),
                      child: MaterialButton(
                        onPressed: () {
                          taskForm.attachments =
                              pickedTaskFile!.name.toString();
                          taskForm.coursename = courseController.text;
                          taskForm.description = taskDescription.text;
                          taskForm.duedate = Timestamp.fromDate(end!);
                          taskForm.startdate = Timestamp.fromDate(start!);
                          taskForm.participants = selectedUsState;
                          taskForm.submissions = items[_value!];
                          taskForm.teacherid = int.parse(userId);
                          taskForm.title = textTitle.text;
                          taskForm.weight = _weightController.text;
                          uploadFile();
                          taskForm.editTask(widget.mytaskForm.docId, context);
                          Navigator.pushNamed(context, 'teacher_tasks');
                        },
                        child: Text(
                          'Edit Task',
                          style: _apptheme.titleLarge,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 20),
                    child: Container(
                      height: 80,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          gradient: _apptheme == AppTheme.lightMode
                              ? kmix
                              : lightkmix,
                          borderRadius: kcircular),
                      child: MaterialButton(
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('Tasks')
                              .doc(widget.mytaskForm.docId)
                              .delete();
                          Navigator.pushNamed(context, 'teacher_tasks');
                        },
                        child: Text(
                          'Delete Task',
                          style: _apptheme.titleLarge,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
