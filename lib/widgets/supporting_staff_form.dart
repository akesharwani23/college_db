import 'package:college_db/models/staff_member.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import '../models/form_options.dart' as options;
import '../providers/supporting_staff_members.dart';

class SupportingStaffForm extends StatefulWidget {
  final StaffMember? member;
  const SupportingStaffForm({this.member, Key? key}) : super(key: key);

  @override
  State<SupportingStaffForm> createState() => _SupportingStaffFormState();
}

class _SupportingStaffFormState extends State<SupportingStaffForm> {
  List<String> _subDepartmentOptions = [""];
  final _formKey = GlobalKey<FormBuilderState>();
  var _isLoading = false;
  void _updateDepartmentDependents(String? value, {bool resetValue = true}) {
    if (value == null) {
      return;
    }
    setState(() {
      if (resetValue) {
        if (_formKey.currentState!.fields['subDepartment'] != null) {
          _formKey.currentState!.fields['subDepartment']!.setValue(null);
        }
      }
      _subDepartmentOptions = options.department[value] as List<String>;
    });
  }

  @override
  void initState() {
    if (widget.member != null) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        _updateDepartmentDependents(widget.member!.department,
            resetValue: false);
        _formKey.currentState!.fields['department']!
            .setValue(widget.member?.department);
        _formKey.currentState!.fields['subDepartment']!
            .setValue(widget.member?.subDepartment);
      });
    }
    super.initState();
  }

  void _submit(BuildContext context) async {
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate()) {
      var formFields = _formKey.currentState!.fields;
      final member = StaffMember(
          name: formFields['name']!.value,
          qualification: formFields['qualification']!.value,
          department: formFields['department']!.value,
          subDepartment: formFields['subDepartment']!.value,
          experience: formFields['experience']!.value,
          address: formFields['address']!.value,
          contactNo: formFields['contactNo']!.value);
      setState(() {
        _isLoading = true;
      });
      if (widget.member != null) {
        member.id = widget.member!.id;
        await Provider.of<SupportingStaffMembers>(context, listen: false)
            .updateMember(member);
      } else {
        await Provider.of<SupportingStaffMembers>(context, listen: false)
            .addMember(member);
      }
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    var member = widget.member;
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  FormBuilder(
                    key: _formKey,
                    child: SingleChildScrollView(
                        child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Department: ',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            SizedBox(
                              width: deviceSize.width * 0.6,
                              child: FormBuilderDropdown(
                                  name: 'department',
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please Select Department';
                                    }
                                  },
                                  onChanged: (String? value) =>
                                      _updateDepartmentDependents(value),
                                  items: options.department.keys
                                      .map((option) => DropdownMenuItem(
                                            child: Text('$option'),
                                            value: option,
                                          ))
                                      .toList()),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Sub Department: ',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            SizedBox(
                              width: deviceSize.width * 0.4,
                              child: FormBuilderDropdown(
                                  name: 'subDepartment',
                                  // initialValue: candidate?.course,
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please Select Sub Department';
                                    }
                                  },
                                  // onChanged: (String? value) =>
                                  //     _updateCourseDependents(value),
                                  items: _subDepartmentOptions
                                      .map((option) => DropdownMenuItem(
                                            child: Text('$option'),
                                            value: option,
                                          ))
                                      .toList()),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FormBuilderTextField(
                            name: 'name',
                            initialValue: member?.name,
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FormBuilderTextField(
                            name: 'qualification',
                            initialValue: member?.qualification,
                            maxLines: 3,
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Field';
                              }
                            },
                            decoration: InputDecoration(
                                labelText: 'Qualification',
                                border: OutlineInputBorder()),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FormBuilderTextField(
                            name: 'experience',
                            initialValue: member?.experience,
                            maxLines: 3,
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Field';
                              }
                            },
                            decoration: InputDecoration(
                                labelText: 'Experience',
                                border: OutlineInputBorder()),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FormBuilderTextField(
                            name: 'address',
                            initialValue: member?.address,
                            maxLines: 3,
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Field';
                              }
                            },
                            decoration: InputDecoration(
                                labelText: 'Address',
                                border: OutlineInputBorder()),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FormBuilderTextField(
                            name: 'contactNo',
                            initialValue: member?.contactNo,
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Mobile Number';
                              }
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                labelText: 'Mobile Number',
                                border: OutlineInputBorder()),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              // TODO: Show confirmDialog
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.redAccent),
                                onPressed: () {
                                  if (_formKey.currentState != null) {
                                    _formKey.currentState!.reset();
                                  }
                                },
                                icon: Icon(Icons.restore),
                                label: Text('Reset'),
                              ),
                            ),
                            Spacer(),
                            Padding(
                              // TODO: Show confirm dialog
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton.icon(
                                  onPressed: () => _submit(context),
                                  icon: Icon(Icons.save),
                                  label: Text('Submit')),
                            ),
                          ],
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