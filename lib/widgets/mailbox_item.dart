import 'package:flutter/material.dart';
import 'package:password_storage_app/models/mailbox.dart';
import 'package:password_storage_app/providers/encryption.dart';
import 'package:provider/provider.dart';

class MailboxItem extends StatelessWidget {
  const MailboxItem({
    Key? key,
    required this.mailbox,
    required this.navigate,
  }) : super(key: key);

  final Mailbox mailbox;
  final Function()? navigate;

  @override
  Widget build(BuildContext context) {
    final password = Provider.of<Encryption>(context, listen: false).decrypt(encoded: mailbox.password);
    return GestureDetector(
      key: ValueKey(mailbox.id),
      child: Container(
        // color: Colors.black,
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
        padding: EdgeInsets.symmetric(vertical: 1.0),
        child: Card(
          elevation: 3,
          margin: EdgeInsets.zero,
          color: Colors.grey.shade50,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(width: 0.2),
          ),
          child: ListTile(
            leading: Icon(
              Icons.email,
              size: 30,
              color: Colors.blue.shade200,
            ),
            title: Text(
              mailbox.name,
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
      onTap: navigate,
    );
  }
}
