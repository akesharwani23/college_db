import 'package:college_db/screens/supporting_staff_search_by_department_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../screens/admission_search_by_date.dart';
import '../widgets/staff_search_by_name.dart';
import '../widgets/app_drawer.dart';
import '../widgets/search_admission_record.dart';
import '../widgets/supporting_staff_search_by_name.dart';
import './staff_search_by_department_screen.dart';
import './staff_section_screen.dart';
import './student_section_screen.dart';
import './supporting_staff_screen.dart';
import './admission_search_by_branch.dart';
import './admission_section_screen.dart';

class VerifiedHomeScreen extends StatefulWidget {
  const VerifiedHomeScreen({Key? key}) : super(key: key);

  @override
  State<VerifiedHomeScreen> createState() => _VerifiedHomeScreenState();
}

class _VerifiedHomeScreenState extends State<VerifiedHomeScreen> {
  List<Widget> _pages = [];
  List<String> _appBarTitle = [];
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
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: Text(_appBarTitle[_selectedPageIndex]),
        actions: [
          IconButton(
              onPressed: () {
                if (_selectedPageIndex == 0) {
                  _showSearchOptionsAdmissionSection();
                }
                if (_selectedPageIndex == 1) {
                  _showSearchOptionsStaffSection();
                }
                if (_selectedPageIndex == 2) {
                  _showSearchOptionsSupportingStaffSection();
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
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.graduationCap), label: 'Admission'),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.chalkboardUser), label: 'Staff'),
          BottomNavigationBarItem(
              icon: Icon(Icons.groups_rounded), label: 'Supporting Staff'),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.userGraduate),
              label: 'Student Section')
        ],
      ),
    );
  }

  void _showSearchOptionsAdmissionSection() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SizedBox(
            height: 200,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ListTile(
                    leading: const FaIcon(FontAwesomeIcons.solidAddressBook),
                    title: const Text('Search By Name'),
                    onTap: () {
                      Navigator.of(context).pop();
                      showSearch(
                          context: context, delegate: SearchAdmissionRecord());
                    },
                  ),
                  ListTile(
                    leading: const FaIcon(FontAwesomeIcons.graduationCap),
                    title: const Text('Search By Course & Branch'),
                    onTap: () {
                      Navigator.of(context)
                          .popAndPushNamed(AdmissionSearchByBranch.routeName);
                    },
                  ),
                  ListTile(
                    leading: const FaIcon(FontAwesomeIcons.calendarDays),
                    title: const Text('Search By Admission Date'),
                    onTap: () {
                      Navigator.of(context)
                          .popAndPushNamed(AdmissionSearchByDate.routeName);
                    },
                  ),
                ]),
          );
        });
  }

  void _showSearchOptionsStaffSection() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SizedBox(
            height: 140,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ListTile(
                    leading: const FaIcon(FontAwesomeIcons.solidAddressBook),
                    title: const Text('Search By Name'),
                    onTap: () {
                      Navigator.of(context).pop();
                      showSearch(
                          context: context, delegate: StaffSearchByName());
                    },
                  ),
                  ListTile(
                    leading: const FaIcon(FontAwesomeIcons.calendarDays),
                    title: const Text('Search By Department'),
                    onTap: () {
                      Navigator.of(context).popAndPushNamed(
                          StaffSearchByDepartmentScreen.routeName);
                    },
                  ),
                ]),
          );
        });
  }

  void _showSearchOptionsSupportingStaffSection() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SizedBox(
            height: 140,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ListTile(
                    leading: const FaIcon(FontAwesomeIcons.solidAddressBook),
                    title: const Text('Search By Name'),
                    onTap: () {
                      Navigator.of(context).pop();
                      showSearch(
                          context: context,
                          delegate: SupportingStaffSearchByName());
                    },
                  ),
                  ListTile(
                    leading: const FaIcon(FontAwesomeIcons.calendarDays),
                    title: const Text('Search By Department'),
                    onTap: () {
                      Navigator.of(context).popAndPushNamed(
                          SupportingStaffSearchByDepartmentScreen.routeName);
                    },
                  ),
                ]),
          );
        });
  }
}
