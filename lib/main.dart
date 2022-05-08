import 'package:college_db/screens/supporting_staff_search_by_department_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import './providers/current_user.dart';
import './providers/staff_members.dart';
import './providers/supporting_staff_members.dart';
import './providers/admission_candidates.dart';

import './screens/admission_search_by_date.dart';
import './screens/staff_search_by_department_screen.dart';
import './screens/admission_detail_screen.dart';
import './screens/admission_form_screen.dart';
import './screens/admission_search_by_branch.dart';
import './screens/auth_screen.dart';
import './screens/home_screen.dart';
import './screens/staff_detail_screen.dart';
import './screens/staff_form_screen.dart';
import './screens/supporting_staff_detail_screen.dart';
import './screens/supporting_staff_form_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (_) => AdmissionCandidates(),
    ),
    ChangeNotifierProvider(
      create: (_) => CurrentUserProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => StaffMembers(),
    ),
    ChangeNotifierProvider(
      create: (_) => SupportingStaffMembers(),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const HomeScreen();
            } else {
              return AuthScreen();
            }
          }),
      theme: ThemeData(
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              // selectedItemColor: Colors.lightBlue,
              // selectedItemColor: Color.fromRGBO(1, 45, 120, 1),
              selectedItemColor: Color.fromARGB(255, 37, 143, 127),
              unselectedItemColor: Colors.grey),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color.fromARGB(255, 31, 162, 142),
          ),
          primaryColor: const Color.fromARGB(255, 19, 37, 41),
          // buttonColor: C,
          // rgba(19,37,41,255)
          backgroundColor: Colors.amberAccent,
          textTheme: GoogleFonts.robotoTextTheme(),
          appBarTheme: AppBarTheme(
              // color: Color.fromARGB(255, 31, 105, 162),
              color: Color.fromARGB(255, 37, 143, 127),
              titleTextStyle: GoogleFonts.roboto(
                  fontSize: 20, fontWeight: FontWeight.w400)),
          colorScheme:
              ColorScheme.fromSwatch().copyWith(secondary: Colors.pinkAccent)),
      routes: {
        AdmissionFormScreen.routeName: (ctx) => const AdmissionFormScreen(),
        AdmissionDetailScreen.routeName: (ctx) => const AdmissionDetailScreen(),
        StaffFormScreen.routeName: (ctx) => const StaffFormScreen(),
        StaffDetailScreen.routeName: (ctx) => const StaffDetailScreen(),
        SupportingStaffDetailScreen.routeName: (ctx) =>
            const SupportingStaffDetailScreen(),
        SupportingStaffFormScreen.routeName: (ctx) =>
            const SupportingStaffFormScreen(),
        StaffSearchByDepartmentScreen.routeName: (ctx) =>
            const StaffSearchByDepartmentScreen(),
        AdmissionSearchByDate.routeName: (ctx) => const AdmissionSearchByDate(),
        AdmissionSearchByBranch.routeName: (ctx) =>
            const AdmissionSearchByBranch(),
        SupportingStaffSearchByDepartmentScreen.routeName: (ctx) =>
            const SupportingStaffSearchByDepartmentScreen(),
      },
    );
  }
}
