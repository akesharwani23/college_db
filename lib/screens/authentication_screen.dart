import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthenticationScreen extends StatefulWidget {
  AuthenticationScreen({Key? key}) : super(key: key);

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
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
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim());
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: SingleChildScrollView(
                child: Column(
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
                              'Log In',
                              style: TextStyle(fontSize: 24),
                            ),
                          ))
                    ]),
              ),
            ),
    );
  }
}
