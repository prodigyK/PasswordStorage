import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:password_storage_app/screens/mailboxes/mailboxes_all_screen.dart';
import 'package:password_storage_app/screens/mailboxes/mailboxes_by_domains_screen.dart';
import 'package:password_storage_app/screens/mailboxes/mail_domains_screen.dart';
import 'package:password_storage_app/screens/mailboxes/mail_services_screen.dart';

class MailboxesMainScreen extends StatelessWidget {
  static const routeName = '/emails-screen';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(builder: (context, constraints) {
        if(constraints.maxWidth > 600) {
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
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text('Mailboxes'),
            backgroundColor: Colors.blue.shade200,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              buildCategory(
                context,
                categoryName: 'All Mailboxes',
                iconData: FontAwesome5.mail_bulk,
                onPressed: () {
                  Navigator.pushNamed(context, MailboxAllScreen.routeName, arguments: {'domain': null});
                },
              ),
              buildCategory(
                context,
                categoryName: 'Mailboxes by Domains',
                iconData: FontAwesome5.align_justify,
                onPressed: () {
                  Navigator.pushNamed(context, MailboxesByDomainsScreen.routeName);
                },
              ),
              SizedBox(height: 16),
              Divider(thickness: 1),
              SizedBox(height: 16),
              buildCategory(
                context,
                categoryName: 'Domains',
                iconData: FontAwesome5.globe_americas,
                onPressed: () {
                  Navigator.pushNamed(context, MailDomainsScreen.routeName);
                },
              ),
              buildCategory(
                context,
                categoryName: 'Mail Services',
                iconData: Icons.miscellaneous_services,
                onPressed: () {
                  Navigator.pushNamed(context, MailServicesScreen.routeName);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCategory(
    BuildContext context, {
    @required String categoryName,
    @required IconData iconData,
    @required Function onPressed,
  }) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
        width: double.infinity,
        height: 70,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.withOpacity(0.5),
                    Colors.blue.withOpacity(0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 8,
                    offset: Offset(0, 2),
                    color: Colors.black26,
                  ),
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  iconData,
                  size: 35,
                  // color: Colors.white,
                ),
                SizedBox(width: 16),
                Text(
                  categoryName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    // color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      onTap: onPressed,
    );
  }
}
