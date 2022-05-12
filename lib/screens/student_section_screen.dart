import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/admission_candidate.dart';
import '../providers/admission_candidates.dart';
import 'admission_detail_screen.dart';

class StudentSectionScreen extends StatefulWidget {
  const StudentSectionScreen({Key? key}) : super(key: key);

  static const Map<String, Color> _statusColor = {
    'Confirmed': Colors.greenAccent,
    'Provisional': Colors.yellowAccent,
    'Registration': Colors.redAccent,
  };

  @override
  State<StudentSectionScreen> createState() => _StudentSectionScreenState();
}

class _StudentSectionScreenState extends State<StudentSectionScreen> {
  AdmissionCandidate? _lastFetchedCandidate;
  final List<AdmissionCandidate> _candidates = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          StreamBuilder<List<AdmissionCandidate>>(
              stream: Provider.of<AdmissionCandidates>(context)
                  .getCandidatesWithStatus(startAfter: _lastFetchedCandidate),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.connectionState == ConnectionState.active ||
                    snapshot.connectionState == ConnectionState.done) {
                  final candidates = snapshot.data;
                  if (snapshot.hasData) {
                    if (candidates!.isNotEmpty) {
                      _lastFetchedCandidate = candidates.last;
                      _candidates.addAll(candidates);
                    }
                    return Expanded(
                      child: ListView.builder(
                        itemCount: _candidates.length,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 4),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: ListTile(
                                  title: Text(_candidates[index].name),
                                  subtitle: Text(_candidates[index].parentName),
                                  trailing: CircleAvatar(
                                      backgroundColor:
                                          StudentSectionScreen._statusColor[
                                              _candidates[index].status],
                                      maxRadius: 8),
                                  onTap: () => Navigator.of(context).pushNamed(
                                      AdmissionDetailScreen.routeName,
                                      arguments: _candidates[index])),
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return const Center(child: Text('No Data'));
                  }
                }
                return const Center(child: Text('No Data'));
              }),
          const SizedBox(
            height: 20,
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
}
