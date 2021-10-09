import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:password_storage_app/models/hosting.dart';

class HostingFirestoreRepository with ChangeNotifier {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Hosting> _hostings = [];

  List<Hosting> get hostings => [..._hostings];
  FirebaseFirestore get instance => _firestore;

  Stream<QuerySnapshot> snapshots() {
    return _firestore.collection('hostings').snapshots();
  }

  CollectionReference collection() {
    return _firestore.collection('hostings');
  }

  Future<bool> addHosting(Hosting hosting) {
    return collection().add(hosting.toJson()).then((value) => true).catchError((error) => false);
  }

  Future<bool> updateHosting(Hosting hosting) {
    return collection().doc(hosting.id).update(hosting.toJson()).then((value) => true).catchError((error) => false);
  }

  Future<void> removeHosting(Hosting hosting) {
    return collection().doc(hosting.id).delete();
  }

  Future<List<Hosting>> getAllDocuments() async {
    List<Hosting> hostings = [];
    final querySnapshot = await collection().get();
    querySnapshot.docs.forEach((hosting) {
      hostings.add(
        Hosting.fromJson(hosting.data() as Map<String, dynamic>, docID: hosting.id),
      );
    });
    _hostings = hostings;
    notifyListeners();
    return hostings;
  }
}
