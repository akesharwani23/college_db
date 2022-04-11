import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_db/models/admission_candidate.dart';
import 'package:college_db/screens/admission_form_screen.dart';
import 'package:college_db/screens/admission_section_screen.dart';
import 'package:college_db/screens/verified_home_screen.dart';
import 'package:college_db/widgets/home_option_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/app_drawer.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            final data =
                snapshot.data as DocumentSnapshot<Map<String, dynamic>>;
            if (data['isVerified']) {
              return VerifiedHomeScreen();
            } else {
              return Scaffold(
                appBar: AppBar(title: Text('Not Verified')),
                drawer: AppDrawer(),
                body: Center(
                    child: Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.red)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'This Account Is Not Verified',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                )),
              );
            }
          }
          return Text('fixme'); //FIXME:
        });
  }
}
