import 'package:provider/provider.dart';

import '../models/admission_candidate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import '../models/form_options.dart' as options;
import '../providers/admission_candidates.dart';

class AdmissionForm extends StatefulWidget {
  final AdmissionCandidate? candidate;
  const AdmissionForm({this.candidate, Key? key}) : super(key: key);

  @override
  State<AdmissionForm> createState() => _AdmissionFormState();
}

class _AdmissionFormState extends State<AdmissionForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  var _courseOptions = [''];
  var _branchOptions = [''];
  var _isLoading = false;
  var _appearedInEntranceExam = true;

  void _updateLevelDependents(String? value, {bool resetValue = true}) {
    if (value == null) {
      return;
    }
    setState(() {
      if (resetValue) {
        if (_formKey.currentState!.fields['course'] != null) {
          _formKey.currentState!.fields['course']!.setValue(null);
        }
        if (_formKey.currentState!.fields['branch'] != null) {
          _formKey.currentState!.fields['branch']!.setValue(null);
        }
      }
      _courseOptions = options.courseOptions[value] as List<String>;
    });
  }

  void _updateCourseDependents(String? value, {bool resetValue = true}) {
    if (value == null) {
      return;
    }
    setState(() {
      if (resetValue) {
        if (_formKey.currentState!.fields['branch'] != null) {
          _formKey.currentState!.fields['branch']!.setValue(null);
        }
      }
      _branchOptions = options.branchOptions[value] as List<String>;
    });
  }

  @override
  void initState() {
    if (widget.candidate != null) {
      // Future.delayed(const Duration(seconds: 0), () {
      //   _formKey.currentState!
      //       .setInternalFieldValue('name', 'Game', isSetState: true);
      //   //FIX ME: Ofcourse, find another way of doing this, rather than exploiting race condition.
      //   _updateLevelDependents(widget.candidate!.courseType, resetValue: false);
      //   _updateCourseDependents(widget.candidate!.course, resetValue: false);
      //   if (widget.candidate!.appearedInEntranceExam == false) {
      //     _updateExamAppearanceDependents('No');
      //   }
      // });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        // print("WidgetsBinding");
        _updateLevelDependents(widget.candidate!.courseType, resetValue: false);
        _updateCourseDependents(widget.candidate!.course, resetValue: false);
        if (widget.candidate!.appearedInEntranceExam == false) {
          _updateExamAppearanceDependents('No');
        }
        _formKey.currentState!.fields['course']!
            .setValue(widget.candidate?.course);
        _formKey.currentState!.fields['branch']!
            .setValue(widget.candidate?.branch);
      });
    }
    super.initState();
  }

  void _submit(BuildContext context) async {
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate()) {
      var formFields = _formKey.currentState!.fields;
      // _candidate.setStatus = formFields['status'] as String;
      var nameExam = 'N/A';
      var rankExam = 'N/A';
      var scoreExam = 'N/A';
      var appearedInEntranceExam =
          formFields['examAppearance']!.value == 'Yes' ? true : false;
      if (appearedInEntranceExam) {
        nameExam = formFields['nameExam']!.value;
        rankExam = formFields['rankExam']!.value;
        scoreExam = formFields['scoreExam']!.value;
      }
      final candidate = AdmissionCandidate(
          status: formFields['status']!.value,
          courseType: formFields['courseType']!.value,
          course: formFields['course']!.value,
          branch: formFields['branch']!.value,
          feeForSem: double.parse(formFields['feeForSem']!.value),
          paidByStudent: double.parse(formFields['amountPaid']!.value),
          cancellationCharge:
              double.parse(formFields['cancellationCharge']!.value),
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
          scoreEntranceExam: scoreExam,
          remark: formFields['remark']!.value,
          eligibleForScholarship: formFields['eligibleForScholarship']!.value,
          admittedBy: formFields['admittedBy']!.value,
          admissionDate: formFields['admissionDate']!.value,
          admissionIncharge: formFields['admissionIncharge']!.value,
          session: formFields['session']!.value);
      setState(() {
        _isLoading = true;
      });
      if (widget.candidate != null) {
        candidate.id = widget.candidate!.id;
        await Provider.of<AdmissionCandidates>(context, listen: false)
            .updateCandidate(candidate);
      } else {
        await Provider.of<AdmissionCandidates>(context, listen: false)
            .addCandidate(candidate);
      }
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
    var candidate = widget.candidate;
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
                            /**-------------
                       * COURSE INFO SECTION
                       */
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  const Text(
                                    'Status:',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.height *
                                        0.6,
                                    child: FormBuilderRadioGroup(
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                        name: 'status',
                                        initialValue: candidate?.status,
                                        validator: (String? value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please Select status';
                                          }
                                          return null;
                                        },
                                        options: [
                                          "Confirmed",
                                          "Provisional",
                                          "Registration"
                                        ]
                                            .map((option) =>
                                                FormBuilderFieldOption(
                                                    value: option,
                                                    child: Text(option)))
                                            .toList()),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Level: ',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                                SizedBox(
                                  width: deviceSize.width * 0.6,
                                  child: FormBuilderDropdown(
                                      name: 'courseType',
                                      initialValue: candidate?.courseType,
                                      validator: (String? value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please Select Level';
                                        }
                                        return null;
                                      },
                                      onChanged: (String? value) =>
                                          _updateLevelDependents(value),
                                      items: options.courseOptions.keys
                                          .map((option) => DropdownMenuItem(
                                                child: Text(option),
                                                value: option,
                                              ))
                                          .toList()),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Course: ',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                                SizedBox(
                                  width: deviceSize.width * 0.6,
                                  child: FormBuilderDropdown(
                                      name: 'course',
                                      // initialValue: candidate?.course,
                                      validator: (String? value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please Select Course';
                                        }
                                        return null;
                                      },
                                      onChanged: (String? value) =>
                                          _updateCourseDependents(value),
                                      items: _courseOptions
                                          .map((option) => DropdownMenuItem(
                                                child: Text(option),
                                                value: option,
                                              ))
                                          .toList()),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Branch: ',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                                SizedBox(
                                  width: deviceSize.width * 0.6,
                                  child: FormBuilderDropdown(
                                      name: 'branch',
                                      // initialValue: candidate?.branch,
                                      validator: (String? value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please Select Branch';
                                        }
                                        return null;
                                      },
                                      items: _branchOptions
                                          .map((option) => DropdownMenuItem(
                                                child: Text(option),
                                                value: option,
                                              ))
                                          .toList()),
                                )
                              ],
                            ),
                            const Divider(),

                            /**------------
                       * PERSONAL DETAILS SECTION
                       */
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FormBuilderTextField(
                                name: 'name',
                                initialValue: candidate?.name,
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Name';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    labelText: 'Student Name',
                                    border: OutlineInputBorder()),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FormBuilderDateTimePicker(
                                name: 'dob',
                                initialValue: candidate?.dob,
                                inputType: InputType.date,
                                initialDate: DateTime.now(),
                                decoration: const InputDecoration(
                                    labelText: 'Date Of Birth',
                                    suffixIcon: Icon(Icons.calendar_month)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FormBuilderTextField(
                                name: 'mobileNumber',
                                initialValue: candidate?.mobileNumber,
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Mobile Number';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    labelText: 'Student Mobile Number',
                                    border: OutlineInputBorder()),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FormBuilderTextField(
                                name: 'parentName',
                                initialValue: candidate?.parentName,
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Field';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    labelText: 'Parent Name',
                                    border: OutlineInputBorder()),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FormBuilderTextField(
                                name: 'parentMobileNumber',
                                initialValue: candidate?.parentMobileNumber,
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Field';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    labelText: 'Parent Mobile Number',
                                    border: OutlineInputBorder()),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FormBuilderTextField(
                                name: 'parentOccupation',
                                initialValue: candidate?.parentOccupation,
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Field';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    labelText: "Parent Occupation",
                                    border: OutlineInputBorder()),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FormBuilderTextField(
                                name: 'address',
                                initialValue: candidate?.address,
                                maxLines: 3,
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Field';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    labelText: 'Address',
                                    border: OutlineInputBorder()),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FormBuilderTextField(
                                name: 'prevInstitute',
                                initialValue: candidate?.previousInstituteName,
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Previous Insitute Name';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    labelText: 'Previous Institute Name',
                                    border: OutlineInputBorder()),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FormBuilderTextField(
                                name: 'rollNo',
                                initialValue: candidate?.rollNoLastExam,
                                keyboardType: TextInputType.number,
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Roll No of Last Examination';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    labelText: 'Roll No Last Exam',
                                    border: OutlineInputBorder()),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FormBuilderTextField(
                                name: 'feeForSem',
                                initialValue: candidate?.feeForSem.toString(),
                                keyboardType: TextInputType.number,
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Semester Fee';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
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
                                initialValue:
                                    candidate?.paidByStudent.toString(),
                                keyboardType: TextInputType.number,
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Amount paid by student';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    prefixIcon:
                                        Icon(Icons.currency_rupee_rounded),
                                    labelText: 'Amount Paid By Student',
                                    border: OutlineInputBorder()),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FormBuilderTextField(
                                name: 'cancellationCharge',
                                initialValue:
                                    candidate?.cancellationCharge.toString(),
                                keyboardType: TextInputType.number,
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Cancellation Charges';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    prefixIcon:
                                        Icon(Icons.currency_rupee_rounded),
                                    labelText: 'Cancellation Charges',
                                    border: OutlineInputBorder()),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FormBuilderTextField(
                                name: 'remark',
                                initialValue: candidate?.remark,
                                maxLines: 3,
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Field';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    labelText: 'Remark',
                                    border: OutlineInputBorder()),
                              ),
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Category: ',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                                SizedBox(
                                  width: deviceSize.width * 0.6,
                                  child: FormBuilderDropdown(
                                    name: 'category',
                                    initialValue: candidate?.category,
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please Select Field';
                                      }
                                      return null;
                                    },
                                    items: ["General", "OBC", "ST", "SC"]
                                        .map((option) => DropdownMenuItem(
                                              value: option,
                                              child: Text(option),
                                            ))
                                        .toList(),
                                  ),
                                )
                              ],
                            ),
                            FormBuilderCheckbox(
                                decoration: const InputDecoration(),
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                name: 'eligibleForScholarship',
                                initialValue: candidate?.eligibleForScholarship,
                                title: const Text(
                                  'Is Candidate Eligible For Scholarship?',
                                  style: TextStyle(fontSize: 18),
                                )),
                            /** -----------
                             * Entrance Exam Section
                             */
                            Row(
                              children: [
                                const Text(
                                  'Appeared in entrance exam: ',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                                SizedBox(
                                  width: deviceSize.width * 0.3,
                                  child: FormBuilderDropdown(
                                    name: 'examAppearance',
                                    initialValue: candidate?.nameEntranceExam ==
                                            null
                                        ? null
                                        : (candidate!.appearedInEntranceExam ==
                                                true
                                            ? 'Yes'
                                            : 'No'), //FIXME: better this confusing code
                                    onChanged: _updateExamAppearanceDependents,
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please Select Field';
                                      }
                                      return null;
                                    },
                                    items: ["Yes", "No"]
                                        .map((option) => DropdownMenuItem(
                                              value: option,
                                              child: Text(option),
                                            ))
                                        .toList(),
                                  ),
                                )
                              ],
                            ),
                            if (_appearedInEntranceExam)
                              Row(
                                children: [
                                  const Text(
                                    'Name of Exam: ',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Spacer(),
                                  SizedBox(
                                    width: deviceSize.width * 0.6,
                                    child: FormBuilderDropdown(
                                      name: 'nameExam',
                                      initialValue: candidate?.nameEntranceExam,
                                      validator: (String? value) {
                                        if (_appearedInEntranceExam) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please Select Field';
                                          }
                                        }
                                        return null;
                                      },
                                      items: [
                                        "PET",
                                        "JEE",
                                        "CMAT",
                                        "ATMA",
                                        "MAT",
                                        "GATE",
                                        "GPAT",
                                        "PPHT",
                                        "CPAT",
                                        "N/A" //FIXME: if possible
                                      ]
                                          .map((option) => DropdownMenuItem(
                                                value: option,
                                                child: Text(option),
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
                                  initialValue: candidate?.rankEntranceExam,
                                  validator: (String? value) {
                                    if (_appearedInEntranceExam) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please Provide Rank';
                                      }
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                      labelText: 'Entrance Exam Rank',
                                      border: OutlineInputBorder()),
                                ),
                              ),
                            if (_appearedInEntranceExam)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FormBuilderTextField(
                                  name: 'scoreExam',
                                  initialValue: candidate?.rankEntranceExam,
                                  validator: (String? value) {
                                    if (_appearedInEntranceExam) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please Provide Score Of Entrance Exam';
                                      }
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                      labelText: 'Entrance Exam Score',
                                      border: OutlineInputBorder()),
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FormBuilderTextField(
                                name: 'admittedBy',
                                initialValue: candidate?.admittedBy,
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Admitted By';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    labelText: 'Admitted By',
                                    border: OutlineInputBorder()),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FormBuilderTextField(
                                name: 'admissionIncharge',
                                initialValue: candidate?.admissionIncharge,
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Admission Incharge Name';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    labelText: 'Admission Incharge Name',
                                    border: OutlineInputBorder()),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FormBuilderTextField(
                                name: 'session',
                                initialValue: candidate?.session,
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Session';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    labelText: 'Session',
                                    border: OutlineInputBorder()),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FormBuilderDateTimePicker(
                                name: 'admissionDate',
                                initialValue:
                                    candidate?.admissionDate ?? DateTime.now(),
                                inputType: InputType.date,
                                initialDate: DateUtils.dateOnly(DateTime.now()),
                                decoration: const InputDecoration(
                                    labelText: 'Date Of Admission',
                                    suffixIcon: Icon(Icons.calendar_month)),
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
                          icon: const Icon(Icons.restore),
                          label: const Text('Reset'),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        // TODO: Show confirm dialog
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton.icon(
                            onPressed: () => _submit(context),
                            icon: const Icon(Icons.save),
                            label: const Text('Submit')),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
