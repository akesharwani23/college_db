import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_db/screens/admission_detail_screen.dart';
import 'package:college_db/screens/admission_form_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class AdmissionSectionScreen extends StatefulWidget {
  const AdmissionSectionScreen({Key? key}) : super(key: key);

  @override
  State<AdmissionSectionScreen> createState() => _AdmissionSectionScreenState();
}

class _AdmissionSectionScreenState extends State<AdmissionSectionScreen> {
  var _value = false;
  var _isAbleToAddRecord = false;

  void _openAdmissionDetails(String id) {
    Navigator.of(context)
        .pushNamed(AdmissionDetailScreen.routeName, arguments: id);
  }

  @override
  void initState() {
    _asyncFunc();
    super.initState();
  }

  void _asyncFunc() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      _isAbleToAddRecord = snapshot.data()!['isAdmin']; //FIXME: try catch?
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: _isAbleToAddRecord
            ? FloatingActionButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(AdmissionFormScreen.routeName);
                },
                child: Icon(Icons.add),
              )
            : null,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    // labelText: 'Search By Name',
                    hintText: 'Search By Name',
                    // icon: Icon(Icons.search),
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              FutureBuilder(
                future:
                    FirebaseFirestore.instance.collection('admissions').get(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasData && !snapshot.data!.docs.isNotEmpty) {
                    return Text("Document does not exist");
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    final docs = snapshot.data!.docs;
                    return Container(
                      height: 300,
                      child: ListView.builder(
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 4),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: ListTile(
                                title: Text(docs[index]['name']),
                                subtitle: Text(docs[index]['parentName']),
                                trailing: CircleAvatar(
                                    backgroundColor:
                                        docs[index]['status'] == 'Confirmed'
                                            ? Colors.greenAccent
                                            : Colors.redAccent,
                                    maxRadius: 8),
                                onTap: () =>
                                    _openAdmissionDetails(docs[index].id),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                  return Text('working..');
                },
              )
            ],
          ),
        ));
  }
}
