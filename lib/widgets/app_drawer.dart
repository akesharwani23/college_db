import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_db/providers/current_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
      child: Column(children: [
        const SizedBox(
          height: 80,
        ),
        const CircleAvatar(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white70,
          minRadius: 52,
          child: FaIcon(
            FontAwesomeIcons.userAstronaut,
            size: 65,
          ),
        ),
        Stack(
          children: [
            const SizedBox(
              height: 40,
              width: double.infinity,
            ),
            FutureBuilder(
              future: _getUserEmail(),
              builder: (ctx, text) => Text(
                'Email: ${text.data}',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
          alignment: Alignment.bottomCenter,
        ),
        const SizedBox(
          height: 4,
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
    );
  }
}
