// ignore: duplicate_ignore
// ignore: file_names
// ignore_for_file: file_names

import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senior_project/Utils/constants.dart';
import 'package:senior_project/Utils/loading/loadinganimations.dart';
import 'package:senior_project/View-Model/providers/auth/user_control.dart';

class UserAuthenticator {
  late final FirebaseAuth _firebaseAuth;
  UserAuthenticator(this._firebaseAuth);
    final key1 = GlobalKey<AnimatedListState>();
  Stream<User?> get authStateChanges => _firebaseAuth.idTokenChanges();
  Future<String?> signInWithEmailandPassword(
      String id, String password, BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: '$id@apollosis.com', password: password);
 context.read<LoadingControl>().setLogger = false;
      Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AnimatedLoading(key: key1)));
      log('Successfully Signed In');

      return 'Successfully Signed In';
    } on FirebaseAuthException catch (e) {
      context.read<LoadingControl>().setLogger = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: ksecondary,
          content: const Text('Login Failed! Please Try Again later'),
          action: SnackBarAction(
            label: 'Ok',
            textColor: kwhite,
            onPressed: () {
              // Some code to undo the change.
            },
          )));
      return e.message;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  User? userCheck() {
    return _firebaseAuth.currentUser;
  }

  String? useremail() {
    final User? user = _firebaseAuth.currentUser;
    if (user!.email == null) {
      return 'Error';
    }
    final email = user.email;
    return email;
  }
}
