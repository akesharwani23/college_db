import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  Future<String> _getUserEmail() async {
    String email = await FirebaseAuth.instance.currentUser!.email as String;
    return email;
  }

  void _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: [
        Stack(
          children: [
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.blue,
            ),
            FutureBuilder(
              future: _getUserEmail(),
              builder: (ctx, text) => Text(
                '${text.data}',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24),
              ),
            ),
          ],
          alignment: Alignment.bottomCenter,
        ),
        Container(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _signOut,
            icon: Icon(Icons.arrow_back),
            label: Text('Sign out'),
          ),
        ),
      ]),
    );
  }
}
