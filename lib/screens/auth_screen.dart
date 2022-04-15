import 'dart:io';

import 'package:college_db/widgets/login_widget.dart';
import 'package:college_db/widgets/signup_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var _isLogin = false;

  void _toggle() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _isLogin ? LogInWidget() : SignUpWidget(),
              TextButton(
                  onPressed: _toggle,
                  child: Text('${!_isLogin ? "login" : "signup"} Instead'))
            ],
          ),
        ));
  }
}
