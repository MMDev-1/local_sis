import 'dart:ffi';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senior_project/Models/create_blog_model.dart';
import 'package:senior_project/Utils/constants.dart';
import 'package:senior_project/Utils/themes/app_theme.dart';
import 'package:senior_project/View-Model/providers/public/theme_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class CreateBlogPage extends StatefulWidget {
  const CreateBlogPage({Key? key}) : super(key: key);

  @override
  State<CreateBlogPage> createState() => _CreateBlogPageState();
}

class _CreateBlogPageState extends State<CreateBlogPage> {
  final TextEditingController _blogBodyController = TextEditingController();
  final TextEditingController _blogtitleController = TextEditingController();
  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return kprimary;
    }
    return kprimary;
  }

  bool isChecked = false;
  PlatformFile? pickedTaskFile;
  Future pickTask() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        pickedTaskFile = result.files.first;
      });
    } else {}
  }

  Future uploadFile(String id) async {
    final path = 'Blogs/$id/${pickedTaskFile!.name}';
    final file = File(pickedTaskFile!.path!);
    final ref = FirebaseStorage.instance.ref().child(path);
    ref.putFile(file);
  }

  @override
  void initState() {
    super.initState();
  }

  CreateBlogModel blogModel = CreateBlogModel(
      'body', 'history', 'image', false, 'publisher', 1, 5.0, 'title');
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var _appthemecontroller = Provider.of<ThemeProvide>(context);
    var _apptheme = _appthemecontroller.getAppTheme;
    return SafeArea(
      child: GestureDetector(
        onTap: () {},
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
                              'New Blog',
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
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, bottom: 10, top: 5),
                    child: Text(
                      'Blog Image',
                      style: _apptheme.bodyLarge,
                    ),
                  ),
                  GestureDetector(
                    onTap: pickTask,
                    child: Container(
                        margin: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 10),
                        child: DottedBorder(
                            strokeWidth: 3,
                            dashPattern: const [10, 6],
                            child: const SizedBox(
                              height: 130,
                              child: Center(
                                child: Icon(
                                  Icons.upload,
                                  size: 40,
                                ),
                              ),
                            ))),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, bottom: 10, top: 10),
                    child: Text(
                      'Blog Title',
                      style: _apptheme.bodyLarge,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                    child: TextField(
                      controller: _blogtitleController,
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
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, bottom: 10, top: 10),
                    child: Text(
                      'Blog Body',
                      style: _apptheme.bodyLarge,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, bottom: 10, top: 10),
                    child: SizedBox(
                      height: 200,
                      child: TextField(
                        expands: true,
                        controller: _blogBodyController,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
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
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                    child: Row(
                      children: [
                        Checkbox(
                          checkColor: Colors.white,
                          fillColor:
                              MaterialStateProperty.resolveWith(getColor),
                          value: isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked = value!;
                            });
                          },
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        Text(
                          'Popular Blog',
                          style: _apptheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 10),
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
                          var uuid = const Uuid();
                          String version = uuid.v4();
                          DateTime date = DateTime.now();
                          String formattedDate =
                              DateFormat('EEEE').format(date);
                          blogModel.image =
                              'Blogs/$version/${pickedTaskFile!.name}';
                          blogModel.body = _blogBodyController.text;
                          blogModel.title = _blogtitleController.text;
                          blogModel.popular = isChecked;
                          blogModel.history =
                              '$formattedDate ${date.day}th, ${date.year}';
                          blogModel.publisher = 'Test';

                          setState(() {
                            uploadFile(version);
                          });
                          blogModel.createNewBlog(version);
                        },
                        child: Text(
                          'Create Blog',
                          style: _apptheme.titleLarge,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
