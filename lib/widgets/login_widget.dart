import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LogInWidget extends StatefulWidget {
  const LogInWidget({Key? key}) : super(key: key);
  @override
  State<LogInWidget> createState() => _LogInWidgetState();
}

class _LogInWidgetState extends State<LogInWidget> {
  final _formKey = GlobalKey<FormState>();
  var _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;

  _showErrorDialogBox(BuildContext context, String title, String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Row(
                children: [
                  Icon(
                    Icons.error,
                    color: Colors.red,
                  ),
                  Text(
                    title,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
              content: Text(message),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Okay'))
              ],
            ));
  }

  void _loginFunction() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      //TODO: Remove password trim?
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _authData['email']!.trim(),
            password: _authData['password']!.trim());
      } on FirebaseAuthException catch (error) {
        _showErrorDialogBox(context, error.code.replaceAll('-', ' '),
            error.code.replaceAll('-', ' '));
        print('>>>>${_authData['email']} ${_authData['password']}');
      }
    }
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
          : Form(
              key: _formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // SizedBox(
                    //   height: 30,
                    // ),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Empty Field';
                        }
                      },
                      onSaved: (value) {
                        _authData['email'] = value as String;
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Empty Field';
                        }
                      },
                      onSaved: (value) {
                        _authData['password'] = value as String;
                      },
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
                            'Log In',
                            style: TextStyle(fontSize: 24),
                          ),
                        ))
                  ]),
            ),
    );
  }
}
