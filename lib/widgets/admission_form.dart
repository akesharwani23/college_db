import '../models/admission_candidate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import '../models/form_options.dart' as options;

class AdmissionForm extends StatefulWidget {
  AdmissionForm({Key? key}) : super(key: key);

  @override
  State<AdmissionForm> createState() => _AdmissionFormState();
}

class _AdmissionFormState extends State<AdmissionForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  final _candidate = AdmissionCandidate();
  var _courseOptions = [''];
  var _branchOptions = [''];

  void _updateLevelDependents(String? value) {
    if (value == null) {
      return;
    }
    setState(() {
      if (_formKey.currentState!.fields['course'] != null) {
        _formKey.currentState!.fields['course']!.reset();
      }
      if (_formKey.currentState!.fields['branch'] != null) {
        _formKey.currentState!.fields['branch']!.reset();
      }
      _courseOptions = options.courseOptions[value] as List<String>;
    });
  }

  void _updateCourseDependents(String? value) {
    if (value == null) {
      return;
    }
    setState(() {
      if (_formKey.currentState!.fields['branch'] != null) {
        _formKey.currentState!.fields['branch']!.reset();
      }
      _branchOptions = options.branchOptions[value] as List<String>;
    });
  }

  void _submit() {
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate()) {
      var formFields = _formKey.currentState!.fields;
      // _candidate.setStatus = formFields['status'] as String;
      _candidate.setStatus = formFields['status']!.value;
      _candidate.setName = formFields['name']!.value;
      _candidate.setMobileNumber = formFields['mobileNumber']!.value;
      _candidate.setParentName = formFields['parentName']!.value;
      _candidate.setParentMobileNumber =
          formFields['parentMobileNumber']!.value;
      _candidate.setAddress = formFields['address']!.value;
      _candidate.setCategory = formFields['category']!.value;
      _candidate.setParentOccupation = formFields['parentOccupation']!.value;

      _candidate.setCourseType = formFields['courseType']!.value;
      _candidate.setCourse = formFields['course']!.value;
      _candidate.setBranch = formFields['branch']!.value;
      _candidate.setAppearedInEntranceExam =
          formFields['examAppearance']!.value == 'Yes' ? true : false;
      _candidate.setNameEntranceExam = formFields['nameExam']!.value;
      // _candidate.setRank = formFields['rank']!.value;
      _candidate.writeToDB();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            FormBuilder(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      /**-------------
                       * COURSE INFO SECTION
                       */
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Text(
                              'Status:',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.height * 0.6,
                              child: FormBuilderRadioGroup(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                  name: 'status',
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please Select status';
                                    }
                                  },
                                  options: ["Confirmed", "Not Confirmed"]
                                      .map((option) => FormBuilderFieldOption(
                                          value: option,
                                          child: Text("$option")))
                                      .toList()),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            'Level: ',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          SizedBox(
                            width: deviceSize.width * 0.6,
                            child: FormBuilderDropdown(
                                name: 'courseType',
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Select Level';
                                  }
                                },
                                onChanged: (String? value) =>
                                    _updateLevelDependents(value),
                                items: options.courseOptions.keys
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
                            'Course: ',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          SizedBox(
                            width: deviceSize.width * 0.6,
                            child: FormBuilderDropdown(
                                name: 'course',
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Select Course';
                                  }
                                },
                                onChanged: (String? value) =>
                                    _updateCourseDependents(value),
                                items: _courseOptions
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
                            'Branch: ',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          SizedBox(
                            width: deviceSize.width * 0.6,
                            child: FormBuilderDropdown(
                                name: 'branch',
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Select Branch';
                                  }
                                },
                                items: _branchOptions
                                    .map((option) => DropdownMenuItem(
                                          child: Text('$option'),
                                          value: option,
                                        ))
                                    .toList()),
                          )
                        ],
                      ),
                      Divider(),

                      /**------------
                       * PERSONAL DETAILS SECTION
                       */
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FormBuilderTextField(
                          name: 'name',
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Name';
                            }
                          },
                          decoration: InputDecoration(
                              labelText: 'Student Name',
                              border: OutlineInputBorder()),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FormBuilderTextField(
                          name: 'mobileNumber',
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Mobile Number';
                            }
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              labelText: 'Student Mobile Number',
                              border: OutlineInputBorder()),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FormBuilderTextField(
                          name: 'parentName',
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Field';
                            }
                          },
                          decoration: InputDecoration(
                              labelText: 'Parent Name',
                              border: OutlineInputBorder()),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FormBuilderTextField(
                          name: 'parentMobileNumber',
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Field';
                            }
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              labelText: 'Parent Mobile Number',
                              border: OutlineInputBorder()),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FormBuilderTextField(
                          name: 'parentOccupation',
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Field';
                            }
                          },
                          decoration: InputDecoration(
                              labelText: "Parent Occupation",
                              border: OutlineInputBorder()),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FormBuilderTextField(
                          name: 'address',
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
                      Row(
                        children: [
                          Text(
                            'Category: ',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          SizedBox(
                            width: deviceSize.width * 0.6,
                            child: FormBuilderDropdown(
                              name: 'category',
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Select Field';
                                }
                              },
                              items: ["General", "OBC", "ST", "SC"]
                                  .map((option) => DropdownMenuItem(
                                        value: option,
                                        child: Text('$option'),
                                      ))
                                  .toList(),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Appeared in entrance exam: ',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          SizedBox(
                            width: deviceSize.width * 0.3,
                            child: FormBuilderDropdown(
                              name: 'examAppearance',
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Select Field';
                                }
                              },
                              items: ["Yes", "No"]
                                  .map((option) => DropdownMenuItem(
                                        value: option,
                                        child: Text('$option'),
                                      ))
                                  .toList(),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Name of Exam: ',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          SizedBox(
                            width: deviceSize.width * 0.6,
                            child: FormBuilderDropdown(
                              name: 'nameExam',
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Select Field';
                                }
                              },
                              items:
                                  ["PET", "JEE", "CMAT", "ATMA", "MAT", "GATE"]
                                      .map((option) => DropdownMenuItem(
                                            value: option,
                                            child: Text('$option'),
                                          ))
                                      .toList(),
                            ),
                          )
                        ],
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: FormBuilderTextField(
                      //     name: 'rankExam',
                      //     validator: (String? value) {
                      //       if (value == null || value.isEmpty) {
                      //         return 'Please Provide Rank';
                      //       }
                      //     },
                      //     readOnly: true,
                      //     keyboardType: TextInputType.number,
                      //     decoration: InputDecoration(
                      //         labelText: 'Entrance Exam Rank',
                      //         border: OutlineInputBorder()),
                      //   ),
                      // ),
                    ],
                  ),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  // TODO: Show confirmDialog
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(primary: Colors.redAccent),
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
                      onPressed: _submit,
                      icon: Icon(Icons.save),
                      label: Text('Submit')),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
