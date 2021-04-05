

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmailsScreen extends StatelessWidget {
  static const routeName = '/emails-screen';

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('E-mails'),
      ),
      child: SizedBox(),
    );
  }
}
