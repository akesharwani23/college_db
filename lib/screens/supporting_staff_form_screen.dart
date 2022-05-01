import 'package:flutter/material.dart';

import '../widgets/supporting_staff_form.dart';
import '../models/staff_member.dart';

class SupportingStaffFormScreen extends StatelessWidget {
  static const routeName = '/supporting-staff-form';
  const SupportingStaffFormScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var member = ModalRoute.of(context)!.settings.arguments as StaffMember?;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff Form'),
      ),
      body: SupportingStaffForm(member: member),
    );
  }
}
