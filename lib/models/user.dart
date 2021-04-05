import 'package:flutter/foundation.dart';

class User {
  String id;
  final String name;
  final String password;
  final String description;
  DateTime dateTime = DateTime.now();

  User({
    this.id,
    @required this.name,
    @required this.password,
    this.description,
    this.dateTime,
  });

  factory User.fromJson(Map<String, dynamic> fromJson) {
    return User(
      id: fromJson['id'],
      name: fromJson['name'],
      password: fromJson['password'],
      description: fromJson['description'],
      dateTime: DateTime.parse(fromJson['dateTime']),
    );
  }

  static Map<String, String> toJson(User user) {
    return {
      'name': user.name,
      'password': user.password,
      'description': user.description,
      'dateTime': user.dateTime.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'User{id: $id, name: $name, password: $password, description: $description, _dateTime: $dateTime}';
  }
}
