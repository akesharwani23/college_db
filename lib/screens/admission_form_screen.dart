import 'package:flutter/material.dart';

class AdmissionFormScreen extends StatelessWidget {
  static const routeName = '/admission-form';
  const AdmissionFormScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admission Form'),
      ),
    );
  }
}
