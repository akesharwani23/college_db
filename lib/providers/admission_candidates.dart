import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_db/api/services_api.dart';
import 'package:flutter/material.dart';

import '../models/admission_candidate.dart';

class AdmissionCandidates with ChangeNotifier {
  final ServicesApi _api = ServicesApi('admissions');
  List<AdmissionCandidate> _cache = [];

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

  Stream<List<AdmissionCandidate>> get cachedCandidate async* {
    if (!_cache.isEmpty) {
      yield _cache;
    }
    final candidates = await getCandidates();
    _cache = candidates;
    yield candidates;
  }

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

  Future<void> updateCandidate(AdmissionCandidate candidate) async {
    if (candidate.id == null) {
      print('>>>>Candidate with no id provided');
      return; // FIXME: throw error that candidate with no id provided
    }
    _cache.removeWhere((element) => element.id == candidate.id);
    _cache.add(candidate);
    final ref = await _api.updateDocument(candidate.toMap(), candidate.id!);
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
