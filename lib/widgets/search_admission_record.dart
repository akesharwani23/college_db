import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('admissions')
          .where('name',
              isGreaterThanOrEqualTo: query.toUpperCase(),
              isLessThan: query.toUpperCase() + 'z')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.docs.length > 0) {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot data = snapshot.data!.docs[index];
              return ListTile(
                  leading: Icon(
                    Icons.person,
                    color: Colors.blue,
                  ),
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed(
                        AdmissionDetailScreen.routeName,
                        arguments: data.id);
                  },
                  title: Text(data['name']),
                  subtitle: Text(data['parentName']));
            },
          );
        }
        return Center(
            child: Text(
          'No Results',
          style: TextStyle(fontSize: 18),
        ));
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('admissions')
          .limit(10)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot data = snapshot.data!.docs[index];
              return ListTile(
                leading: Icon(Icons.person),
                title: Text(data['name']),
                subtitle: Text(data['parentName']),
              );
            },
          );
        }
        return Text('me');
      },
    );
  }
}
