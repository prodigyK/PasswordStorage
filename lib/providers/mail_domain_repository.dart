import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:password_storage_app/models/domain.dart';

class MailDomainRepository with ChangeNotifier {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseFirestore get instance => _firestore;


  Stream<QuerySnapshot> snapshots() {
    return collection().snapshots();
  }

  CollectionReference collection() {
    return _firestore.collection('domains');
  }

  Future<bool> addDomain(Domain domain) {
    return collection().add(domain.toJson()).then((value) => true).catchError((error) => false);
  }

  Future<bool> updateDomain(Domain domain) {
    return collection().doc(domain.id).update(domain.toJson()).then((value) => true).catchError((error) => false);
  }

  Future<List<Domain>> getAllDocuments() async {
    List<Domain> domains = [];
    final querySnapshot = await collection().get();
    querySnapshot.docs.forEach((doc) {
      domains.add(Domain.fromJson(doc.data(), docID: doc.id));
    });
    return domains;
  }
}