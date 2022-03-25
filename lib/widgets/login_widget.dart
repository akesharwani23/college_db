import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LogInWidget extends StatefulWidget {
  const LogInWidget({Key? key}) : super(key: key);
  @override
  State<LogInWidget> createState() => _LogInWidgetState();
}

class _LogInWidgetState extends State<LogInWidget> {
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
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim());
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
                          'Log In',
                          style: TextStyle(fontSize: 24),
                        ),
                      ))
                ]),
    );
  }
}
