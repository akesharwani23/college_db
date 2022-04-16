import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/current_user.dart';
import './admission_detail_screen.dart';
import './admission_form_screen.dart';
import '../models/admission_candidate.dart';
import '../providers/admission_candidates.dart';

class AdmissionSectionScreen extends StatelessWidget {
  const AdmissionSectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: StreamBuilder<CurrentUser?>(
            stream: Provider.of<CurrentUserProvider>(context).cachedUser,
            builder: (context, userStream) {
              if (userStream.connectionState == ConnectionState.active ||
                  userStream.connectionState == ConnectionState.done) {
                if (userStream.hasData) {
                  // got non-null CurrentUser
                  final user = userStream.data!;
                  if (user.isAdmin) {
                    return FloatingActionButton(
                      child: const Icon(Icons.add),
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(AdmissionFormScreen.routeName);
                      },
                    );
                  }
                }
              }
              return const SizedBox.shrink();
            }),
        // floatingActionButton: FutureBuilder<CurrentUser?>(
        //     future: Provider.of<CurrentUserProvider>(context).getCurrentUser,
        //     builder: (context, userSnapshot) {
        //       if (userSnapshot.connectionState == ConnectionState.done) {
        //         if (userSnapshot.hasData) {
        //           // it means successfully got CurrentUser
        //           final user = userSnapshot.data!;
        //           if (user.isAdmin) {
        //             return FloatingActionButton(
        //               child: const Icon(Icons.add),
        //               onPressed: () {
        //                 Navigator.of(context)
        //                     .pushNamed(AdmissionFormScreen.routeName);
        //               },
        //             );
        //           }
        //         }
        //       }
        //       return const SizedBox.shrink();
        //     }),
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
