import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({Key? key}) : super(key: key);

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final _formKey = GlobalKey<FormState>();
  var _isLoading = false;
  // @override
  // void dispose() {
  //   _emailController.dispose();
  //   _passwordController.dispose();
  //   super.dispose();
  // }

  Map<String, String> _authData = {'email': '', 'password': '', 'name': ''};

  void _loginFunction() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      try {
        //TODO: Remove password trim?
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _authData['email']!.trim(),
                password: _authData['password']!.trim());
        String user_uid = FirebaseAuth.instance.currentUser!.uid;
        FirebaseFirestore.instance.collection('users').doc(user_uid).set({
          'name': _authData['name']!.trim(),
          'isVerified': false,
          'isAdmin': false
        });
      } catch (error) {
        print(error);
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // backgroundColor: Colors.white,
      child: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Name',
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Field Empty';
                          }
                        },
                        onSaved: (value) {
                          _authData['name'] = value as String;
                        },
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                        ),
                        onSaved: (value) {
                          _authData['email'] = value as String;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Field Empty';
                          } else if (!value.contains('@')) {
                            return 'Invalid EmailID'; //FIXME: cover other cases also
                          }
                        },
                        textInputAction: TextInputAction.next,
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                        ),
                        onSaved: (value) {
                          _authData['password'] = value as String;
                        },
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Field Empty';
                          }
                        },
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
                              'Sign Up',
                              style: TextStyle(fontSize: 24),
                            ),
                          ))
                    ]),
              ),
            ),
    );
  }
}
