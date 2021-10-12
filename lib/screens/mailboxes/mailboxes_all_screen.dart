import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:password_storage_app/models/domain.dart';
import 'package:password_storage_app/models/mailbox.dart';
import 'package:password_storage_app/providers/mailbox_repository.dart';
import 'package:password_storage_app/screens/mailboxes/mailbox_detail_screen.dart';
import 'package:password_storage_app/widgets/mail_search_delegate.dart';
import 'package:password_storage_app/widgets/mailbox_item.dart';
import 'package:provider/provider.dart';

class MailboxAllScreen extends StatefulWidget {
  static const String routeName = '/mailbox-all';

  @override
  _MailboxAllScreenState createState() => _MailboxAllScreenState();
}

class _MailboxAllScreenState extends State<MailboxAllScreen> {
  late var query;
  List<Mailbox> mailboxes = [];
  List<Mailbox> searchMailboxes = [];
  bool firstInit = true;
  String title = 'All Mailboxes';
  final _searchController = TextEditingController();
  String searchText = '';
  bool isDomain = false;

  @override
  void didChangeDependencies() async {
    if (firstInit) {
      final json = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      Domain? domain = json['domain'];
      if (domain == null) {
        mailboxes = await Provider.of<MailboxRepository>(context, listen: false).getAllDocuments();
      } else {
        isDomain = true;
        title = domain.name;
        await Provider.of<MailboxRepository>(context, listen: false)
            .collection()
            .where(
              'domain_id',
              isEqualTo: domain.id,
            )
            .get()
            .then((QuerySnapshot snapshot) {
          snapshot.docs.forEach((json) {
            mailboxes.add(Mailbox.fromJson(json.data() as Map<String, dynamic>, docID: json.id));
          });
        });
      }
      setState(() {});
      firstInit = false;
    }

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

  Widget _buildScaffold(BuildContext context, {required double width}) {
    searchMailboxes = searchText.isEmpty
        ? mailboxes
        : mailboxes.where((mailbox) => mailbox.name.toLowerCase().contains(searchText.toLowerCase())).toList();

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
          backgroundColor: Colors.blue.shade200,
          body: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Center(
                      child: Icon(
                    Icons.email_outlined,
                    size: 150,
                    color: Colors.blue.shade100,
                  )),
                  SizedBox(
                    height: 150,
                  )
                ],
              ),
              Column(
                children: [
                  if (!isDomain)
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
                          setState(() {
                            searchText = value;
                          });
                        },
                        onSuffixTap: () {
                          setState(() {
                            _searchController.clear();
                            setState(() {
                              searchText = '';
                            });
                          });
                        },
                      ),
                    ),
                  // SizedBox(height: 5),
                  Expanded(
                    child: ListView.builder(
                        padding: EdgeInsets.only(top: 8.0, bottom: 16.0),
                        itemCount: searchMailboxes.length,
                        itemBuilder: (ctx, i) {
                          return MailboxItem(mailbox: searchMailboxes.elementAt(i));
                        }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
