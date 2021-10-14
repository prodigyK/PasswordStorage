import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:password_storage_app/models/service.dart';

class MailServiceRepository with ChangeNotifier {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseFirestore get instance => _firestore;

  Stream<QuerySnapshot> snapshots() {
    return _firestore.collection('services').snapshots();
  }

  CollectionReference collection() {
    return _firestore.collection('services');
  }

  Future<bool> addService(Service service) {
    return collection().add(service.toJson()).then((value) => true).catchError((error) => false);
  }

  Future<bool> updateService(Service service) {
    return collection().doc(service.id).update(service.toJson()).then((value) => true).catchError((error) => false);
  }

  Future<DocumentSnapshot> getService(String serviceId) {
    return collection().doc(serviceId).get();
  }

  Future<List<Service>> getAllDocuments() async {
    List<Service> services = [];
    final querySnapshot = await collection().orderBy('name').get();
    querySnapshot.docs.forEach((doc) {
      services.add(Service.fromJson(doc.data() as Map<String, dynamic>, docID: doc.id));
    });
    return services;
  }
}
