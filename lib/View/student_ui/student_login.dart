// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:senior_project/Utils/constants.dart';
import 'package:senior_project/Utils/loading/loadinganimations.dart';
import 'package:senior_project/Utils/themes/app_theme.dart';
import 'package:senior_project/View-Model/providers/auth/userAuthenticator.dart';
import 'package:senior_project/View-Model/providers/auth/user_control.dart';
import 'package:senior_project/View/packages/background.dart';
import 'package:unicons/unicons.dart';

class LoginTest extends StatefulWidget {
  const LoginTest({Key? key}) : super(key: key);

  @override
  State<LoginTest> createState() => _LoginTestState();
}

class _LoginTestState extends State<LoginTest>
    with SingleTickerProviderStateMixin {
  final TextEditingController idController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
  final _idFormkey = GlobalKey<FormState>();
  final _pwFormkey = GlobalKey<FormState>();
  final key1 = GlobalKey<AnimatedListState>();
  bool _showpassword = false;
  void iniState() {
    super.initState();
  }

  @override
  void dispose() {
    idController.dispose();
    pwController.dispose();
    super.dispose();
  }

// ignore: non_constant_identifier_names
  DateTime pre_backpress = DateTime.now();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: SafeArea(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            body: Background(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      "LOGIN",
                      style: GoogleFonts.roboto(
                          fontWeight: FontWeight.bold,
                          color: ksecondary,
                          fontSize: 36),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    child: Form(
                      key: _idFormkey,
                      child: TextFormField(
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Please enter your ID';
                          } else if (v.length > 8) {
                            return 'Please enter a valid ID';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp('[0-9.,]'))
                        ],
                        controller: idController,
                        decoration: const InputDecoration(
                            icon: Icon(UniconsLine.user), labelText: "ID"),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    child: Form(
                      key: _pwFormkey,
                      child: TextFormField(
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return ' Please enter your password';
                          }
                          return null;
                        },
                        controller: pwController,
                        decoration: InputDecoration(
                          labelText: "Password",
                          icon: const Icon(UniconsLine.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _showpassword == true
                                  ? FontAwesomeIcons.eye
                                  : FontAwesomeIcons.eyeSlash,
                              size: 15,
                            ),
                            onPressed: () {
                              setState(() {
                                if (_showpassword == false) {
                                  _showpassword = true;
                                } else {
                                  _showpassword = false;
                                }
                              });
                            },
                          ),
                        ),
                        obscureText: _showpassword == false ? true : false,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 10),
                    child: Text(
                      "Forgot your password?",
                      style:
                          GoogleFonts.roboto(fontSize: 13, color: ksecondary),
                    ),
                  ),
                  SizedBox(height: size.height * 0.05),
                  Container(
                    alignment: Alignment.centerRight,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 10),
                    child: Container(
                        decoration: const BoxDecoration(boxShadow: [
                          BoxShadow(
                            blurRadius: 30.0,
                            offset: Offset(20, 20),
                            color: Colors.grey,
                          ),
                          BoxShadow(
                            blurRadius: 30.0,
                            offset: Offset(-20, -20),
                            color: Colors.white,
                          )
                        ]),
                        child: context.watch<LoadingControl>().getLogger == false
                            ? RaisedButton(
                                onPressed: () {
                                  if (_idFormkey.currentState!.validate() &&
                                      _pwFormkey.currentState!.validate()) {
                                    setState(() {
                                      context.read<LoadingControl>().setLogger =
                                          true;
                                    });
                                    context
                                        .read<UserAuthenticator>()
                                        .signInWithEmailandPassword(
                                            idController.text,
                                            pwController.text,
                                            context);
                                  }
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(80.0)),
                                textColor: kwhite,
                                padding: const EdgeInsets.all(0),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 600),
                                  curve: Curves.easeInBack,
                                  alignment: Alignment.center,
                                  height: 50.0,
                                  width: size.width * 0.5,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(80.0),
                                      gradient: LinearGradient(
                                          colors: [ksecondary, kprimary])),
                                  padding: const EdgeInsets.all(0),
                                  child: Text(
                                    "LOGIN",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                ),
                              )
                            : AnimatedContainer(
                                curve: Curves.bounceInOut,
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle, color: ksecondary),
                                duration: const Duration(milliseconds: 500),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: kwhite,
                                  ),
                                ),
                              )),
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
