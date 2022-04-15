import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CurrentUser {
  final String name;
  final bool isAdmin;
  final bool isVerified;

  CurrentUser(
      {required this.name, required this.isAdmin, required this.isVerified});

  static CurrentUser _fromDataObject(Map<String, dynamic> data) {
    return CurrentUser(
        name: data['name'],
        isAdmin: data['isAdmin'],
        isVerified: data['isVerified']);
  }

  static Future<CurrentUser> getCurrentUser() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    return CurrentUser._fromDataObject(snapshot.data()!);
  }
}
