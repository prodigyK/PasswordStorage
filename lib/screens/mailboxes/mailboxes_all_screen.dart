import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:password_storage_app/models/mailbox.dart';
import 'package:password_storage_app/screens/mailboxes/mailbox_detail_screen.dart';

class MailboxAllScreen extends StatefulWidget {
  static const String routeName = '/mailbox-all';

  @override
  _MailboxAllScreenState createState() => _MailboxAllScreenState();
}

class _MailboxAllScreenState extends State<MailboxAllScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return _buildScaffold(context, width: 600);
        } else {
          return _buildScaffold(context, width: double.infinity);
        }
      }),
    );
  }

  Widget _buildScaffold(BuildContext context, {double width}) {
    return Container(
      width: width,
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: width),
        child: Scaffold(
          appBar: AppBar(
              title: Text('All Mailboxes', style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.blue.shade200,
              actions: [
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {},
                ),
                SizedBox(width: 20),
                IconButton(
                  icon: Icon(Icons.add_box),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      MailboxDetailScreen.routeName,
                      arguments: {'isNew': true},
                    );
                  },
                )
              ]),
          backgroundColor: Colors.white,
          body: Container(
            margin: EdgeInsets.only(top: 8.0),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('mailboxes').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data.docs;
                return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (ctx, i) {
                      return GestureDetector(
                        key: ValueKey(docs[i].id),
                        child: Container(
                          // color: Colors.black,
                          margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                          padding: EdgeInsets.symmetric(vertical: 2.0),
                          child: Card(
                            elevation: 3,
                            margin: EdgeInsets.zero,
                            color: Colors.grey.shade200,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                            child: ListTile(
                              leading: Icon(
                                Icons.email,
                                size: 30,
                              ),
                              title: Text(docs[i]['name'], style: TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(docs[i]['password']),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          final docID = docs[i].id;
                          Mailbox mailbox = Mailbox.fromJson(docs[i].data() as Map<String, dynamic>, docID: docID);
                          Navigator.pushNamed(
                            context,
                            MailboxDetailScreen.routeName,
                            arguments: {
                              'isNew': false,
                              'mailbox': mailbox,
                            },
                          );
                        },
                      );
                    });
              },
            ),
          ),
        ),
      ),
    );
  }
}
