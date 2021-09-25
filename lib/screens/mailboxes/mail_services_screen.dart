import 'package:flutter/material.dart';
import 'package:password_storage_app/models/service.dart';
import 'package:password_storage_app/providers/mail_service_repository.dart';
import 'package:password_storage_app/screens/mailboxes/mail_services_detail_screen.dart';
import 'package:provider/provider.dart';

class MailServicesScreen extends StatelessWidget {
  static const String routeName = '/mail-services';

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
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Mail Services'),
          backgroundColor: Colors.blue.shade200,
          actions: [
            IconButton(
              icon: Icon(Icons.add_box),
              onPressed: () {
                Navigator.pushNamed(context, MailServicesDetailScreen.routeName);
              },
            )
          ],
        ),
        body: Container(
          margin: EdgeInsets.only(top: 8.0),
          child: StreamBuilder(
              stream: Provider.of<MailServiceRepository>(context, listen: false).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data.docs;
                return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (ctx, i) {
                      return ServiceItem(docs: docs, index: i, key: ValueKey(docs[i].id));
                    });
              }),
        ),
      ),
    );
  }
}

class ServiceItem extends StatelessWidget {
  const ServiceItem({
    Key key,
    @required this.docs,
    @required this.index,
  }) : super(key: key);

  final docs;
  final index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
        padding: EdgeInsets.symmetric(vertical: 2.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.0)),
        child: Card(
          elevation: 5,
          margin: EdgeInsets.zero,
          color: Colors.grey.shade200,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          child: ListTile(
            leading: Icon(Icons.miscellaneous_services, size: 30,),
            title: Text(
              docs[index]['name'],
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 18,
            ),
          ),
        ),
      ),
      onTap: () {
        final docID = docs[index].id;
        Service service = Service.fromJson(docs[index].data() as Map<String, dynamic>, docID: docID);
        Navigator.pushNamed(
          context,
          MailServicesDetailScreen.routeName,
          arguments: {'service': service},
        );
      },
    );
  }
}
