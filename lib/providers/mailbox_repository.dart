import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:password_storage_app/models/mailbox.dart';

class MailboxRepository with ChangeNotifier {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseFirestore get instance => _firestore;

  Stream<QuerySnapshot> snapshots() {
    return _firestore.collection('mailboxes').snapshots();
  }

  CollectionReference collection() {
    return _firestore.collection('mailboxes');
  }

  Future<bool> addMailbox(Mailbox mailbox) {
    return collection().add(mailbox.toJson()).then((value) => true).catchError((error) => false);
  }

  Future<bool> updateMailbox(Mailbox mailbox) {
    return collection().doc(mailbox.id).update(mailbox.toJson()).then((value) => true).catchError((error) => false);
  }

  Future<List<Mailbox>> getAllDocuments() async {
    List<Mailbox> mailboxes = [];
    final querySnapshot = await collection().get();
    querySnapshot.docs.forEach((mailbox) {
      mailboxes.add(
        Mailbox(
          id: mailbox.id,
          name: mailbox['name'],
          password: mailbox['password'],
          domainId: mailbox['domain_id'],
          modifiedAt: DateTime.parse(mailbox['modifiedAt']),
        ),
      );
    });
    return mailboxes;
  }

  Future<bool> contains(String mailbox, {String docID}) async {
    final mailboxes = await getAllDocuments();
    bool exists = mailboxes.any((element) => element.name == mailbox);
    if (docID == null) {
      return exists;
    } else {
      if(exists) {
        final doc = mailboxes.firstWhere((element) => element.name == mailbox);
        return doc.id == docID; // Means the same doc
      } else {
        return false;
      }
    }
  }
}
