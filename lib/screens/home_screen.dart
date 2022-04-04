import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_db/models/admission_candidate.dart';
import 'package:college_db/screens/admission_form_screen.dart';
import 'package:college_db/screens/admission_section_screen.dart';
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
  final user = FirebaseAuth.instance.currentUser;
  List<Widget> _pages = [];
  List<String> _titles = ['One', 'Staff Section'];
  List<Map<String, dynamic>> _value = [{}];
  int _selectedPageIndex = 0;

  @override
  void initState() {
    _titles = ['Admission Section', 'Staff Section'];
    _pages = [
      AdmissionSectionScreen(),
      Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.info,
              color: Colors.red,
            ),
            Text(
              'Currently Unavailable',
              style: TextStyle(color: Colors.red),
            )
          ],
        ),
      )
    ];
    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[300],
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: Text(_titles[_selectedPageIndex]),
      ),
      body: _pages[_selectedPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Admission'),
          BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Staff'),
        ],
      ),
    );
  }
}
