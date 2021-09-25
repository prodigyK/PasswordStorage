import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:password_storage_app/models/user.dart';
import 'package:password_storage_app/providers/user_repository.dart';
import 'package:password_storage_app/screens/users/user_details_screen.dart';
import 'package:password_storage_app/widgets/user_item.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatefulWidget {
  static const routeName = '/user-screen';

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final _searchController = TextEditingController();
  bool isSearch = false;
  bool isLoading = false;
  List<User> originalUsers;
  List<User> searchUsers;
  Sort sort = Sort.ALFABETIC;

  @override
  void initState() {
    Provider.of<UserRepository>(context, listen: false).fetchAndSetUsers(sort);
    searchUsers = Provider.of<UserRepository>(context, listen: false).users;
    super.initState();
  }

  void _search(String searchString) {
    setState(() {
      isSearch = true;
      searchUsers = [];
      originalUsers.forEach((user) {
        if (user.name.toLowerCase().startsWith(searchString)) {
          searchUsers.add(user);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    originalUsers = Provider.of<UserRepository>(context, listen: true).users;
    var users = isSearch ? searchUsers : originalUsers;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade200,
       title: Text('Users'),
        actions: [
          IconButton(
            icon: Icon(Icons.sort_by_alpha),
            onPressed: () {
              sort = Sort.ALFABETIC;
              Provider.of<UserRepository>(context, listen: false).fetchAndSetUsers(sort);
            },
          ),
          SizedBox(width: 10),
          IconButton(
            icon: Icon(Icons.sort),
            onPressed: () {
              sort = Sort.DATETIME;
              Provider.of<UserRepository>(context, listen: false).fetchAndSetUsers(sort);
            },
          ),
          SizedBox(width: 10),
          IconButton(
            icon: Icon(Icons.add_box),
            onPressed: () {
              Navigator.of(context).pushNamed(UserDetailScreen.routeName);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return Provider.of<UserRepository>(context, listen: false).fetchAndSetUsers(sort);
        },
        child: Column(
          children: [
            Container(
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(width: 0.5),
              ),
              child: CupertinoSearchTextField(
                controller: _searchController,
                backgroundColor: Colors.white,
                onChanged: (value) {
                  _search(value);
                },
                onSubmitted: (value) {
                  _search(value);
                },
                onSuffixTap: () {
                  setState(() {
                    _searchController.clear();
                    isSearch = false;
                  });
                  print('on suffix tap');
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemExtent: 60,
                itemCount: users.length,
                itemBuilder: (ctx, i) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(width: 0.3, color: Colors.grey)),
                    ),
                    child: UserItem(users: users, index: i),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
