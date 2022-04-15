import 'package:cloud_firestore/cloud_firestore.dart';

class AdmissionCandidate {
  String? id;
  final String status;
  final String courseType;
  final String course;
  final String branch;
  final double feeForSem;
  final double paidByStudent;

  //Personal Details
  final String name;
  final DateTime dob;
  final String mobileNumber;
  final String parentName;
  final String parentMobileNumber;
  final String parentOccupation;
  final String address;
  final String category; /*Caste Category*/

  //Past Educational Detail
  final String previousInstituteName;
  final String rollNoLastExam;
  final bool appearedInEntranceExam;
  final String nameEntranceExam; // N/A if not appeared
  final String rankEntranceExam; // N/A if not appeared

  //Other
  bool eligibleForScholarship = false;

  /// [AdmissionCandidate] Constructor
  ///
  /// Initializes all value except [id]
  AdmissionCandidate(
      {required this.status,
      required this.courseType,
      required this.course,
      required this.branch,
      required this.feeForSem,
      required this.paidByStudent,
      required this.name,
      required this.dob,
      required this.mobileNumber,
      required this.parentName,
      required this.parentMobileNumber,
      required this.parentOccupation,
      required this.address,
      required this.category,
      required this.previousInstituteName,
      required this.rollNoLastExam,
      required this.appearedInEntranceExam,
      required this.nameEntranceExam,
      required this.rankEntranceExam,
      required this.eligibleForScholarship});

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'dob': dob.toIso8601String(),
      'courseType': courseType,
      'course': course,
      'branch': branch,
      'feeForSem': feeForSem,
      'paidByStudent': paidByStudent,
      'name': name.toUpperCase(),
      'mobileNumber': mobileNumber,
      'parentName': parentName.toUpperCase(),
      'parentMobileNumber': parentMobileNumber,
      'parentOccupation': parentOccupation,
      'address': address,
      'category': category,
      'previousInstituteName': previousInstituteName,
      'rollNoLastExam': rollNoLastExam,
      'appearedInEntranceExam': appearedInEntranceExam,
      'nameEntranceExam': nameEntranceExam,
      'rankEntranceExam': rankEntranceExam,
      'eligibleForScholarship': eligibleForScholarship
    };
  }

  /// An AdmissionCandidate constructor
  ///
  /// Note: Initializes all values except [id]
  factory AdmissionCandidate.fromMap(Map<String, dynamic> data) {
    return AdmissionCandidate(
        status: data['status'],
        courseType: data['courseType'],
        course: data['course'],
        branch: data['branch'],
        feeForSem: data['feeForSem'],
        paidByStudent: data['paidByStudent'],
        name: (data['name'] as String).toUpperCase(),
        dob: DateTime.parse(data['dob']),
        mobileNumber: data['mobileNumber'],
        parentName: (data['parentName'] as String).toUpperCase(),
        parentMobileNumber: data['parentMobileNumber'],
        parentOccupation: data['parentOccupation'],
        address: data['address'],
        category: data['category'],
        previousInstituteName: data['previousInstituteName'],
        rollNoLastExam: data['rollNoLastExam'],
        appearedInEntranceExam: data['appearedInEntranceExam'],
        nameEntranceExam: data['nameEntranceExam'],
        rankEntranceExam: data['rankEntranceExam'],
        eligibleForScholarship: data['eligibleForScholarship']);
  }

  String get getStatus => status;

  @override
  String toString() => toMap().toString();
}
