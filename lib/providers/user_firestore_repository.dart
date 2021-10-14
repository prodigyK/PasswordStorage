import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:password_storage_app/models/user.dart';

class UserFirestoreRepository with ChangeNotifier {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<User> _users = [];

  List<User> get users => [..._users];

  FirebaseFirestore get instance => _firestore;

  CollectionReference collection() {
    return _firestore.collection('users');
  }

  Future<bool> addUser(User user) {
    return collection().add(user.toJson()).then((value) => true).catchError((error) => false);
  }

  Future<bool> updateUser(User user) {
    return collection().doc(user.id).update(user.toJson()).then((value) => true).catchError((error) => false);
  }

  Future<void> removeUser(User user) {
    return collection().doc(user.id).delete();
  }

  Future<List<User>> getAllDocuments() async {
    List<User> users = [];
    final querySnapshot = await collection().get();
    querySnapshot.docs.forEach((user) {
      users.add(
        User.fromJson(user.data() as Map<String, dynamic>, docID: user.id),
      );
    });
    _users = users;
    notifyListeners();
    return users;
  }
}
