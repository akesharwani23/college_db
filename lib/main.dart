import 'package:college_db/providers/current_user.dart';
import 'package:college_db/screens/admission_detail_screen.dart';
import 'package:college_db/screens/admission_form_screen.dart';
import 'package:college_db/screens/auth_screen.dart';
import 'package:college_db/screens/home_screen.dart';
import 'package:college_db/screens/staff_form_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/admission_candidates.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (_) => AdmissionCandidates(),
    ),
    ChangeNotifierProvider(create: (_) => CurrentUserProvider()),
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
              return HomeScreen();
            } else {
              return AuthScreen();
            }
          }),
      theme: ThemeData(
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              selectedItemColor: Colors.lightBlue,
              unselectedItemColor: Colors.grey),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.amber),
          primaryColor: const Color.fromARGB(255, 19, 37, 41),
          // buttonColor: C,
          // rgba(19,37,41,255)
          backgroundColor: Colors.amberAccent,
          colorScheme:
              ColorScheme.fromSwatch().copyWith(secondary: Colors.pinkAccent)),
      routes: {
        AdmissionFormScreen.routeName: (ctx) => const AdmissionFormScreen(),
        AdmissionDetailScreen.routeName: (ctx) => const AdmissionDetailScreen(),
        StaffFormScreen.routeName: (ctx) => const StaffFormScreen(),
      },
    );
  }
}
