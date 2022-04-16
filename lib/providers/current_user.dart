import 'dart:convert';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_db/api/services_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    final user = CurrentUser.fromMap(snapshot.data() as Map<String, dynamic>);
    _cacheUserData(user);
    return user;
  }

  Stream<CurrentUser?> get cachedUser async* {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('userData')) {
      yield CurrentUser.fromMap(
          json.decode(prefs.getString('userData') as String)
              as Map<String, dynamic>);
    }
    yield await getCurrentUser;
  }

  void _cacheUserData(CurrentUser user) async {
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode(user.toMap());
    prefs.setString('userData', userData);
    // notifyListeners();
  }

  Future<void> createUser(String id, CurrentUser user) async {
    final ref = await _api.ref.doc(id).set(user.toMap());
    // final ref = await _api.addDocument(user.toMap());
    _cacheUserData(user);
    notifyListeners();
    return ref;
  }
}
