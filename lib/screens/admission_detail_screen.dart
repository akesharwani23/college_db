import 'package:college_db/api/admission_pdf_api.dart';
import 'package:college_db/screens/admission_form_screen.dart';
import 'package:college_db/widgets/admission_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/admission_candidate.dart';
import '../providers/current_user.dart';

class AdmissionDetailScreen extends StatelessWidget {
  static const routeName = '/admission-detail-screen';
  const AdmissionDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AdmissionCandidate candidate =
        ModalRoute.of(context)!.settings.arguments as AdmissionCandidate;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Admission Student Detail'),
          actions: [
            IconButton(
                onPressed: () {
                  AdmissionPdfApi.createPdf(candidate);
                },
                icon: const Icon(Icons.picture_as_pdf))
          ],
        ),
        floatingActionButton: StreamBuilder<CurrentUser?>(
            stream: Provider.of<CurrentUserProvider>(context).cachedUser,
            builder: (context, userStream) {
              if (userStream.connectionState == ConnectionState.active ||
                  userStream.connectionState == ConnectionState.done) {
                if (userStream.hasData) {
                  // got non-null CurrentUser
                  final user = userStream.data!;
                  if (user.isAdmin) {
                    return FloatingActionButton.extended(
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                            AdmissionFormScreen.routeName,
                            arguments: candidate);
                      },
                      label: const Text(
                        'EDIT',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      icon: const Icon(Icons.edit),
                    );
                  }
                }
              }
              return const SizedBox.shrink();
            }),
        body: SingleChildScrollView(
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
              textDetailElement(
                  'Previous Institute Name', candidate.previousInstituteName),
              textDetailElement('Roll No Last Exam', candidate.rollNoLastExam),
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
        ));
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
