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

// class MaybeWillUseLater extends StatelessWidget {
//   const MaybeWillUseLater({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         FormBuilderFilterChip(
//           name: 'filter_chip',
//           decoration: InputDecoration(
//             labelText: 'Select many options',
//           ),
//           options: [
//             FormBuilderFieldOption(value: 'Test', child: Text('Test')),
//             FormBuilderFieldOption(
//                 value: 'Test 1', child: Text('Test 1')),
//             FormBuilderFieldOption(
//                 value: 'Test 2', child: Text('Test 2')),
//             FormBuilderFieldOption(
//                 value: 'Test 3', child: Text('Test 3')),
//             FormBuilderFieldOption(
//                 value: 'Test 4', child: Text('Test 4')),
//           ],
//         ),
//         FormBuilderChoiceChip(
//           name: 'choice_chip',
//           decoration: InputDecoration(
//             labelText: 'Select an option',
//           ),
//           options: [
//             FormBuilderFieldOption(value: 'Test', child: Text('Test')),
//             FormBuilderFieldOption(
//                 value: 'Test 1', child: Text('Test 1')),
//             FormBuilderFieldOption(
//                 value: 'Test 2', child: Text('Test 2')),
//             FormBuilderFieldOption(
//                 value: 'Test 3', child: Text('Test 3')),
//             FormBuilderFieldOption(
//                 value: 'Test 4', child: Text('Test 4')),
//           ],
//         ),
//         FormBuilderDateTimePicker(
//           name: 'date',
//           // onChanged: _onChanged,
//           inputType: InputType.time,
//           decoration: InputDecoration(
//             labelText: 'Appointment Time',
//           ),
//           initialTime: TimeOfDay(hour: 8, minute: 0),
//           // initialValue: DateTime.now(),
//           // enabled: true,
//         ),
//         FormBuilderDateRangePicker(
//           name: 'date_range',
//           firstDate: DateTime(1970),
//           lastDate: DateTime(2030),
//           // format: DateFormat('yyyy-MM-dd'),
//           // onChanged: _onChanged,
//           decoration: InputDecoration(
//             labelText: 'Date Range',
//             helperText: 'Helper text',
//             hintText: 'Hint text',
//           ),
//         ),
//         FormBuilderSlider(
//           name: 'slider',
//           // validator: FormBuilderValidators.compose([
//           //   FormBuilderValidators.min(context, 6),
//           // ]),
//           // onChanged: _onChanged,
//           min: 0.0,
//           max: 10.0,
//           initialValue: 7.0,
//           divisions: 20,
//           activeColor: Colors.red,
//           inactiveColor: Colors.pink[100],
//           decoration: InputDecoration(
//             labelText: 'Number of things',
//           ),
//         ),
//         FormBuilderCheckbox(
//           name: 'accept_terms',
//           initialValue: false,
//           // onChanged: _onChanged,
//           title: RichText(
//             text: TextSpan(
//               children: [
//                 TextSpan(
//                   text: 'I have read and agree to the ',
//                   style: TextStyle(color: Colors.black),
//                 ),
//                 TextSpan(
//                   text: 'Terms and Conditions',
//                   style: TextStyle(color: Colors.blue),
//                 ),
//               ],
//             ),
//           ),
//           // validator: FormBuilderValidators.equal(
//           //   context,
//           //   true,
//           //   errorText: 'You must accept terms and conditions to continue',
//           // ),
//         ),
//         FormBuilderTextField(
//           name: 'age',
//           decoration: InputDecoration(
//             labelText:
//                 'This value is passed along to the [Text.maxLines] attribute of the [Text] widget used to display the hint text.',
//           ),
//           // onChanged: _onChanged,
//           validator: (value) {
//             if (value != null && int.parse(value) < 18) {
//               return 'You cannot enter';
//             }
//           },
//           // valueTransformer: (text) => num.tryParse(text),
//           // validator: FormBuilderValidators.compose([
//           //   FormBuilderValidators.required(context),
//           //   FormBuilderValidators.numeric(context),
//           //   FormBuilderValidators.max(context, 70),
//           // ]),
//           keyboardType: TextInputType.number,
//         ),
//         FormBuilderDropdown(
//           name: 'gender',
//           decoration: InputDecoration(
//             labelText: 'Gender',
//           ),
//           // initialValue: 'Male',
//           allowClear: true,
//           hint: Text('Select Gender'),
//           validator: (value) {
//             if (value == null) {
//               return 'please select something';
//             }
//           },
//           items: ["MALE", "FEMALE", "OTHER"]
//               .map((gender) => DropdownMenuItem(
//                     value: gender,
//                     child: Text('$gender'),
//                   ))
//               .toList(),
//         ),
//       ],
//     );
//   }
// }
