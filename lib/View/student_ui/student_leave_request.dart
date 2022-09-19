import 'dart:developer';
import 'dart:io';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:senior_project/Models/petition_request.dart';
import 'package:senior_project/Utils/constants.dart';
import 'package:senior_project/Utils/themes/app_theme.dart';
import 'package:senior_project/View-Model/providers/auth/userAuthenticator.dart';
import 'package:senior_project/View-Model/providers/public/theme_provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class StudentLeaveRequest extends StatefulWidget {
  const StudentLeaveRequest({Key? key}) : super(key: key);

  @override
  State<StudentLeaveRequest> createState() => _StudentLeaveRequestState();
}

class _StudentLeaveRequestState extends State<StudentLeaveRequest> {
  String _selectedDate = '';
  String _dateCount = '';
  String fromDate = 'First Day of Leave';
  String toDate = 'Last Day of Leave';
  String range = '';
  String theRange = '';
  String _rangeCount = '4';
  TextEditingController detailsController = TextEditingController();
  TextEditingController causeController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  DateRangePickerController calController = DateRangePickerController();
  PlatformFile? pickedTaskFile;
  Future pickTask() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        pickedTaskFile = result.files.first;
      });
    } else {}
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    /// The argument value will return the changed date as [DateTime] when the
    /// widget [SfDateRangeSelectionMode] set as single.
    ///
    /// The argument value will return the changed dates as [List<DateTime>]
    /// when the widget [SfDateRangeSelectionMode] set as multiple.
    ///
    /// The argument value will return the changed range as [PickerDateRange]
    /// when the widget [SfDateRangeSelectionMode] set as range.
    ///
    /// The argument value will return the changed ranges as
    /// [List<PickerDateRange] when the widget [SfDateRangeSelectionMode] set as
    /// multi range.
    setState(() {
      if (args.value is PickerDateRange) {
        range = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
            // ignore: lines_longer_than_80_chars
            ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
        fromDate = DateFormat('yyyy/MM/dd').format(args.value.startDate);
        toDate = DateFormat('yyyy/MM/dd')
            .format(args.value.endDate ?? args.value.startDate);
      } else if (args.value is DateTime) {
        _selectedDate = args.value.toString();
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    calController.dispose();
    detailsController.dispose();
    causeController.dispose();
    typeController.dispose();
    super.dispose();
  }

  var uuid = const Uuid();

  @override
  Widget build(BuildContext context) {
    String userSplit = context.read<UserAuthenticator>().useremail().toString();
    String userId = userSplit.substring(0, userSplit.indexOf('@'));
    Future uploadFile() async {
      final path = 'petitions/$userId';
      final file = File(pickedTaskFile!.path!);
      final ref = FirebaseStorage.instance.ref().child(path);
      ref.putFile(file);
    }

    var _apptheme = Provider.of<ThemeProvide>(context);
    return SafeArea(
      child: Scaffold(
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
          body: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Absence Request',
                    style: _apptheme.getAppTheme.bodyLarge,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                        boxShadow: _apptheme.getAppTheme == AppTheme.lightMode
                            ? [kboxshadow2]
                            : [kboxshadow3],
                        borderRadius: kcircular,
                        color: _apptheme.getAppTheme == AppTheme.lightMode
                            ? kwhite
                            : darkModeContainers),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                  borderRadius: kbottomcircular,
                                  color: _apptheme.getAppTheme ==
                                          AppTheme.lightMode
                                      ? kprimary
                                      : kblack),
                              child: Icon(
                                FontAwesomeIcons.teletype,
                                color: kwhite,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Type',
                                  style: GoogleFonts.roboto(
                                      color: _apptheme.getAppTheme ==
                                              AppTheme.lightMode
                                          ? Colors.black.withOpacity(0.7)
                                          : Colors.white.withOpacity(0.7),
                                      fontWeight: FontWeight.bold,
                                      fontSize: _apptheme
                                          .getAppTheme.bodyMedium.fontSize),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 30,
                                  width: 220,
                                  child: TextField(
                                    style: _apptheme.getAppTheme.bodyMedium,
                                    controller: typeController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Type of Petition',
                                      hintStyle:
                                          _apptheme.getAppTheme.bodyMedium,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Divider(
                          thickness: 2,
                          color: kblack,
                        ),
                        Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                  borderRadius: kbottomcircular,
                                  color: _apptheme.getAppTheme ==
                                          AppTheme.lightMode
                                      ? kprimary
                                      : kblack),
                              child: Icon(
                                FontAwesomeIcons.teletype,
                                color: kwhite,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Cause',
                                  style: GoogleFonts.roboto(
                                      color: _apptheme.getAppTheme ==
                                              AppTheme.lightMode
                                          ? Colors.black.withOpacity(0.7)
                                          : Colors.white.withOpacity(0.7),
                                      fontWeight: FontWeight.bold,
                                      fontSize: _apptheme
                                          .getAppTheme.bodyMedium.fontSize),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 30,
                                  width: 220,
                                  child: TextField(
                                    style: _apptheme.getAppTheme.bodyMedium,
                                    controller: causeController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintStyle:
                                          _apptheme.getAppTheme.bodyMedium,
                                      hintText: 'Cause of Petition',
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Divider(
                          thickness: 2,
                          color: kblack,
                        ),
                        Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                  borderRadius: kbottomcircular,
                                  color: _apptheme.getAppTheme ==
                                          AppTheme.lightMode
                                      ? kprimary
                                      : kblack),
                              child: Icon(
                                FontAwesomeIcons.teletype,
                                color: kwhite,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'from',
                                  style: GoogleFonts.roboto(
                                      color: _apptheme.getAppTheme ==
                                              AppTheme.lightMode
                                          ? Colors.black.withOpacity(0.7)
                                          : Colors.white.withOpacity(0.7),
                                      fontWeight: FontWeight.bold,
                                      fontSize: _apptheme
                                          .getAppTheme.bodyMedium.fontSize),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  fromDate,
                                  style: _apptheme.getAppTheme.bodyMedium,
                                )
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Divider(
                          thickness: 2,
                          color: kblack,
                        ),
                        SfDateRangePicker(
                          onSelectionChanged: _onSelectionChanged,
                          rangeSelectionColor: kprimary.withOpacity(0.2),
                          startRangeSelectionColor: kprimary,
                          endRangeSelectionColor: kprimary,
                          selectionColor: kprimary,
                          controller: calController,
                          backgroundColor:
                              _apptheme.getAppTheme == AppTheme.lightMode
                                  ? Theme.of(context).scaffoldBackgroundColor
                                  : darkModeContainers,
                          todayHighlightColor: kwhite,
                          selectionMode: DateRangePickerSelectionMode.range,
                          initialSelectedRange: PickerDateRange(
                              DateTime.now().subtract(const Duration(days: 4)),
                              DateTime.now().add(const Duration(days: 3))),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Divider(
                          thickness: 2,
                          color: kblack,
                        ),
                        Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                  borderRadius: kbottomcircular,
                                  color: _apptheme.getAppTheme ==
                                          AppTheme.lightMode
                                      ? kprimary
                                      : kblack),
                              child: Icon(
                                FontAwesomeIcons.teletype,
                                color: kwhite,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'to',
                                  style: GoogleFonts.roboto(
                                      color: _apptheme.getAppTheme ==
                                              AppTheme.lightMode
                                          ? Colors.black.withOpacity(0.7)
                                          : Colors.white.withOpacity(0.7),
                                      fontWeight: FontWeight.bold,
                                      fontSize: _apptheme
                                          .getAppTheme.bodyMedium.fontSize),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  toDate,
                                  style: _apptheme.getAppTheme.bodyMedium,
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Divider(
                          thickness: 2,
                          color: kblack,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                      borderRadius: kbottomcircular,
                                      color: _apptheme.getAppTheme ==
                                              AppTheme.lightMode
                                          ? kprimary
                                          : kblack),
                                  child: Icon(
                                    FontAwesomeIcons.teletype,
                                    color: kwhite,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Details',
                                      style: GoogleFonts.roboto(
                                          color: _apptheme.getAppTheme ==
                                                  AppTheme.lightMode
                                              ? Colors.black.withOpacity(0.7)
                                              : Colors.white.withOpacity(0.7),
                                          fontWeight: FontWeight.bold,
                                          fontSize: _apptheme
                                              .getAppTheme.bodyMedium.fontSize),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 100,
                              width: 300,
                              child: TextField(
                                onEditingComplete: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                },
                                controller: detailsController,
                                style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20,
                                    color: _apptheme.getAppTheme ==
                                            AppTheme.lightMode
                                        ? kblack
                                        : kwhite),
                                maxLines: 10,
                                decoration: InputDecoration(
                                  focusColor: kprimary,
                                  border: InputBorder.none,
                                  hintStyle: _apptheme.getAppTheme.bodyMedium,
                                  hintText:
                                      'Write down details for your leave...',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Divider(
                          thickness: 2,
                          color: kblack,
                        ),
                        Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                  borderRadius: kbottomcircular,
                                  color: _apptheme.getAppTheme ==
                                          AppTheme.lightMode
                                      ? kprimary
                                      : kblack),
                              child: Icon(
                                FontAwesomeIcons.teletype,
                                color: kwhite,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: pickTask,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Attachments',
                                    style: GoogleFonts.roboto(
                                        color: _apptheme.getAppTheme ==
                                                AppTheme.lightMode
                                            ? Colors.black.withOpacity(0.7)
                                            : Colors.white.withOpacity(0.7),
                                        fontWeight: FontWeight.bold,
                                        fontSize: _apptheme
                                            .getAppTheme.bodyMedium.fontSize),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 80,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        gradient: _apptheme.getAppTheme == AppTheme.lightMode
                            ? kmix
                            : lightkmix,
                        borderRadius: kcircular),
                    child: MaterialButton(
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        PetitionRequest pq = PetitionRequest(
                            typeController.text,
                            causeController.text,
                            fromDate,
                            toDate,
                            detailsController.text.toString(),
                            userId,
                            uuid.v1(),
                            'petitions/$userId/${pickedTaskFile!.name.toString()}');
                        uploadFile();
                        pq.sendRequest();
                      },
                      child: Text(
                        'Apply for Leave',
                        style: _apptheme.getAppTheme.titleLarge,
                      ),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
