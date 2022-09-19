import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:senior_project/Models/publishannouncement.dart';
import 'package:senior_project/Utils/constants.dart';
import 'package:senior_project/Utils/themes/app_theme.dart';
import 'package:senior_project/View-Model/providers/auth/userAuthenticator.dart';
import 'package:senior_project/View-Model/providers/public/theme_provider.dart';
import 'package:intl/intl.dart';

class CreateAnnouncements extends StatefulWidget {
  CreateAnnouncements({Key? key, required this.grade}) : super(key: key);
  String grade;
  @override
  State<CreateAnnouncements> createState() => _CreateAnnouncementsState();
}

class _CreateAnnouncementsState extends State<CreateAnnouncements> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  PublishAnnouncement pa = PublishAnnouncement(
      'tclass',
      '${DateFormat('EEEE').format(DateTime.now())} ${DateTime.now().day.toString()} ${DateTime.now().year.toString()} at ${DateTime.now().hour}:${DateTime.now().minute.toString()}:${DateTime.now().second.toString()} ',
      'message',
      'teacherId',
      'title');
  @override
  Widget build(BuildContext context) {
    var _apptheme = Provider.of<ThemeProvide>(context);
    String userSplit = context.read<UserAuthenticator>().useremail().toString();
    String userId = userSplit.substring(0, userSplit.indexOf('@'));
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
          actions: [
            TextButton(
                onPressed: () {
                  pa.tclass = widget.grade;
                  pa.teacherId = userId;
                  pa.title = titleController.text;
                  pa.message = messageController.text;
                  pa.SendAnnouncement();
                  Navigator.pop(context);
                },
                child: Text(
                  'Post',
                  style: GoogleFonts.roboto(
                      color: kprimary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ))
          ],
        ),
        body: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(
                height: 50,
                child: TextField(
                  style: _apptheme.getAppTheme.bodyMedium,
                  controller: titleController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: const Icon(Icons.title),
                    hintText: 'Title',
                    hintStyle: _apptheme.getAppTheme.bodyMedium,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 50,
                child: TextField(
                  style: _apptheme.getAppTheme.bodyMedium,
                  controller: messageController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: const Icon(Icons.message),
                    hintText: 'Announcement',
                    hintStyle: _apptheme.getAppTheme.bodyMedium,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
