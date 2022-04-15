import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_db/screens/admission_detail_screen.dart';
import 'package:college_db/screens/admission_form_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/admission_candidate.dart';
import '../providers/admission_candidates.dart';

class AdmissionSectionScreen extends StatefulWidget {
  const AdmissionSectionScreen({Key? key}) : super(key: key);

  @override
  State<AdmissionSectionScreen> createState() => _AdmissionSectionScreenState();
}

class _AdmissionSectionScreenState extends State<AdmissionSectionScreen> {
  var _value = false;
  var _isAbleToAddRecord = false;

  @override
  void initState() {
    isCurrentUserAdmin();
    super.initState();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>>
      getCurrentUserDetailSnapshot() async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
  }

  void isCurrentUserAdmin() async {
    final snapshot = await getCurrentUserDetailSnapshot();
    setState(() {
      _isAbleToAddRecord = snapshot.data()!['isAdmin']; //FIXME: try catch?
    });
  }

  @override
  Widget build(BuildContext context) {
    //TODO: make floatinnActionButton with futureBuilder
    return Scaffold(
        floatingActionButton: _isAbleToAddRecord
            ? FloatingActionButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(AdmissionFormScreen.routeName);
                },
                child: const Icon(Icons.add),
              )
            : null,
        body: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            FutureBuilder<List<AdmissionCandidate>>(
              future: Provider.of<AdmissionCandidates>(context).getCandidates(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  final candidates = snapshot.data;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: candidates!.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 4),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: ListTile(
                                title: Text(candidates[index].name),
                                subtitle: Text(candidates[index].parentName),
                                trailing: CircleAvatar(
                                    backgroundColor:
                                        candidates[index].status == 'Confirmed'
                                            ? Colors.greenAccent
                                            : Colors.redAccent,
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
                return const Text('No Data..');
              },
            )
          ],
        ));
  }
}
