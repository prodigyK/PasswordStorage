import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:password_storage_app/models/user.dart';
import 'package:password_storage_app/providers/user_firestore_repository.dart';
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
  String searchText = '';
  bool isSearch = false;
  bool isLoading = false;
  List<User>? originalUsers;
  List<User> searchUsers = [];
  List<User> users = [];
  Sort sort = Sort.ALFABETIC;
  bool firstInit = true;
  bool asc = true;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() async {
    if (firstInit) {
      users = await Provider.of<UserFirestoreRepository>(context, listen: false).getAllDocuments();
      firstInit = false;
      setState(() {});
    }
    super.didChangeDependencies();
  }

  void _sortUsers() {
    if (sort == Sort.ALFABETIC) {
      searchUsers.sort((a, b) {
        if (asc) {
          return a.name.compareTo(b.name);
        } else {
          return b.name.compareTo(a.name);
        }
      });
    } else {
      searchUsers.sort((a, b) {
        if (asc) {
          return a.dateTime.compareTo(b.dateTime);
        } else {
          return b.dateTime.compareTo(a.dateTime);
        }
      });
    }
  }

  Future<void> _updateUsers() async {
    users = await Provider.of<UserFirestoreRepository>(context, listen: false).getAllDocuments();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    searchUsers = searchText.isEmpty
        ? users
        : users.where((user) => user.name.toLowerCase().contains(searchText.toLowerCase())).toList();
    _sortUsers();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade200,
        title: Text('Users'),
        actions: [
          IconButton(
            icon: Icon(Icons.sort_by_alpha),
            onPressed: () {
              setState(() {
                sort = Sort.ALFABETIC;
                asc = !asc;
              });
            },
          ),
          SizedBox(width: 10),
          IconButton(
            icon: Icon(Icons.sort),
            onPressed: () {
              setState(() {
                sort = Sort.DATETIME;
                asc = !asc;
              });
            },
          ),
          SizedBox(width: 10),
          IconButton(
            icon: Icon(FontAwesome5.user_plus),
            onPressed: () {
              Navigator.of(context).pushNamed(UserDetailScreen.routeName).then((value) => _updateUsers());
            },
          ),
          SizedBox(width: 10),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _updateUsers,
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
                  setState(() {
                    searchText = value;
                  });
                },
                onSubmitted: (value) {
                  // _search(value);
                },
                onSuffixTap: () {
                  setState(() {
                    searchText = '';
                    _searchController.clear();
                    isSearch = false;
                  });
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemExtent: 60,
                itemCount: searchUsers.length,
                itemBuilder: (ctx, i) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(width: 0.3, color: Colors.grey)),
                    ),
                    child: UserItem(users: searchUsers, index: i, update: _updateUsers),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
