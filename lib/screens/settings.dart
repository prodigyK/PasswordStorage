import 'package:flutter/material.dart';
import 'package:password_storage_app/models/user.dart';
import 'package:password_storage_app/providers/encryption.dart';
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
      body: Container(
        margin: EdgeInsets.all(10.0),
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ElevatedButton(
            //   child: Text('Load users into Firestore'),
            //   onPressed: () {
            //     final provider = Provider.of<UserRepository>(context, listen: false);
            //     provider.fetchAndSetUsers();
            //     final firestoreUsers = [];
            //     final providerFirestore = Provider.of<UserFirestoreRepository>(context, listen: false);
            //     int count = 0;
            //     provider.users.forEach((user) {
            //       // if(count > 3) {
            //       //   return;
            //       // }
            //       final cryptedPassword = Provider.of<Encryption>(context, listen: false).encrypt(text: user.password);
            //       final newUser = User(
            //         id: user.id,
            //         name: user.name,
            //         password: cryptedPassword,
            //         description: user.description,
            //         dateTime: user.dateTime,
            //       );
            //       providerFirestore.addUser(newUser);
            //       print(newUser.name);
            //       print(newUser.password);
            //       print(Provider.of<Encryption>(context, listen: false).decrypt(encoded: cryptedPassword));
            //       count++;
            //     });
            //     setState(() {
            //       text = 'Completed';
            //     });
            //   },
            // ),
            SizedBox(height: 20.0),
            Center(child: Text('Under construction...', style: TextStyle(fontSize: 24))),
          ],
        ),
      ),
    );
  }
}
