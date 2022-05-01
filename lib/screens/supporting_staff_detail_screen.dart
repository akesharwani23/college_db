import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './supporting_staff_form_screen.dart';
import '../models/staff_member.dart';
import '../providers/current_user.dart';

class SupportingStaffDetailScreen extends StatelessWidget {
  static const routeName = '/supporting-staff-detail';
  const SupportingStaffDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    StaffMember member =
        ModalRoute.of(context)!.settings.arguments as StaffMember;
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(title: const Text('Staff Details')),
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
                            SupportingStaffFormScreen.routeName,
                            arguments: member);
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
        body: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  elevation: 3,
                  child: Container(
                    child: Text(
                      member.name,
                      style: const TextStyle(fontSize: 18),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                ),
              ),
            ),
            Center(
              child: Text('Department: ${member.department}'),
            ),
            Center(
              child: Text('Sub-Department: ${member.subDepartment}'),
            ),
            _detailBox('Qualification', member.qualification),
            _detailBox('Experience', member.experience),
            _detailBox('Address', member.address),
            _detailBox('Contact No', member.contactNo)
          ],
        ));
  }

  Widget _detailBox(String title, String detail) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
        child: Card(
          elevation: 3,
          child: Container(
            child: Column(
              children: [
                Text(
                  '$title',
                  style: const TextStyle(fontSize: 20),
                ),
                Divider(),
                Text(
                  '${detail}',
                  style: const TextStyle(fontSize: 16),
                )
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
        ),
      ),
    );
  }
}
