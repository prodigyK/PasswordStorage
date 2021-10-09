import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:password_storage_app/main.dart';
import 'package:password_storage_app/models/http_exception.dart';

import '../models/user.dart';

enum Sort {
  ALFABETIC,
  DATETIME,
}

class UserRepository with ChangeNotifier {
  final String? _token;
  final String? _userId;
  List<User> _users = []; //DUMMY_USERS;

  UserRepository(this._token, this._userId);

  List<User> get users {
    return [..._users];
  }

  Future<void> fetchAndSetUsers([Sort sort = Sort.ALFABETIC]) async {
    final url = Uri.https(
      secureData['firebaseDb'],
      '/users.json',
      {'auth': _token},
    );
    final response = await http.get(url);
    if (response.statusCode >= 400) {
      print(response.statusCode);
      throw HttpException('Cannot fetch items from remote database');
    }
    final fetchedData = json.decode(response.body) as Map<String, dynamic>;
    List<User> fetchedUsers = [];
    fetchedData.forEach((keyId, valueUser) {
      fetchedUsers.add(User(
        id: keyId,
        name: valueUser['name'],
        password: valueUser['password'],
        description: valueUser['description'],
        dateTime: DateTime.parse(valueUser['dateTime']),
      ));
    });
    if(sort == Sort.ALFABETIC) {
      fetchedUsers.sort((a, b) => a.name.compareTo(b.name));
    } else {
      fetchedUsers.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    }
    _users = fetchedUsers;
    notifyListeners();
  }

  Future<void> addUser(User user) async {
    final url = Uri.https(
      secureData['firebaseDb'],
      '/users.json',
      {'auth': _token},
    );
    final response = await http.post(
      url,
      body: json.encode(user.toJson()),
    );
    if (response.statusCode >= 400) {
      print(response.statusCode);
      throw HttpException('Cannot add new item to remote database');
    }
    user.id = json.decode(response.body)['name'];
    _users.add(user);
    notifyListeners();
  }

  Future<void> updateUser(User user) async {
    final String id = user.id;

    final url = Uri.https(
      secureData['firebaseDb'],
      '/users/$id.json',
      {'auth': _token},
    );
    final response = await http.patch(
      url,
      body: json.encode(user.toJson()),
    );
    if (response.statusCode >= 400) {
      throw HttpException('Cannot update item in remote database');
    }
    print('after response OK');
    final index = _users.indexWhere((user) => user.id == id);
    _users.removeAt(index);
    _users.insert(index, user);
    notifyListeners();
  }

  Future<void> removeUser(User user) async {
    final String id = user.id;

    final url = Uri.https(
      secureData['firebaseDb'],
      '/users/$id.json',
      {'auth': _token},
    );
    final response = await http.delete(
      url,
      body: json.encode(user.toJson()),
    );
    final index = _users.indexWhere((user) => user.id == id);
    _users.removeAt(index);
    notifyListeners();
  }

}
