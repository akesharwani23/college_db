import 'package:college_db/models/admission_candidate.dart';
import 'package:flutter/material.dart';

import '../widgets/admission_form.dart';

class AdmissionFormScreen extends StatelessWidget {
  static const routeName = '/admission-form';
  const AdmissionFormScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var candidate =
        ModalRoute.of(context)!.settings.arguments as AdmissionCandidate?;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admission Form'),
      ),
      body: AdmissionForm(candidate: candidate),
    );
  }
}
