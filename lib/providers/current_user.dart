import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_db/api/services_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CurrentUser {
  final String name;
  final bool isAdmin;
  final bool isVerified;

  CurrentUser(
      {required this.name, this.isAdmin = false, this.isVerified = false});

  factory CurrentUser.fromMap(Map<String, dynamic> map) {
    return CurrentUser(
        name: map['name'],
        isAdmin: map['isAdmin'],
        isVerified: map['isVerified']);
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'isAdmin': isAdmin, 'isVerified': isVerified};
  }
}

class CurrentUserProvider with ChangeNotifier {
  final ServicesApi _api = ServicesApi('users');

  Future<CurrentUser?> get getCurrentUser async {
    final auth = FirebaseAuth.instance;
    if (auth.currentUser == null || auth.currentUser!.uid.isEmpty) {
      return null;
    }
    final snapshot = await _api.getDocumentById(auth.currentUser!.uid);
    if (snapshot.data() == null) {
      return null;
    }
    return CurrentUser.fromMap(snapshot.data() as Map<String, dynamic>);
  }

  Future<void> createUser(String id, CurrentUser user) async {
    final ref = await _api.ref.doc(id).set(user.toMap());
    // final ref = await _api.addDocument(user.toMap());
    notifyListeners();
    return ref;
  }
}
