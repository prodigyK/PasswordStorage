import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:password_storage_app/models/user.dart';
import 'package:password_storage_app/providers/auth.dart';
import 'package:password_storage_app/providers/user_repository.dart';
import 'package:password_storage_app/utils/file_manager.dart';
import 'package:provider/provider.dart';

import '../app_data.dart';
import '../widgets/category_item.dart';
import '../screens/settings.dart';

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Password Storage'),
//        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              _showModalPopup(context);
            },
          ),
        ],
      ),
      body: GridView(
        padding: const EdgeInsets.all(20),
        children: CATEGORIES
            .map((catData) => CategoryItem(
                  id: catData.id,
                  title: catData.title,
                  route: catData.route,
                  color: catData.color,
                  icon: catData.icon,
                ))
            .toList(),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
        ),
      ),
    );
  }

  void _showModalPopup(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          title: Text('Settings'),
          message: Text('Choose one of the variants'),
          actions: [
            CupertinoActionSheetAction(
              child: Text(
                'Import',
                style: TextStyle(color: Colors.indigo),
              ),
              onPressed: () async {
                var list = await FileManager.openFileExplorer();
//                _uploadToRemoteDB(context, list);
                Navigator.pop(context);
              },
            ),
            CupertinoActionSheetAction(
              child: Text(
                'Export',
                style: TextStyle(color: Colors.indigo),
              ),
              onPressed: () {
                Navigator.pop(context);
//                FileManager.exportFile();
              },
            ),
            CupertinoActionSheetAction(
              child: Text(
                'Log out',
                style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Provider.of<Auth>(context, listen: false).logout();
                Navigator.pop(context);
//                FileManager.exportFile();
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text('Cancel'),
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  Future<void> _uploadToRemoteDB(BuildContext context, List<User> users) async {
    final repository = Provider.of<UserRepository>(context, listen: false);

    users.forEach((user) async {
      await repository.addUser(user).catchError((error) {
        print('addUser method error: ${user.name}:${user.password}');
        print('Exception: ${error.toString()}');
      });
    });
  }
}
