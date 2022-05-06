import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/staff_member.dart';

class MemberListTile extends StatelessWidget {
  static const _blueShades = [100, 200, 300, 400, 600, 700, 800, 900];
  final StaffMember member;
  const MemberListTile({required this.member, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ListTile(
          leading: FaIcon(
            FontAwesomeIcons.solidCircleUser,
            size: 40,
            color:
                Colors.blue[_blueShades[Random().nextInt(_blueShades.length)]],
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
