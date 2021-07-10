import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:subidha/screens/main_screen.dart';
import 'package:subidha/screens/welcome.dart';

class VerifyScreen extends StatefulWidget {
  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final auth = FirebaseAuth.instance;
  User user;
  Timer timer;

  @override
  void initState() {
    user = auth.currentUser;
    user.sendEmailVerification();

    Timer.periodic(Duration(seconds: 5), (timer) {
      checkEmailVerificed();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text('Email sent to ${user.email}'),
      ),
    );
  }

  Future<void> checkEmailVerificed() async {
    user = auth.currentUser;
    await user.reload();
    if (user.emailVerified){
      timer.cancel();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => WelcomePage()));
    }
  }
}
