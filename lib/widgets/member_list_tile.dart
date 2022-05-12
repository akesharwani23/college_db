import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/staff_member.dart';

class MemberListTile extends StatelessWidget {
  final StaffMember member;
  const MemberListTile({required this.member, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ListTile(
          leading: const FaIcon(
            FontAwesomeIcons.solidCircleUser,
            size: 40,
            // color:
            //     Colors.blue[_blueShades[Random().nextInt(_blueShades.length)]],
            color: Color.fromARGB(255, 81, 185, 169),
          ),
          title: Text(member.name),
          subtitle: Text(member.subDepartment),
          trailing: Text(
            member.department,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
