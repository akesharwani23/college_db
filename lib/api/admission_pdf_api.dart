import 'package:college_db/models/admission_candidate.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'dart:io';

class AdmissionPdfApi {
  static void createPdf(AdmissionCandidate candidate) async {
    final pdf = Document();
    // Define pdf structure
    Page page = _createPdfLayout(candidate);

    pdf.addPage(page);
    // create pdf with data
    Directory appDocDir = await getExternalStorageDirectory() as Directory;
    final file = File('${appDocDir.path}/secondExample.pdf');
    await file.writeAsBytes(await pdf.save()).then((value) {
      print(value.path);
      OpenFile.open(value.path);
    });
    print('done');
    // write data
  }

  /**
   * HELPER FUNCIONS
   */

  static Page _createPdfLayout(AdmissionCandidate candidate) {
    return Page(build: (Context context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  border: Border.all(),
                ),
                child: Text('life')),
            SizedBox(width: 15),
            Text('Chouksey Group Of Colleges, Bilaspur (CG)',
                style: TextStyle(fontSize: 20))
          ]),
          SizedBox(height: 15),
          _formStatus(candidate),
          Center(
            child: Text(
              'Personal Details',
              style: TextStyle(fontSize: 22),
            ),
          ),
          Divider(),
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
          textDetailElement('Parent\'s Occupation', candidate.parentOccupation),
          SizedBox(
            height: 15,
          ),
          Center(
            child: Text(
              'Academic Details',
              style: TextStyle(fontSize: 22),
            ),
          ),
          Divider(),
          textDetailElement(
              'Previous Institute Name', candidate.previousInstituteName),
          textDetailElement('Roll No Last Exam', candidate.rollNoLastExam),
          textDetailElement('Appeared In Entrance Exam',
              candidate.appearedInEntranceExam ? 'Yes' : 'No'),
          textDetailElement('Name Entrance Exam', candidate.nameEntranceExam),
          textDetailElement('Rank Entrance Exam', candidate.rankEntranceExam),
          SizedBox(
            height: 15,
          ),
          Center(
            child: Text(
              'Admission Details',
              style: TextStyle(
                fontSize: 22,
              ),
            ),
          ),
          Divider(),
          textDetailElement('Graduation Type', candidate.courseType),
          textDetailElement('Course', candidate.course),
          textDetailElement('Branch', candidate.branch),
          textDetailElement('Fee/Sem', candidate.feeForSem.toStringAsFixed(2)),
          textDetailElement('Fee Paid By Student',
              candidate.paidByStudent.toStringAsFixed(2)),
          // textDetailElement(, data)
        ],
      );
    });
  }

  static Widget _formStatus(AdmissionCandidate candidate) {
    if (candidate.status == 'Confirmed')
      return Container(
        child: Text(
          candidate.status,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        color: PdfColors.greenAccent,
        width: double.infinity,
        alignment: Alignment.center,
        padding: EdgeInsets.all(8),
      );
    if (candidate.status == 'Not Confirmed')
      return Container(
        child: Text(
          candidate.status,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        color: PdfColors.redAccent,
        width: double.infinity,
        alignment: Alignment.center,
        padding: EdgeInsets.all(8),
      );
    return Text(''); //FIXME: remove this line
  }

  static Widget textDetailElement(String type, String data) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4, right: 8, left: 8),
      child: Text(
        '${type}: ${data}',
        style: TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }
}

// Future<void> func(String title) async {
//   final pdf = Document();
//   pdf.addPage(
//     Page(
//         build: (Context context) => Center(
//               child: Text('Hello World!!!!! $title'),
//             )),
//   );
//   Directory appDocDir = await getExternalStorageDirectory() as Directory;
//   final file = File('${appDocDir.path}/example2.pdf');
//   await file.writeAsBytes(await pdf.save()).then((value) => print(value.path));
//   print('done');
// }
