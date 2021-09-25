import 'package:flutter/cupertino.dart';

class MailboxByDomainScreen extends StatelessWidget {
  static const String routeName = '/mailbox-domain';

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
