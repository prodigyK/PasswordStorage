import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:password_storage_app/models/hosting.dart';
import 'package:password_storage_app/models/user.dart';
import 'package:password_storage_app/providers/encryption.dart';
import 'package:password_storage_app/providers/hosting_firestore_repository.dart';
import 'package:password_storage_app/providers/hosting_repository.dart';
import 'package:password_storage_app/providers/mailbox_repository.dart';
import 'package:password_storage_app/providers/user_firestore_repository.dart';
import 'package:password_storage_app/providers/user_repository.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/settings';

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String text = 'progress...';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(10.0),
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Expanded(
              //     child: Column(
              //   children: [
              //     Center(child: Text('Under construction...', style: TextStyle(fontSize: 24))),
              //     ElevatedButton(
              //       child: Text('Load hostings into Firestore'),
              //       onPressed: () async {
              //         final provider = Provider.of<MailboxRepository>(context, listen: false);
              //         await provider.collection().get().then((snapshot) {
              //           snapshot.docs.forEach((doc) async {
              //             print(doc.id);
              //             await provider.updateField(doc.id);
              //           });
              //         });
              //
              //         setState(() {
              //           text = 'Completed';
              //         });
              //       },
              //     ),
              //   ],
              // )),
              ElevatedButton.icon(
                icon: Icon(Icons.logout),
                label: Text('Sign Out'),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pop();
                },
              ),
              SizedBox(height: 20),

              // SizedBox(height: 20.0),
              // Center(child: Text('Under construction...', style: TextStyle(fontSize: 24))),
            ],
          ),
        ),
      ),
    );
  }
}
