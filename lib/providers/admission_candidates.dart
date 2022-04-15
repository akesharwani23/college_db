import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_db/api/services_api.dart';
import 'package:flutter/material.dart';

import '../models/admission_candidate.dart';

class AdmissionCandidates with ChangeNotifier {
  final ServicesApi _api = ServicesApi('admissions');

  Future<List<AdmissionCandidate>> getCandidates(
          {final int limit = 10}) async =>
      await _api.getDataCollection
          .then((snapshots) => snapshots.docs)
          .then(((docSnapshots) => docSnapshots.map((element) {
                var candidate = AdmissionCandidate.fromMap(
                    element.data() as Map<String, dynamic>);
                candidate.id = element.id;
                return candidate;
              }).toList()));

  Future<AdmissionCandidate?> getCandidate(String id) async {
    final snapshot = await _api.getDocumentById(id);
    if (snapshot.data() == null) {
      return null;
    }
    return AdmissionCandidate.fromMap(snapshot.data() as Map<String, dynamic>);
  }

  Stream<List<AdmissionCandidate>> getCandidatesWithNameStartingFrom(
      String name) {
    return _api.ref
        .where('name',
            isGreaterThanOrEqualTo: name.toUpperCase(),
            isLessThan: name.toUpperCase() + 'z')
        .snapshots()
        .map((event) {
      var docs = event.docs;
      return docs.map((doc) {
        var candidate =
            AdmissionCandidate.fromMap(doc.data() as Map<String, dynamic>);
        candidate.id = doc.id;
        return candidate;
      }).toList();
    });
  }

  Future<DocumentReference> addCandidate(AdmissionCandidate candidate) async {
    final ref = await _api.addDocument(candidate.toMap());
    notifyListeners();
    return ref;
  }

  Stream<List<AdmissionCandidate>> getCandidateAsStream() {
    return _api.streamDataCollection.map((event) {
      var docs = event.docs;
      return docs.map((doc) {
        var candidate =
            AdmissionCandidate.fromMap(doc.data() as Map<String, dynamic>);
        candidate.id = doc.id;
        return candidate;
      }).toList();
    });
  }
}
