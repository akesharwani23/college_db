import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({Key? key}) : super(key: key);

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  var _isLoading = false;
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _loginFunction() async {
    setState(() {
      _isLoading = true;
    });
    //TODO: Remove password trim?
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim());
    // FIXME: Before committing
    // String user_uid = FirebaseAuth.instance.currentUser!.uid;
    // var userData = {'name': 'ONE NAME', 'class': '8th', 'rollno': '300322'};
    // FirebaseFirestore.instance.collection('users').doc(user_uid).set(userData);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // backgroundColor: Colors.white,
      child: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                  // SizedBox(
                  //   height: 30,
                  // ),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 15),
                  TextField(
                    controller: _passwordController,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 15),
                  ElevatedButton(
                      onPressed: _loginFunction,
                      // onPressed: () => print('clicked'),
                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        margin: EdgeInsets.all(10),
                        child: const Text(
                          'SignUp',
                          style: TextStyle(fontSize: 24),
                        ),
                      ))
                ]),
    );
  }
}
