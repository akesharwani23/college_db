import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class StaffForm extends StatefulWidget {
  const StaffForm({Key? key}) : super(key: key);

  @override
  State<StaffForm> createState() => _StaffFormState();
}

class _StaffFormState extends State<StaffForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            FormBuilder(
              key: _formKey,
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FormBuilderTextField(
                      name: 'name',
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Name';
                        }
                      },
                      decoration: InputDecoration(
                          labelText: 'Staff Name',
                          border: OutlineInputBorder()),
                    ),
                  ),
                ],
              )),
            )
          ],
        ),
      ),
    );
  }
}
