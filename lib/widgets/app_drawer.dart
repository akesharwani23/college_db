import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  Future<String> _getUserEmail() async {
    String email = await FirebaseAuth.instance.currentUser!.email as String;
    return email;
  }

  Future<String> _getName() async {
    var value = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    return value['name'];
  }

  void _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: Column(children: [
          Stack(
            children: [
              Container(
                height: 110,
                width: double.infinity,
              ),
              FutureBuilder(
                future: _getUserEmail(),
                builder: (ctx, text) => Text(
                  'Email: ${text.data}',
                  style: TextStyle(
                      // color: Colors.white,
                      // fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
            ],
            alignment: Alignment.bottomCenter,
          ),
          FutureBuilder(
            future: _getName(),
            builder: (ctx, text) => Text(
              text.connectionState == ConnectionState.done
                  ? 'Name: ${text.data}'
                  : '',
              style: TextStyle(
                  // color: Colors.white,
                  // fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(8),
            child: ElevatedButton.icon(
              onPressed: _signOut,
              style: ElevatedButton.styleFrom(primary: Colors.transparent),
              icon: Icon(Icons.arrow_back),
              label: Text('Sign out'),
            ),
          ),
        ]),
      ),
    );
  }
}
