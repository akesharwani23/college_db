import 'package:cloud_firestore/cloud_firestore.dart';

class ServicesApi {
  final _db = FirebaseFirestore.instance;
  final String _collection;
  late CollectionReference ref;

  /// creates api ref for collection with [_collection] name
  ServicesApi(this._collection) {
    ref = _db.collection(_collection);
  }

  Future<QuerySnapshot> get getDataCollection => ref.get();

  Stream<QuerySnapshot> get streamDataCollection => ref.snapshots();

  Future<DocumentSnapshot> getDocumentById(String id) => ref.doc(id).get();

  Future<void> removeDocument(String id) => ref.doc(id).delete();

  Future<DocumentReference> addDocument(Map data) => ref.add(data);

  Future<void> updateDocument(Map<String, dynamic> data, String id) =>
      ref.doc(id).update(data);
}
