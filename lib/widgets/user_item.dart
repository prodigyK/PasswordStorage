import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:password_storage_app/models/user.dart';
import 'package:password_storage_app/providers/user_repository.dart';
import 'package:password_storage_app/screens/users/user_details_screen.dart';
import 'package:provider/provider.dart';

class UserItem extends StatelessWidget {
  const UserItem({
    Key key,
    @required this.users,
    @required this.index,
  }) : super(key: key);

  final List<User> users;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(users[index].id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          size: 40,
          color: Colors.white,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 0,
          vertical: 0,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to remove?'),
            actions: [
              TextButton(
                child: Text('Yes'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
              TextButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        Provider.of<UserRepository>(context, listen: false).removeUser(users[index]);
      },
      child: ListTile(
        minVerticalPadding: 0,
        minLeadingWidth: 50,
        isThreeLine: true,
        contentPadding: EdgeInsets.only(left: 16, right: 10),
        leading: Icon(
          FontAwesome5.user,
          size: 30,
          // color: Colors.green.shade200,
        ),
        title: Text(
          users[index].name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(users[index].password),
        trailing: Container(
          padding: EdgeInsets.only(top: 7),
          child: Icon(
            Icons.arrow_forward_ios,
            size: 16,
          ),
        ),
        onTap: () {
          Navigator.of(context).pushNamed(
            UserDetailScreen.routeName,
            arguments: {'user': users[index]},
          );
        },
      ),
    );
  }
}
