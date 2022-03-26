import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_db/models/admission_candidate.dart';
import 'package:college_db/screens/admission_form_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/app_drawer.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: Text('CollegeDB'),
      ),
      body: ElevatedButton.icon(
        onPressed: () {
          Navigator.of(context).pushNamed(AdmissionFormScreen.routeName);
        },
        icon: Icon(Icons.add),
        label: Text('Add Admission Record'),
      ),
    );
  }
}
