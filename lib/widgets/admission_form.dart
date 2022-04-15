import 'package:provider/provider.dart';

import '../models/admission_candidate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import '../models/form_options.dart' as options;
import '../providers/admission_candidates.dart';

class AdmissionForm extends StatefulWidget {
  AdmissionForm({Key? key}) : super(key: key);

  @override
  State<AdmissionForm> createState() => _AdmissionFormState();
}

class _AdmissionFormState extends State<AdmissionForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  var _courseOptions = [''];
  var _branchOptions = [''];
  var _isLoading = false;
  var _appearedInEntranceExam = true;

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

  void _submit(BuildContext context) async {
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate()) {
      var formFields = _formKey.currentState!.fields;
      // _candidate.setStatus = formFields['status'] as String;
      var nameExam = 'N/A';
      var rankExam = 'N/A';
      var appearedInEntranceExam =
          formFields['examAppearance']!.value == 'Yes' ? true : false;
      if (appearedInEntranceExam) {
        nameExam = formFields['nameExam']!.value;
        rankExam = formFields['rankExam']!.value;
      }
      final candidate = AdmissionCandidate(
          status: formFields['status']!.value,
          courseType: formFields['courseType']!.value,
          course: formFields['course']!.value,
          branch: formFields['branch']!.value,
          feeForSem: double.parse(formFields['feeForSem']!.value),
          paidByStudent: double.parse(formFields['amountPaid']!.value),
          name: formFields['name']!.value,
          dob: formFields['dob']!.value,
          mobileNumber: formFields['mobileNumber']!.value,
          parentName: formFields['parentName']!.value,
          parentMobileNumber: formFields['parentMobileNumber']!.value,
          parentOccupation: formFields['parentOccupation']!.value,
          address: formFields['address']!.value,
          category: formFields['category']!.value,
          previousInstituteName: formFields['prevInstitute']!.value,
          rollNoLastExam: formFields['rollNo']!.value,
          appearedInEntranceExam: appearedInEntranceExam,
          nameEntranceExam: nameExam,
          rankEntranceExam: rankExam,
          eligibleForScholarship: formFields['eligibleForScholarship']!.value);
      setState(() {
        _isLoading = true;
      });
      await Provider.of<AdmissionCandidates>(context, listen: false)
          .addCandidate(candidate);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }

  void _updateExamAppearanceDependents(String? value) {
    if (value == null) {
      return;
    }
    if (value == 'No') {
      setState(() {
        _appearedInEntranceExam = false;
      });
    } else if (value == 'Yes') {
      setState(() {
        _appearedInEntranceExam = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return _isLoading
        ? Center(child: CircularProgressIndicator())
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
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.height *
                                        0.6,
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
                                            .map((option) =>
                                                FormBuilderFieldOption(
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
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
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
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
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
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
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
                              child: FormBuilderDateTimePicker(
                                name: 'dob',
                                inputType: InputType.date,
                                initialDate: DateTime.now(),
                                decoration: InputDecoration(
                                    labelText: 'Date Of Birth',
                                    suffixIcon: Icon(Icons.calendar_month)),
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
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FormBuilderTextField(
                                name: 'prevInstitute',
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Previous Insitute Name';
                                  }
                                },
                                decoration: InputDecoration(
                                    labelText: 'Previous Institute Name',
                                    border: OutlineInputBorder()),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FormBuilderTextField(
                                name: 'rollNo',
                                keyboardType: TextInputType.number,
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Roll No of Last Examination';
                                  }
                                },
                                decoration: InputDecoration(
                                    labelText: 'Roll No Last Exam',
                                    border: OutlineInputBorder()),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FormBuilderTextField(
                                name: 'feeForSem',
                                keyboardType: TextInputType.number,
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Semester Fee';
                                  }
                                },
                                decoration: InputDecoration(
                                    prefixIcon:
                                        Icon(Icons.currency_rupee_rounded),
                                    labelText: 'Semester Fee',
                                    border: OutlineInputBorder()),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FormBuilderTextField(
                                name: 'amountPaid',
                                keyboardType: TextInputType.number,
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Amount paid by student';
                                  }
                                },
                                decoration: InputDecoration(
                                    prefixIcon:
                                        Icon(Icons.currency_rupee_rounded),
                                    labelText: 'Amount Paid By Student',
                                    border: OutlineInputBorder()),
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  'Category: ',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
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
                            FormBuilderCheckbox(
                                decoration: InputDecoration(),
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                name: 'eligibleForScholarship',
                                title: Text(
                                  'Is Candidate Eligible For Scholarship?',
                                  style: TextStyle(fontSize: 18),
                                )),
                            /** -----------
                             * Entrance Exam Section
                             */
                            Row(
                              children: [
                                Text(
                                  'Appeared in entrance exam: ',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Spacer(),
                                SizedBox(
                                  width: deviceSize.width * 0.3,
                                  child: FormBuilderDropdown(
                                    name: 'examAppearance',
                                    onChanged: _updateExamAppearanceDependents,
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
                            if (_appearedInEntranceExam)
                              Row(
                                children: [
                                  Text(
                                    'Name of Exam: ',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Spacer(),
                                  SizedBox(
                                    width: deviceSize.width * 0.6,
                                    child: FormBuilderDropdown(
                                      name: 'nameExam',
                                      validator: (String? value) {
                                        if (_appearedInEntranceExam) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please Select Field';
                                          }
                                        }
                                      },
                                      items: [
                                        "PET",
                                        "JEE",
                                        "CMAT",
                                        "ATMA",
                                        "MAT",
                                        "GATE"
                                      ]
                                          .map((option) => DropdownMenuItem(
                                                value: option,
                                                child: Text('$option'),
                                              ))
                                          .toList(),
                                    ),
                                  )
                                ],
                              ),
                            if (_appearedInEntranceExam)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FormBuilderTextField(
                                  name: 'rankExam',
                                  validator: (String? value) {
                                    if (_appearedInEntranceExam) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please Provide Rank';
                                      }
                                    }
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      labelText: 'Entrance Exam Rank',
                                      border: OutlineInputBorder()),
                                ),
                              ),
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
              ),
            ),
          );
  }
}
