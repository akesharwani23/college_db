import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/admission_candidate.dart';
import '../providers/admission_candidates.dart';
import './admission_detail_screen.dart';

class AdmissionSearchByDate extends StatefulWidget {
  const AdmissionSearchByDate({Key? key}) : super(key: key);
  static const routeName = '/search-admission-by-date-data';

  @override
  State<AdmissionSearchByDate> createState() => _AdmissionSearchByDateState();
}

class _AdmissionSearchByDateState extends State<AdmissionSearchByDate> {
  DateTime? _selectedDate;
  final List<AdmissionCandidate> _candidates = [];
  AdmissionCandidate? _lastFetchedCandidate;
  static const Map<String, Color> _statusColor = {
    'Confirmed': Colors.greenAccent,
    'Provisional': Colors.yellowAccent,
    'Registration': Colors.redAccent,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search By Admission Date'),
      ),
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 62,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                  onPressed: () async {
                    final date = await _showDatePicker(context);
                    setState(() {
                      _selectedDate = date;
                      _candidates.clear();
                    });
                  },
                  icon: const Icon(Icons.calendar_month),
                  label: Text(_selectedDate == null
                      ? 'Date'
                      : DateFormat('dd-MM-yy').format(_selectedDate!))),
            ),
          ),
          if (_selectedDate == null)
            const Text('Select Date')
          else
            StreamBuilder<List<AdmissionCandidate>>(
              stream: Provider.of<AdmissionCandidates>(context)
                  .getCandidatesWithAdmissionDate(
                      _selectedDate?.toIso8601String() ??
                          DateTime.now().toIso8601String(),
                      startAfter: _lastFetchedCandidate),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.connectionState == ConnectionState.done ||
                    snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    final candidates = snapshot.data;
                    if (candidates!.isNotEmpty) {
                      _lastFetchedCandidate = candidates.last;
                      _candidates.addAll(candidates);
                    }
                    return _candidateCard(_candidates);
                  }
                }

                return const Text('No Data');
              },
            )
        ],
      ),
      bottomSheet: TextButton(
          onPressed: () {
            setState(() {});
          },
          child: const Text('Load More'),
          style: TextButton.styleFrom(minimumSize: const Size.fromHeight(50))),
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
