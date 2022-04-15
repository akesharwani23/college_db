import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_db/api/admission_api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/admission_candidate.dart';
import '../providers/admission_candidates.dart';

class AdmissionDetailScreen extends StatefulWidget {
  static const routeName = '/admission-detail-screen';
  const AdmissionDetailScreen({Key? key}) : super(key: key);

  @override
  State<AdmissionDetailScreen> createState() => _AdmissionDetailScreenState();
}

class _AdmissionDetailScreenState extends State<AdmissionDetailScreen> {
  void _studentDetailPdf(String id) async {
    //FIXME: make more efficient.
    final response =
        await FirebaseFirestore.instance.collection('admissions').doc(id).get();
    if (response.exists) {
      final candidate =
          AdmissionCandidate.fromMap(response.data() as Map<String, dynamic>);
      AdmissionPdfApi.createPdf(candidate);
    }
  }

  void _studentDetailPdfs(AdmissionCandidate candidate) {
    AdmissionPdfApi.createPdf(candidate);
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admission Student Detail'),
        actions: [
          IconButton(
              onPressed: () => _studentDetailPdf(id),
              icon: const Icon(Icons.picture_as_pdf))
        ],
      ),
      body: FutureBuilder<AdmissionCandidate?>(
        future: Provider.of<AdmissionCandidates>(context).getCandidate(id),
        builder: (context, candidateSnapshot) {
          if (candidateSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (candidateSnapshot.hasData && candidateSnapshot.data == null) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.error_outline,
                  color: Colors.red,
                ),
                Text(
                  'Record Doesn\'t Exist',
                  style: TextStyle(color: Colors.red, fontSize: 23),
                ),
              ],
            );
          }
          if (candidateSnapshot.connectionState == ConnectionState.done) {
            // null is checked in above if condition
            AdmissionCandidate candidate = candidateSnapshot.data!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (candidate.status == 'Confirmed')
                    Container(
                      child: Text(
                        candidate.status,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      color: Colors.greenAccent,
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(8),
                    ),
                  if (candidate.status == 'Not Confirmed')
                    Container(
                      child: Text(
                        candidate.status,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      color: Colors.redAccent,
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(8),
                    ),
                  const Center(
                    child: Text(
                      'Personal Details',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  const Divider(),
                  textDetailElement('Name', candidate.name),
                  textDetailElement('DOB', candidate.dob.toString()),
                  textDetailElement('Mobile Number', candidate.mobileNumber),
                  textDetailElement('Parent\'s Name', candidate.parentName),
                  textDetailElement(
                      'Parent\'s Mobile Number', candidate.parentMobileNumber),
                  textDetailElement('Category', candidate.category),
                  textDetailElement('Address', candidate.address),
                  textDetailElement(
                      'Parent Mobile Number', candidate.parentMobileNumber),
                  textDetailElement(
                      'Parent\'s Occupation', candidate.parentOccupation),
                  const SizedBox(
                    height: 20,
                  ),
                  const Center(
                    child: Text(
                      'Academic Details',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  const Divider(),
                  textDetailElement('Previous Institute Name',
                      candidate.previousInstituteName),
                  textDetailElement(
                      'Roll No Last Exam', candidate.rollNoLastExam),
                  textDetailElement('Appeared In Entrance Exam',
                      candidate.appearedInEntranceExam ? 'Yes' : 'No'),
                  textDetailElement(
                      'Name Entrance Exam', candidate.nameEntranceExam),
                  textDetailElement(
                      'Rank Entrance Exam', candidate.rankEntranceExam),
                  const SizedBox(
                    height: 20,
                  ),
                  const Center(
                    child: Text(
                      'Admission Details',
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  ),
                  const Divider(),
                  textDetailElement('Graduation Type', candidate.courseType),
                  textDetailElement('Course', candidate.course),
                  textDetailElement('Branch', candidate.branch),
                  textDetailElement(
                      'Fee/Sem', candidate.feeForSem.toStringAsFixed(2)),
                  textDetailElement('Fee Paid By Student',
                      candidate.paidByStudent.toStringAsFixed(2)),
                  // textDetailElement(, data)
                ],
              ),
            );
          }
          return const Text(
            'ERROR!!!',
            style: TextStyle(color: Colors.red),
          );
        },
      ),
    );
  }

  Widget textDetailElement(String type, String data) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4, right: 8, left: 8),
      child: Text(
        '$type: $data',
        style: const TextStyle(
          fontSize: 18,
        ),
      ),
    );
  }
}
