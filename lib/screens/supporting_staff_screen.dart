import 'package:college_db/screens/supporting_staff_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './supporting_staff_form_screen.dart';
import '../models/staff_member.dart';
import '../providers/current_user.dart';
import '../providers/supporting_staff_members.dart';
import '../widgets/member_list_tile.dart';

class SupportingStaffScreen extends StatelessWidget {
  const SupportingStaffScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: StreamBuilder<CurrentUser?>(
            stream: Provider.of<CurrentUserProvider>(context).cachedUser,
            builder: (context, userStream) {
              if (userStream.connectionState == ConnectionState.active ||
                  userStream.connectionState == ConnectionState.done) {
                if (userStream.hasData) {
                  // got non-null CurrentUser
                  final user = userStream.data!;
                  if (user.isAdmin) {
                    return FloatingActionButton(
                      child: const Icon(Icons.add),
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(SupportingStaffFormScreen.routeName);
                      },
                    );
                  }
                }
              }
              return const SizedBox.shrink();
            }),
        body: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            StreamBuilder<List<StaffMember>>(
                stream:
                    Provider.of<SupportingStaffMembers>(context).cachedMembers,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.connectionState == ConnectionState.active ||
                      snapshot.connectionState == ConnectionState.done) {
                    final members = snapshot.data;
                    return Expanded(
                      child: ListView.builder(
                        itemCount: members!.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            child: MemberListTile(member: members[index]),
                            onTap: () => Navigator.of(context).pushNamed(
                              SupportingStaffDetailScreen.routeName,
                              arguments: members[index],
                            ),
                          );
                        },
                      ),
                    );
                  }
                  return const Text('No Data');
                })
          ],
        ));
  }
}
