import 'package:cloud_firestore/cloud_firestore.dart';

class AdmissionCandidate {
  String? id;
  final String status;
  final String courseType;
  final String course;
  final String branch;

  // Fee Details
  final double feeForSem;
  final double paidByStudent;
  final double cancellationCharge;

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
  final String scoreEntranceExam; // N/A if not appeared

  //Other
  bool eligibleForScholarship = false;
  final String remark;

  // Admission Details
  final String admittedBy;
  final String admissionIncharge;
  final String session;
  final DateTime admissionDate;

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
      required this.cancellationCharge,
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
      required this.eligibleForScholarship,
      required this.remark,
      required this.scoreEntranceExam,
      required this.admissionDate,
      required this.admissionIncharge,
      required this.admittedBy,
      required this.session});

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'dob': dob.toIso8601String(),
      'courseType': courseType,
      'course': course,
      'branch': branch,
      'feeForSem': feeForSem,
      'paidByStudent': paidByStudent,
      'cancellationCharge': cancellationCharge,
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
      'scoreEntranceExam': scoreEntranceExam,
      'remark': remark,
      'eligibleForScholarship': eligibleForScholarship,
      'admittedBy': admittedBy,
      'admissionIncharge': admissionIncharge,
      'session': session,
      'admissionDate': admissionDate.toIso8601String(),
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
        cancellationCharge: data['cancellationCharge'],
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
        scoreEntranceExam: data['scoreEntranceExam'],
        remark: data['remark'],
        eligibleForScholarship: data['eligibleForScholarship'],
        admissionDate: DateTime.parse(data['admissionDate']),
        admittedBy: data['admittedBy'],
        admissionIncharge: data['admissionIncharge'],
        session: data['session']);
  }

  String get getStatus => status;

  @override
  String toString() => toMap().toString();
}
