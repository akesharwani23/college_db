import 'package:college_db/screens/staff_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/staff_member.dart';
import '../providers/current_user.dart';

class StaffDetailScreen extends StatelessWidget {
  static const routeName = '/staff-detail-screen';
  const StaffDetailScreen({Key? key}) : super(key: key);

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
                            StaffFormScreen.routeName,
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
            Container(
              child: Text(
                member.name,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              // color: ,
              width: double.infinity,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _detailBox('Department', member.department),
                _detailBox('Sub-department', member.subDepartment),
                _detailBox('Qualification', member.qualification),
                _detailBox('Experience', member.experience),
                _detailBox('Address', member.address),
                // _detailBox('Contact No', member.contactNo),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    margin: EdgeInsets.all(8),
                    child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(8)),
                        onPressed: () {
                          launchUrl(Uri(
                            scheme: 'tel',
                            path: '+91' + member.contactNo,
                          ));
                        },
                        icon: Icon(
                          Icons.call,
                          size: 24,
                        ),
                        label: Text(
                          'Call ${member.contactNo}',
                          style: TextStyle(fontSize: 16),
                        )),
                  ),
                )
              ],
            ),
          ],
        ));
  }

  Widget _detailBox(String title, String detail) {
    final style = TextStyle(fontSize: 18);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: style,
            ),
            width: 120,
          ),
          Container(
            child: Text(
              ':',
              style: style,
            ),
            width: 10,
          ),
          Text(
            detail,
            style: style,
          )
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }
}
