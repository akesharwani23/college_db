import 'package:college_db/screens/staff_section_screen.dart';
import 'package:college_db/screens/student_section_screen.dart';
import 'package:college_db/screens/supporting_staff_screen.dart';
import 'package:flutter/material.dart';

import '../widgets/app_drawer.dart';
import '../widgets/search_admission_record.dart';
import 'admission_section_screen.dart';

class VerifiedHomeScreen extends StatefulWidget {
  const VerifiedHomeScreen({Key? key}) : super(key: key);

  @override
  State<VerifiedHomeScreen> createState() => _VerifiedHomeScreenState();
}

class _VerifiedHomeScreenState extends State<VerifiedHomeScreen> {
  List<Widget> _pages = [];
  List<String> _appBarTitle = [];
  // List<Map<String, dynamic>> _value = [{}];
  int _selectedPageIndex = 0;

  @override
  void initState() {
    _appBarTitle = [
      'Admission Section',
      'Staff Section',
      'Support Staff Section',
      'Student Section'
    ];
    _pages = [
      const AdmissionSectionScreen(),
      const StaffSectionScreen(),
      const SupportingStaffScreen(),
      const StudentSectionScreen(),
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
        title: Text(_appBarTitle[_selectedPageIndex]),
        actions: [
          IconButton(
              onPressed: () {
                if (_selectedPageIndex == 0) {
                  showSearch(
                      context: context, delegate: SearchAdmissionRecord());
                }
              },
              icon: const Icon(Icons.search))
        ],
      ),
      body: _pages[_selectedPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Admission'),
          BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Staff'),
          BottomNavigationBarItem(
              icon: Icon(Icons.groups_rounded), label: 'Supporting Staff'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: 'Student Section')
        ],
      ),
    );
  }
}
