import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_db/providers/current_user.dart';
import 'package:college_db/screens/verified_home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CurrentUser?>(
        future: Provider.of<CurrentUserProvider>(context).getCurrentUser,
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.done) {
            if (userSnapshot.hasData) {
              // got a not-null CurrentUser
              final user = userSnapshot.data!;
              if (user.isVerified) {
                return const VerifiedHomeScreen();
              } else {
                return Scaffold(
                  appBar: AppBar(title: const Text('Not Verified')),
                  drawer: const AppDrawer(),
                  body: Center(
                      child: Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.red)),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'This Account Is Not Verified',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  )),
                );
              }
            }
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
