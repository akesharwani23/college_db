import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/staff_detail_screen.dart';
import '../models/staff_member.dart';
import '../providers/staff_members.dart';
import 'member_list_tile.dart';

class StaffSearchByName extends SearchDelegate<StaffMember?> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.trim().isEmpty) {
      return const Center(child: Text('NO RESULT'));
    }
    return StreamBuilder<List<StaffMember>>(
      stream: Provider.of<StaffMembers>(context)
          .getMembersWithNameStartingFrom(query.trim()),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final members = snapshot.data;
          return ListView.builder(
              itemCount: members!.length,
              itemBuilder: (context, index) => InkWell(
                  child: MemberListTile(member: members[index]),
                  onTap: () => Navigator.of(context).pushNamed(
                        StaffDetailScreen.routeName,
                        arguments: members[index],
                      )));
        }
        return const Center(
          child: Text(
            'No Result',
            style: TextStyle(fontSize: 18),
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final members = Provider.of<StaffMembers>(context).staffMemberCache;
    return ListView.builder(
      itemCount: members.length,
      itemBuilder: (context, index) => InkWell(
        child: MemberListTile(member: members[index]),
        onTap: () => Navigator.of(context).pushNamed(
          StaffDetailScreen.routeName,
          arguments: members[index],
        ),
      ),
    );
  }
}
