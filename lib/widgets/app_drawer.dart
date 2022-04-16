import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_db/providers/current_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
          StreamBuilder<CurrentUser?>(
            stream: Provider.of<CurrentUserProvider>(context).cachedUser,
            builder: (context, userStream) {
              if (userStream.connectionState == ConnectionState.active ||
                  userStream.connectionState == ConnectionState.done) {
                if (userStream.hasData) {
                  // got non-null currentUser
                  final user = userStream.data!;
                  return Text(
                    'Name: ${user.name}',
                    style: const TextStyle(
                        // color: Colors.white,
                        // fontWeight: FontWeight.bold,
                        fontSize: 18),
                  );
                }
              }
              return const SizedBox.shrink();
            },
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            child: ElevatedButton.icon(
              onPressed: _signOut,
              style: ElevatedButton.styleFrom(primary: Colors.transparent),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Sign out'),
            ),
          ),
        ]),
      ),
    );
  }
}
