import 'package:college_db/providers/admission_candidates.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/admission_candidate.dart';
import '../screens/admission_detail_screen.dart';

class SearchAdmissionRecord extends SearchDelegate<AdmissionCandidate?> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder<List<AdmissionCandidate>>(
      stream: Provider.of<AdmissionCandidates>(context)
          .getCandidatesWithNameStartingFrom(query.trim()),
      builder: (context, candidatesSnapshot) {
        if (candidatesSnapshot.hasData) {
          final candidates = candidatesSnapshot.data;
          return ListView.builder(
            itemCount: candidatesSnapshot.data!.length,
            itemBuilder: (context, index) => ListTile(
              onTap: () {
                Navigator.of(context).pushReplacementNamed(
                    AdmissionDetailScreen.routeName,
                    arguments: candidates![index].id);
              },
              leading: const Icon(
                Icons.person,
                color: Colors.blue,
              ),
              title: Text(candidates![index].name),
              subtitle: Text(candidates[index].parentName),
            ),
          );
        }
        return const Center(
          child: Text(
            'No Result',
            style: TextStyle(fontSize: 18),
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder<List<AdmissionCandidate>>(
      stream: Provider.of<AdmissionCandidates>(context).getCandidateAsStream(),
      builder: (context, candidatesSnapshot) {
        if (candidatesSnapshot.hasData) {
          final candidates = candidatesSnapshot.data;
          return ListView.builder(
            itemCount: candidatesSnapshot.data!.length,
            itemBuilder: (context, index) => ListTile(
              onTap: () {
                Navigator.of(context).pushReplacementNamed(
                    AdmissionDetailScreen.routeName,
                    arguments: candidates![index].id);
              },
              leading: const Icon(Icons.person),
              title: Text(candidates![index].name),
              subtitle: Text(candidates[index].parentName),
            ),
          );
        }
        return const Center(
          child: Text(
            'No Data',
            style: TextStyle(fontSize: 18),
          ),
        );
      },
    );
  }
}
