import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_db/api/services_api.dart';
import 'package:flutter/material.dart';

import '../models/staff_member.dart';

class SupportingStaffMembers with ChangeNotifier {
  final ServicesApi _api = ServicesApi('supporting-staff');
  List<StaffMember> _cache = [];

  Future<List<StaffMember>> getMembers({final int limit = 10}) async =>
      await _api.getDataCollection
          .then((snapshots) => snapshots.docs)
          .then(((docSnapshots) => docSnapshots.map((element) {
                var member =
                    StaffMember.fromMap(element.data() as Map<String, dynamic>);
                member.id = element.id;
                return member;
              }).toList()));

  Stream<List<StaffMember>> get cachedMembers async* {
    if (_cache.isNotEmpty) {
      yield _cache;
    }
    final members = await getMembers();
    _cache = members;
    yield members;
  }

  Future<StaffMember?> getMember(String id) async {
    final snapshot = await _api.getDocumentById(id);
    if (snapshot.data() == null) {
      return null;
    }
    return StaffMember.fromMap(snapshot.data() as Map<String, dynamic>);
  }

  Stream<List<StaffMember>> getMembersWithNameStartingFrom(String name) {
    return _api.ref
        .where('name',
            isGreaterThanOrEqualTo: name.toUpperCase(),
            isLessThan: name.toUpperCase() + 'z')
        .snapshots()
        .map((event) {
      var docs = event.docs;
      return docs.map((doc) {
        var member = StaffMember.fromMap(doc.data() as Map<String, dynamic>);
        member.id = doc.id;
        return member;
      }).toList();
    });
  }

  Stream<List<StaffMember>> getMembersWithDepartmentAndSubDepartment(
      {required String department, required String subDepartment}) {
    return _api.ref
        .where('department', isEqualTo: department)
        .where('subDepartment', isEqualTo: subDepartment)
        .snapshots()
        .map((event) {
      var docs = event.docs;
      return docs.map((doc) {
        var member = StaffMember.fromMap(doc.data() as Map<String, dynamic>);
        member.id = doc.id;
        return member;
      }).toList();
    });
  }

  Future<DocumentReference> addMember(StaffMember member) async {
    final ref = await _api.addDocument(member.toMap());
    notifyListeners();
    return ref;
  }

  Future<void> updateMember(StaffMember member) async {
    if (member.id == null) {
      print('>>>>member with no id provided');
      return; // FIXME: throw error that member with no id provided
    }
    _cache.removeWhere((element) => element.id == member.id);
    _cache.add(member);
    final ref = await _api.updateDocument(member.toMap(), member.id!);
    notifyListeners();
    return ref;
  }

  Stream<List<StaffMember>> getMemberAsStream() {
    return _api.streamDataCollection.map((event) {
      var docs = event.docs;
      return docs.map((doc) {
        var member = StaffMember.fromMap(doc.data() as Map<String, dynamic>);
        member.id = doc.id;
        return member;
      }).toList();
    });
  }
}
