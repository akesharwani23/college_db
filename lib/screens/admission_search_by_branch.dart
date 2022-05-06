import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/admission_candidate.dart';
import '../models/form_options.dart';
import '../providers/admission_candidates.dart';
import './admission_detail_screen.dart';

class AdmissionSearchByBranch extends StatefulWidget {
  static const routeName = 'search-admission-by-branch';

  const AdmissionSearchByBranch({Key? key}) : super(key: key);

  @override
  State<AdmissionSearchByBranch> createState() =>
      _AdmissionSearchByBranchState();
}

class _AdmissionSearchByBranchState extends State<AdmissionSearchByBranch> {
  DateTime? _selectedDate;
  String? _selectedCourse;
  String? _selectedBranch;
  List<String> _branchOptions = [];
  static const Map<String, Color> _statusColor = {
    'Confirmed': Colors.greenAccent,
    'Provisional': Colors.yellowAccent,
    'Registration': Colors.redAccent,
  };

  List<AdmissionCandidate> _distinctCandidates(
      List<AdmissionCandidate> candidates) {
    List<String> listId = [];
    List<AdmissionCandidate> _distinctCandidates = [];
    for (final candidate in candidates) {
      if (listId.contains(candidate.id!)) {
        // do nothing
      }
      listId.add(candidate.id!);
      _distinctCandidates.add(candidate);
    }
    return _distinctCandidates;
  }

  void _updateCourseDependents(String? value, {bool resetValue = true}) {
    if (value == null) {
      return;
    }
    setState(() {
      _selectedBranch = null;
      _branchOptions = branchOptions[value] as List<String>;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search Admission Record',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(children: [
        const SizedBox(height: 10),
        Center(
          child: Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
                border: Border.all(), borderRadius: BorderRadius.circular(15)),
            child: DropdownButton<String>(
                value: _selectedCourse,
                isExpanded: true,
                hint: Text('Course'),
                underline: const SizedBox.shrink(),
                items: branchOptions.keys
                    .map((e) =>
                        DropdownMenuItem<String>(child: Text(e), value: e))
                    .toList(),
                onChanged: (dy) {
                  setState(() {
                    _selectedCourse = dy!;
                    _updateCourseDependents(_selectedCourse);
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
              borderRadius: BorderRadius.circular(15),
            ),
            child: DropdownButton<String>(
              value: _selectedBranch,
              hint: const Text('Branch'),
              isExpanded: true,
              underline: const SizedBox.shrink(),
              items: _branchOptions
                  .map(
                      (e) => DropdownMenuItem<String>(child: Text(e), value: e))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedBranch = value!;
                });
              },
            ),
          ),
        ),
        Row(
          children: [
            const Spacer(),
            const Text(
              'Filter By:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton.icon(
                  onPressed: () async {
                    final date = await _showDatePicker(context);
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                  icon: const Icon(Icons.calendar_month),
                  label: Text(_selectedDate == null
                      ? 'Date'
                      : DateFormat('dd-MM-yy').format(_selectedDate!))),
            ),
            if (_selectedDate != null)
              TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _selectedDate = null;
                    });
                  },
                  icon: const Icon(
                    Icons.cancel_outlined,
                    color: Colors.redAccent,
                  ),
                  label: const Text(
                    'Clear Filter',
                    style: TextStyle(color: Colors.redAccent),
                  ))
          ],
        ),
        if (_selectedBranch == null || _selectedCourse == null)
          const Text('Select Field')
        else
          StreamBuilder<List<AdmissionCandidate>>(
            stream: Provider.of<AdmissionCandidates>(context)
                .getCandidatesWithCourseAndBranchName(
                    _selectedCourse!, _selectedBranch!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.connectionState == ConnectionState.active ||
                  snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  var candidates = snapshot.data!;
                  if (_selectedDate != null) {
                    candidates.removeWhere((candidate) =>
                        candidate.admissionDate != _selectedDate);
                  }
                  return _candidateCard(candidates);
                }
              }
              return const Text('No Data');
            },
          )
      ]),
    );
  }

  Expanded _candidateCard(List<AdmissionCandidate> candidates) {
    return Expanded(
      child: ListView.builder(
        itemCount: candidates.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: ListTile(
                  title: Text(
                      '${candidates[index].name}\n[${candidates[index].parentName}]'),
                  subtitle: Text(candidates[index].branch),
                  trailing: CircleAvatar(
                      backgroundColor: _statusColor[candidates[index].status],
                      maxRadius: 8),
                  onTap: () => Navigator.of(context).pushNamed(
                      AdmissionDetailScreen.routeName,
                      arguments: candidates[index])),
            ),
          );
        },
      ),
    );
  }

  Future<DateTime?> _showDatePicker(BuildContext context) async {
    return await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.parse("1900-01-01"),
        lastDate: DateTime.now());
  }
}
