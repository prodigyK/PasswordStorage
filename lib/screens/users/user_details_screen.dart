import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:password_storage_app/models/user.dart';
import 'package:password_storage_app/providers/user_repository.dart';
import 'package:provider/provider.dart';

class UserDetailScreen extends StatefulWidget {
  static const routeName = '/user-detail-screen';

  @override
  _UserDetailScreenState createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _passwordFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  User _user;
  String userId;
  bool _isNew = false;
  bool firstInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    if (firstInit) {
      final args = ModalRoute.of(context).settings.arguments as Map<String, Object>;
      _user = args != null
          ? args['user'] as User
          : User(id: '', name: '', password: '', description: '', dateTime: DateTime.now());
      if (_user.id == null || _user.id.isEmpty) {
        _isNew = true;
      } else {
        userId = _user.id;
      }
      _usernameController.text = _user.name;
      _passwordController.text = _user.password;
      _descriptionController.text = _user.description;
    }
    firstInit = false;

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _descriptionController.dispose();
    _passwordFocus.dispose();
    _descriptionFocus.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    setState(() {
      _isLoading = true;
    });
    _user.dateTime = DateTime.now();

    if (_isNew) {
      await Provider.of<UserRepository>(context, listen: false)
          .addUser(_user)
          .then((value) => _showSnackbar('Successfully added'))
          .catchError((error) {
        _showSnackbar(error.toString());
      });
    } else {
      await Provider.of<UserRepository>(context, listen: false)
          .updateUser(_user)
          .then((value) => _showSnackbar('Successfully updated'))
          .catchError((error) {
        _showSnackbar(error.toString());
      });
    }
    setState(() {
      _isLoading = false;
    });

    Navigator.of(context).pop();
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, textAlign: TextAlign.center),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isNew ? 'New User' : 'Details'),
        backgroundColor: Colors.green.shade200,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: _usernameController,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        prefixIcon: GestureDetector(
                          child: Icon(FontAwesome5.user),
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: "${_user.name}"));
                            _showSnackbar('Copied to Clipboard');
                          },
                        ),
                        suffixIcon: GestureDetector(
                          child: Icon(Icons.remove_circle_outline),
                          onTap: () {
                            _usernameController.clear();
                          },
                        ),
                      ),
                      style: TextStyle(fontWeight: FontWeight.bold),
//                maxLength: 25,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_passwordFocus);
                      },
                      onSaved: (value) {
                        _user = User(
                          id: userId,
                          name: value,
                          password: _user.password,
                          dateTime: _user.dateTime,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a username';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 5),
                    TextFormField(
                      controller: _passwordController,
                      focusNode: _passwordFocus,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: GestureDetector(
                          child: Icon(Icons.security),
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: "${_user.password}"));
                            _showSnackbar('Copied to Clipboard');
                          },
                        ),
                        suffixIcon: GestureDetector(
                          child: Icon(Icons.remove_circle_outline),
                          onTap: () {
                            _passwordController.clear();
                          },
                        ),
                      ),
                      style: TextStyle(fontWeight: FontWeight.bold),
//                maxLength: 25,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_descriptionFocus);
                      },
                      onSaved: (value) {
                        _user = User(
                          id: userId,
                          name: _user.name,
                          password: value,
                          dateTime: _user.dateTime,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 5),
                    TextFormField(
                      controller: _descriptionController,
                      focusNode: _descriptionFocus,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        prefixIcon: GestureDetector(
                          child: Icon(Icons.description),
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: "${_user.description}"));
                            _showSnackbar('Copied to Clipboard');
                          },
                        ),
                        suffixIcon: GestureDetector(
                          child: Icon(Icons.remove_circle_outline),
                          onTap: () {
                            _descriptionController.clear();
                          },
                        ),
                      ),
                      style: TextStyle(),
//                maxLength: 50,
                      onFieldSubmitted: (_) {},
                      onSaved: (value) {
                        _user = User(
                          id: userId,
                          name: _user.name,
                          password: _user.password,
                          description: value,
                          dateTime: _user.dateTime,
                        );
                      },
                      validator: (value) {
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: CupertinoButton(
                            color: Colors.green.shade300,
                            child: Text(_isNew ? 'Add' : 'Change'),
                            onPressed: _saveForm,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 50,
                            child: OutlinedButton(
                              child: Text('Copy \"USER : PASSWORD\"', style: TextStyle(fontWeight: FontWeight.bold)),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.grey.shade300),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: BorderSide(color: Colors.red),
                                )),
                              ),
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: "${_user.name} : ${_user.password}"));
                                _showSnackbar('Copied to Clipboard');
                              },
                            ),
                          ),
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
