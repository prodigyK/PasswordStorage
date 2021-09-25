import 'package:flutter/cupertino.dart';

class MailboxesByDomainsScreen extends StatelessWidget {
  static const String routeName = '/mailboxes-by-domains';

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Mailboxes by Domains'),
      ),
      child: Container(),
    );
  }
}
