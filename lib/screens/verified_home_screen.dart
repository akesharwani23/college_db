import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/app_drawer.dart';
import 'admission_section_screen.dart';

class VerifiedHomeScreen extends StatefulWidget {
  const VerifiedHomeScreen({Key? key}) : super(key: key);

  @override
  State<VerifiedHomeScreen> createState() => _VerifiedHomeScreenState();
}

class _VerifiedHomeScreenState extends State<VerifiedHomeScreen> {
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
