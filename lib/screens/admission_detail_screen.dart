import 'package:college_db/api/admission_pdf_api.dart';
import 'package:college_db/screens/admission_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' show DateFormat;
import '../api/admission_pdf_api.dart';
import '../models/admission_candidate.dart';
import '../providers/current_user.dart';

class AdmissionDetailScreen extends StatelessWidget {
  static const routeName = '/admission-detail-screen';
  const AdmissionDetailScreen({Key? key}) : super(key: key);

  static const Map<String, Color> _statusColor = {
    'Confirmed': Colors.greenAccent,
    'Provisional': Colors.yellowAccent,
    'Registration': Colors.redAccent,
  };

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
                  // AdmissionPdfApi.createPdf(candidate);
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
                        Navigator.of(context).popAndPushNamed(
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
              Container(
                child: Text(
                  candidate.status,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                color: _statusColor[candidate.status],
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
              detailWidget('Name', candidate.name),
              detailWidget(
                  'DOB', DateFormat("EEE, dd/MM/yyyy").format(candidate.dob)),
              detailWidget('Mobile Number', candidate.mobileNumber),
              detailWidget('Parent\'s Name', candidate.parentName),
              detailWidget(
                  'Parent\'s Mobile Number', candidate.parentMobileNumber),
              detailWidget('Category', candidate.category),
              detailWidget('Address', candidate.address),
              detailWidget(
                  'Parent Mobile Number', candidate.parentMobileNumber),
              detailWidget('Parent\'s Occupation', candidate.parentOccupation),
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
              detailWidget(
                  'Previous Institute Name', candidate.previousInstituteName),
              detailWidget('Roll No Last Exam', candidate.rollNoLastExam),
              detailWidget('Appeared In Entrance Exam',
                  candidate.appearedInEntranceExam ? 'Yes' : 'No'),
              detailWidget('Name Entrance Exam', candidate.nameEntranceExam),
              detailWidget('Rank Entrance Exam', candidate.rankEntranceExam),
              detailWidget('Score Entrance Exam', candidate.scoreEntranceExam),
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
              detailWidget('Session', candidate.session),
              detailWidget('Graduation Type', candidate.courseType),
              detailWidget('Course', candidate.course),
              detailWidget('Branch', candidate.branch),
              detailWidget('Fee/Sem', candidate.feeForSem.toStringAsFixed(2)),
              detailWidget('Fee Paid By Student',
                  candidate.paidByStudent.toStringAsFixed(2)),
              detailWidget('Cancellation Charges',
                  candidate.cancellationCharge.toStringAsFixed(2)),
              const SizedBox(
                height: 20,
              ),
              const Center(
                child: Text(
                  'Other Details',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
              const Divider(),
              detailWidget('Remark', candidate.remark),
              detailWidget(
                  'Admission Date',
                  DateFormat("EEE, dd/MM/yyyy")
                      .format(candidate.admissionDate)),
              detailWidget('Admitted By', candidate.admittedBy),
              detailWidget('Admission Incharge', candidate.admissionIncharge)
            ],
          ),
        ));
  }

  Widget detailWidget(String type, String data) {
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
