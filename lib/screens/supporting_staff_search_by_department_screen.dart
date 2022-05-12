import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/staff_member.dart';
import '../providers/supporting_staff_members.dart';
import '../screens/staff_detail_screen.dart';
import '../widgets/member_list_tile.dart';
import '../models/form_options.dart' as options;

class SupportingStaffSearchByDepartmentScreen extends StatefulWidget {
  static const routeName = '/supporting-staff-search-screen';
  const SupportingStaffSearchByDepartmentScreen({Key? key}) : super(key: key);

  @override
  State<SupportingStaffSearchByDepartmentScreen> createState() =>
      _SupportingStaffSearchByDepartmentScreenState();
}

class _SupportingStaffSearchByDepartmentScreenState
    extends State<SupportingStaffSearchByDepartmentScreen> {
  String? _department;
  String? _subDepartment;
  List<String> _subDepartmentOptions = [""];

  void _updateDepartmentDependents(String? value) {
    if (value == null) {
      return;
    }
    setState(() {
      _subDepartment = null;
      _subDepartmentOptions = options.department[value] as List<String>;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Supporting Staff Search Section')),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Center(
            child: Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(15)),
              child: DropdownButton<String>(
                  value: _department,
                  isExpanded: true,
                  underline: const SizedBox.shrink(),
                  items: options.department.keys
                      .map((option) => DropdownMenuItem(
                            child: Text(option),
                            value: option,
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _department = value;
                      _updateDepartmentDependents(value);
                    });
                  }),
            ),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(15)),
              child: DropdownButton<String>(
                  value: _subDepartment,
                  isExpanded: true,
                  underline: const SizedBox.shrink(),
                  items: _subDepartmentOptions
                      .map((option) => DropdownMenuItem(
                            child: Text(option),
                            value: option,
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _subDepartment = value;
                    });
                  }),
            ),
          ),
          if (_department == null || _subDepartment == null)
            const Text('Select Department')
          else
            StreamBuilder<List<StaffMember>>(
              stream: Provider.of<SupportingStaffMembers>(context)
                  .getMembersWithDepartmentAndSubDepartment(
                      department: _department!, subDepartment: _subDepartment!),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.connectionState == ConnectionState.done ||
                    snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    var members = snapshot.data;
                    if (members!.isEmpty) {
                      return const Text('No Data');
                    }
                    return Expanded(
                      child: ListView.builder(
                        itemCount: members.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            child: MemberListTile(member: members[index]),
                            onTap: () => Navigator.of(context).pushNamed(
                                StaffDetailScreen.routeName,
                                arguments: members[index]),
                          );
                        },
                      ),
                    );
                  }
                }
                return const Text('No Data');
              },
            )
        ],
      ),
    );
  }
}
