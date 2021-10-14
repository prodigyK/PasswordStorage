import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:password_storage_app/models/domain.dart';
import 'package:password_storage_app/models/mailbox.dart';
import 'package:password_storage_app/models/service.dart';
import 'package:password_storage_app/providers/mail_domain_repository.dart';
import 'package:password_storage_app/providers/mail_service_repository.dart';
import 'package:password_storage_app/providers/mailbox_repository.dart';
import 'package:password_storage_app/screens/mailboxes/mailboxes_all_screen.dart';
import 'package:provider/provider.dart';

class MailboxesByDomainsScreen extends StatefulWidget {
  static const String routeName = '/mail-by-domains';

  @override
  State<MailboxesByDomainsScreen> createState() => _MailboxesByDomainsScreenState();
}

class _MailboxesByDomainsScreenState extends State<MailboxesByDomainsScreen> {
  List<Mailbox> mailboxes = [];

  @override
  void didChangeDependencies() async {
    mailboxes = await Provider.of<MailboxRepository>(context, listen: false).getMailboxes();
    super.didChangeDependencies();
  }

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

  Widget _buildScaffold(BuildContext context, {double? width}) {
    return Container(
      width: width,
      child: Scaffold(
        backgroundColor: Colors.blue.shade200,
        appBar: AppBar(
          title: Text('Mailboxes by Domains'),
          backgroundColor: Colors.blue.shade200,
        ),
        body: Container(
          margin: EdgeInsets.only(top: 8.0),
          child: FutureBuilder(
              future: Provider.of<MailDomainRepository>(context, listen: false).collection().orderBy('name').get(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  final domainsDocs = snapshot.data!.docs;
                  return FutureBuilder(
                    future: Provider.of<MailServiceRepository>(context, listen: false).collection().get(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> serviceSnapshot) {
                      if (serviceSnapshot.hasData) {
                        final jsonList = serviceSnapshot.data!.docs;
                        List<Service> services = jsonList
                            .map((element) =>
                                Service.fromJson(element.data() as Map<String, dynamic>, docID: element.id))
                            .toList();
                        return ListView.builder(
                            itemCount: domainsDocs.length,
                            itemBuilder: (ctx, i) {
                              final domainRef = domainsDocs[i];
                              final service = services.firstWhere((element) => element.id == domainRef['service_id']);
                              int mailboxItems =
                                  mailboxes.where((item) => item.domainId == domainRef.id).toList().length;
                              return DomainItem(
                                key: ValueKey(domainRef.id),
                                docs: domainsDocs,
                                index: i,
                                service: service.name,
                                items: mailboxItems,
                              );
                            });
                      }
                      return Center(child: CircularProgressIndicator());
                    },
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
        ),
      ),
    );
  }
}

class DomainItem extends StatelessWidget {
  DomainItem({
    Key? key,
    this.docs,
    this.service,
    this.index,
    required this.items,
  }) : super(key: key);

  final docs;
  final index;
  final String? service;
  final int items;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        // height: 65,
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
        padding: EdgeInsets.symmetric(vertical: 2.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.0)),
        child: Card(
          elevation: 5,
          margin: EdgeInsets.zero,
          color: Colors.grey.shade100,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          child: ListTile(
            horizontalTitleGap: 30,
            leading: CircleAvatar(
              backgroundColor: Colors.blueGrey.shade200,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 0.0),
                child: Text(
                  items.toString(),
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontFamily: 'RobotoCondensed',
                  ),
                ),
              ),
            ),
            title: Text(
              docs[index]['name'],
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(service!),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 18,
            ),
          ),
        ),
      ),
      onTap: () {
        final docID = docs[index].id;
        Domain domain = Domain.fromJson(docs[index].data() as Map<String, dynamic>, docID: docID);
        Navigator.pushNamed(
          context,
          MailboxAllScreen.routeName,
          arguments: {'domain': domain},
        );
      },
    );
  }
}
