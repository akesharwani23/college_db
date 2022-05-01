import 'package:college_db/models/staff_member.dart';
import 'package:flutter/material.dart';

import '../widgets/staff_form.dart';

class StaffFormScreen extends StatelessWidget {
  static const routeName = '/staff-form';
  const StaffFormScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var member = ModalRoute.of(context)!.settings.arguments as StaffMember?;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff Form'),
      ),
      body: StaffForm(member: member),
    );
  }
}
