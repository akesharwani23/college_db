import 'package:college_db/models/admission_candidate.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';
import 'dart:io';
import 'package:flutter/services.dart';

class User {
  final String name;
  final int age;

  User(this.name, this.age);
}

class AdmissionPdfApi {
  static void createPdf(AdmissionCandidate candidate) async {
    final pdf = Document();

    Page page = await _createPage(candidate);

    pdf.addPage(page);
    // create pdf with data
    Directory appDocDir = await getExternalStorageDirectory() as Directory;
    final file = File('${appDocDir.path}/${candidate.name}.pdf');
    await file.writeAsBytes(await pdf.save()).then((value) {
      // print(value.path);
      OpenFile.open(value.path);
    });
    // print('done');
    // // write data
  }

  static Future<Page> _createPage(AdmissionCandidate candidate) async {
    final imagePng = (await rootBundle.load('assets/images/chouksey_logo.png'))
        .buffer
        .asUint8List();
    return MultiPage(build: (Context context) {
      return [
        Container(
            // decoration: BoxDecoration(border: Border.all()),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
              decoration: BoxDecoration(border: Border.all()),
              child: Column(children: [
                Row(children: [
                  Padding(
                      padding: const EdgeInsets.all(6),
                      child: Container(
                          height: 50,
                          width: 50,
                          // decoration: BoxDecoration(
                          //   border: Border.all(),
                          // ),
                          child: Image(MemoryImage(imagePng)))),
                  SizedBox(width: 15),
                  Column(children: [
                    Text('Chouksey Group Of Colleges, Bilaspur (CG)',
                        style: const TextStyle(fontSize: 20)),
                    Text('Chouksey Engineering College, Bilaspur (CG)')
                  ])
                ]),
                Divider(),
                Center(
                    child: Text('Admission Form',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                SizedBox(height: 15),
              ])),
          SizedBox(height: 15),
          Center(child: Text('Personal Detail')),
          SizedBox(height: 15),
          Table.fromTextArray(data: [
            ['Name', candidate.name],
            ['DOB', DateFormat("dd/MM/yyyy").format(candidate.dob)],
            ['Mobile No.', candidate.mobileNumber],
            ['Parent\'s Name', candidate.parentName],
            ['Parent\'s Occupation', candidate.parentOccupation],
            ['Address', candidate.address],
            ['Category', candidate.category]
          ], headerAlignment: Alignment.centerLeft),
          SizedBox(height: 15),
          Center(child: Text('Educational Details')),
          SizedBox(height: 15),
          Table.fromTextArray(data: [
            ["Previous Institute Name", candidate.previousInstituteName],
            ["Roll Number Last Exam", candidate.rollNoLastExam],
            [
              "Appeared In Entrance Exam",
              candidate.appearedInEntranceExam ? "Yes" : "No"
            ],
            ["Name Of Entrance Exam", candidate.nameEntranceExam],
            ["Rank in Entrance Exam", candidate.rankEntranceExam],
            ["Score in Entrance Exam", candidate.scoreEntranceExam]
          ], headerAlignment: Alignment.centerLeft),
          SizedBox(height: 15),
          Center(child: Text('Course Application Details')),
          SizedBox(height: 15),
          Table.fromTextArray(data: [
            ["Application Status", candidate.status],
            ["Session", candidate.session],
            ["Graduation Type", candidate.courseType],
            ["Course", candidate.course],
            ["Branch", candidate.branch],
            [
              "Eligible For Scholarship",
              candidate.eligibleForScholarship ? "Yes" : "No"
            ]
          ], headerAlignment: Alignment.centerLeft),
          Column(children: [
            SizedBox(height: 15),
            Center(child: Text('Fee Details')),
            SizedBox(height: 15),
            Table.fromTextArray(data: [
              ["Fee", candidate.feeForSem],
              ["Fee Paid By Student", candidate.paidByStudent],
              ["Cancellation Charge", candidate.cancellationCharge]
            ], headerAlignment: Alignment.centerLeft),
          ]),
          Column(children: [
            SizedBox(height: 15),
            Center(child: Text('Other Details')),
            SizedBox(height: 15),
            Table.fromTextArray(data: [
              ["Remark", candidate.remark],
              [
                "Admission Date",
                DateFormat("EEE, dd/MM/yyyy").format(candidate.admissionDate)
              ],
              ["Admitted By", candidate.admittedBy],
              ["Admission Incharge", candidate.admissionIncharge]
            ], headerAlignment: Alignment.centerLeft),
          ]),
          SizedBox(height: 25),
          Text('Note:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          Text(
              "1. Confirm seat allotment is subject to online counselling and DTC rule for Admission in Session ${candidate.session}"),
          Text(
              "2. Aadhar Card, Student Basic Details, Permanent Cast Certificate, Income Certificate, Domicile Certificate, TC and CC are mandatory to submit at the time of seat confirmation")
        ]))
      ];
    });
  }
}
