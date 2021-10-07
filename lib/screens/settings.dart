import 'package:flutter/material.dart';
import 'package:password_storage_app/models/hosting.dart';
import 'package:password_storage_app/models/user.dart';
import 'package:password_storage_app/providers/encryption.dart';
import 'package:password_storage_app/providers/hosting_firestore_repository.dart';
import 'package:password_storage_app/providers/hosting_repository.dart';
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
            //   child: Text('Load hostings into Firestore'),
            //   onPressed: () {
            //     final provider = Provider.of<HostingRepository>(context, listen: false);
            //     provider.fetchAndSetHostings();
            //     final providerFirestore = Provider.of<HostingFirestoreRepository>(context, listen: false);
            //     int count = 0;
            //     provider.hostings.forEach((hosting) {
            //       // if(count > 2) {
            //       //   return;
            //       // }
            //       final cryptedHostingPassword = Provider.of<Encryption>(context, listen: false).encrypt(text: hosting.hostingPass);
            //       final cryptedRdpPassword = Provider.of<Encryption>(context, listen: false).encrypt(text: hosting.rdpPass);
            //       final newHosting =  Hosting(
            //         id: hosting.id,
            //         name: hosting.name,
            //         hostingName: hosting.hostingName,
            //         hostingLogin: hosting.hostingLogin,
            //         hostingPass: cryptedHostingPassword,
            //         rdpIp: hosting.rdpIp,
            //         rdpLogin: hosting.rdpLogin,
            //         rdpPass: cryptedRdpPassword,
            //       );
            //       providerFirestore.addHosting(newHosting);
            //       print(newHosting.name);
            //       print(newHosting.hostingPass);
            //       print(Provider.of<Encryption>(context, listen: false).decrypt(encoded: cryptedHostingPassword));
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
