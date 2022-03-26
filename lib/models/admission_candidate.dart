import 'package:cloud_firestore/cloud_firestore.dart';

class AdmissionCandidate {
  String? _id;
  String? _status;
  String? _courseType;
  String? _course;
  String? _branch;
  double? _feeForSem;
  double? _paidByStudent;

  //Personal Details
  String? _name;
  String? _mobileNumber;
  String? _parentName;
  String? _parentMobileNumber;
  String? _parentOccupation;
  String? _address;
  String? _category; /*Caste Category*/

  //Past Educational Detail
  String? _previousInstituteName;
  String? _rollNoLastExam;
  bool? _appearedInEntranceExam;
  String? _nameEntranceExam;
  String? _rankEntranceExam;

  //Other
  bool _eligibleForScholarship = false;

  Map<String, dynamic> _tomap() {
    return {
      'status': _status,
      'courseType': _courseType,
      'course': _course,
      'branch': _branch,
      'feeForSem': _feeForSem,
      'paidByStudent': _paidByStudent,
      'name': _name,
      'mobileNumber': _mobileNumber,
      'parentName': _parentName,
      'parentMobileNumber': _parentMobileNumber,
      'parentOccupation': _parentOccupation,
      'address': _address,
      'category': _category,
      'previousInstituteName': _previousInstituteName,
      'rollNoLastExam': _rollNoLastExam,
      'appreadInEntranceExam': _appearedInEntranceExam,
      'nameEntranceExam': _nameEntranceExam,
      'rankEntranceExam': _rankEntranceExam,
      'eligibleForScholarship': _eligibleForScholarship
    };
  }

  void writeToDB() async {
    await FirebaseFirestore.instance
        .collection('admissions')
        .doc()
        .set(_tomap());
  }

  /* ---personal details related functions--- */
  set setName(String name) {
    _name = name;
  }

  set setMobileNumber(String number) {
    _mobileNumber = number;
  }

  set setParentName(String name) {
    _parentName = name;
  }

  set setParentMobileNumber(String number) {
    _parentMobileNumber = number;
  }

  set setParentOccupation(String occupation) {
    _parentOccupation = occupation;
  }

  set setAddress(String address) {
    _address = address;
  }

  set setCategory(String category) {
    _category = category;
  }

  /* previous educational details */
  set setPrevInsituteName(String name) {
    _previousInstituteName = name;
  }

  set setRollNoLastExam(String rollno) {
    _rollNoLastExam = rollno;
  }

  set setAppearedInEntranceExam(bool didAppeared) {
    _appearedInEntranceExam = didAppeared;
  }

  set setNameEntranceExam(String name) {
    _nameEntranceExam = name;
  }

  set setRank(String rank) {
    _rankEntranceExam = rank;
  }

  set setEligibleForScholarship(bool isEligible) {
    _eligibleForScholarship = isEligible;
  }

  /* ----course related functions---- */
  set setStatus(String status) {
    _status = status;
  }

  set setCourseType(String courseType) {
    _courseType = courseType;
  }

  set setCourse(String course) {
    _course = course;
  }

  set setBranch(String branch) {
    _branch = branch;
  }

  /* ---fee related functions -- */
  set setFeeForSem(double price) {
    _feeForSem = price;
  }

  set setPaidByStudent(double price) {
    _paidByStudent = price;
  }
}
