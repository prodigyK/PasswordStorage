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

  factory User.fromJson(Map<String, dynamic> fromJson, {String docID}) {
    return User(
      id: docID != null ? docID : fromJson['id'],
      name: fromJson['name'],
      password: fromJson['password'],
      description: fromJson['description'],
      dateTime: DateTime.parse(fromJson['dateTime']),
    );
  }

  Map<String, String> toJson() {
    return {
      'name': this.name,
      'password': this.password,
      'description': this.description,
      'dateTime': this.dateTime.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'User{id: $id, name: $name, password: $password, description: $description, _dateTime: $dateTime}';
  }
}
