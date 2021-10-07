import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:password_storage_app/models/domain.dart';
import 'package:password_storage_app/models/mailbox.dart';
import 'package:password_storage_app/providers/encryption.dart';
import 'package:password_storage_app/providers/mailbox_repository.dart';
import 'package:password_storage_app/screens/mailboxes/mailbox_detail_screen.dart';
import 'package:password_storage_app/widgets/mail_search_delegate.dart';
import 'package:provider/provider.dart';

class MailboxAllScreen extends StatefulWidget {
  static const String routeName = '/mailbox-all';

  @override
  _MailboxAllScreenState createState() => _MailboxAllScreenState();
}

class _MailboxAllScreenState extends State<MailboxAllScreen> {
  var query;
  bool firstInit = true;
  String title = 'All Mailboxes';
  final _searchController = TextEditingController();
  String searchText = '';

  @override
  void didChangeDependencies() {
    if (firstInit) {
      final json = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      Domain domain = json['domain'];
      if (domain == null) {
        query = Provider.of<MailboxRepository>(context, listen: false).collection();
      } else {
        title = domain.name;
        query = Provider.of<MailboxRepository>(context, listen: false).collection().where(
              'domain_id',
              isEqualTo: domain.id,
            );
      }
    }
    firstInit = false;

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

  Widget _buildScaffold(BuildContext context, {double width}) {
    return Container(
      width: width,
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: width),
        child: Scaffold(
          appBar: AppBar(
              title: Text(title, style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.blue.shade200,
              actions: [
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    showSearch(context: context, delegate: MailSearchDelegate());
                  },
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
          body: Column(
            children: [
              Container(
                height: 50,
                margin: EdgeInsets.only(bottom: 0.0),
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Colors.grey),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                  ),
                ),
                child: CupertinoSearchTextField(
                  controller: _searchController,
                  backgroundColor: Colors.white,
                  onChanged: (value) {
                    searchText = value;
                    setState(() {
                      query = Provider.of<MailboxRepository>(context, listen: false)
                          .collection()
                          .where(
                            'name',
                            isGreaterThanOrEqualTo: searchText,
                          )
                          .where('name', isLessThanOrEqualTo: searchText + "\uf8ff");
                    });
                  },
                  onSubmitted: (value) {},
                  onSuffixTap: () {
                    setState(() {
                      _searchController.clear();
                      searchText = '';
                      setState(() {
                        query = Provider.of<MailboxRepository>(context, listen: false).collection();
                      });
                    });
                  },
                ),
              ),
              // SizedBox(height: 5),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 0.0),
                  child: StreamBuilder(
                    stream: query.snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      final docs = snapshot.data.docs;
                      return ListView.builder(
                          itemCount: docs.length,
                          itemBuilder: (ctx, i) {
                            final password =
                                Provider.of<Encryption>(context, listen: false).decrypt(encoded: docs[i]['password']);
                            return GestureDetector(
                              key: ValueKey(docs[i].id),
                              child: Container(
                                // color: Colors.black,
                                margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 1.0),
                                padding: EdgeInsets.symmetric(vertical: 1.0),
                                child: Card(
                                  elevation: 1,
                                  margin: EdgeInsets.zero,
                                  color: Colors.grey    .shade50,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    side: BorderSide(width: 0.2),
                                  ),
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.email,
                                      size: 30,
                                    ),
                                    title: Text(
                                      docs[i]['name'],
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                    ),
                                    subtitle: Text(password),
                                    trailing: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () {
                                final docID = docs[i].id;
                                Mailbox mailbox =
                                    Mailbox.fromJson(docs[i].data() as Map<String, dynamic>, docID: docID);
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
            ],
          ),
        ),
      ),
    );
  }
}
