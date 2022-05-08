import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_db/api/services_api.dart';
import 'package:flutter/material.dart';

import '../models/admission_candidate.dart';

class AdmissionCandidates with ChangeNotifier {
  final ServicesApi _api = ServicesApi('admissions');
  List<AdmissionCandidate> _cache = [];

  List<AdmissionCandidate> get candidateCache => _cache;
  // List<DocumentSnapshot<Object?>> _cachedSnapshots = [];

  // Future<List<AdmissionCandidate>> getCandidates(
  //         {final int limit = 10}) async =>
  //     await _api.getDataCollection
  //         .then((snapshots) => snapshots.docs)
  //         .then(((docSnapshots) => docSnapshots.map((element) {
  //               var candidate = AdmissionCandidate.fromMap(
  //                   element.data() as Map<String, dynamic>);
  //               candidate.id = element.id;
  //               return candidate;
  //             }).toList()));

  /// returns [List] of [AdmissionCandidate]
  /// limited by parameter [limit] ordered by ['admissionDate'].
  /// By default return [List] of maximum 10 [AdmissionCandidate]
  Stream<List<AdmissionCandidate>> getCandidates({final int limit = 10}) {
    return _api.ref
        .orderBy('admissionDate', descending: true)
        .limit(limit)
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

  Stream<List<AdmissionCandidate>> get cachedCandidate async* {
    if (_cache.isNotEmpty) {
      yield _cache;
    }
    final candidates = getCandidates();
    candidates.listen((value) {
      _cache = value;
    });
    yield* candidates;
  }

  void updateCache() {}

  Future<AdmissionCandidate?> getCandidate(String id) async {
    final snapshot = await _api.getDocumentById(id);
    if (snapshot.data() == null) {
      return null;
    }
    return AdmissionCandidate.fromMap(snapshot.data() as Map<String, dynamic>);
  }

  Stream<List<AdmissionCandidate>> getCandidatesWithNameStartingFrom(
      String name) {
    //TODO: can be optimized for loadMore (PAGINATION)
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

  //FIXME: set limit = 10
  Stream<List<AdmissionCandidate>> getCandidatesWithStatus({
    String status = "Confirmed",
    int limit = 10,
    AdmissionCandidate? startAfter,
  }) {
    final query = _api.ref
        .orderBy('admissionDate', descending: true)
        .orderBy('name')
        .where('status', isEqualTo: status)
        .limit(limit);
    final Stream<QuerySnapshot<Object?>> response;
    if (startAfter == null) {
      response = query.snapshots();
    } else {
      // response = query
      //     .startAfter([startAfter.admissionDate.toIso8601String()]).snapshots();
      response = query.startAfter([
        startAfter.admissionDate.toIso8601String(),
        startAfter.name
      ]).snapshots();
    }

    return response.map((event) {
      var docs = event.docs;
      return docs.map((doc) {
        var candidate =
            AdmissionCandidate.fromMap(doc.data() as Map<String, dynamic>);
        candidate.id = doc.id;
        return candidate;
      }).toList();
    });
  }

  Stream<List<AdmissionCandidate>> getCandidatesWithCourseName(String course) {
    return _api.ref
        // .where('course',
        //     isGreaterThanOrEqualTo: course, isLessThan: course + 'z')
        .where('course', isEqualTo: course)
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

  Stream<List<AdmissionCandidate>> getCandidatesWithCourseAndBranchName(
      String course, String branch) {
    return _api.ref
        .where('course', isEqualTo: course)
        .where('branch', isEqualTo: branch)
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

  Stream<List<AdmissionCandidate>> getCandidatesWithAdmissionDate(
    String date, {
    int limit = 10,
    AdmissionCandidate? startAfter,
  }) {
    final query = _api.ref
        // .orderBy('admissionDate', descending: true)
        .orderBy('branch')
        .orderBy('name')
        .where('admissionDate', isEqualTo: date)
        .limit(limit);

    final Stream<QuerySnapshot<Object?>> response;
    if (startAfter == null) {
      response = query.snapshots();
    } else {
      response =
          query.startAfter([startAfter.branch, startAfter.name]).snapshots();
    }

    return response.map((event) {
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
