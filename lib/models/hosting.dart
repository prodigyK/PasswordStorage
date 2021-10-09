

import 'package:flutter/cupertino.dart';

class Hosting {
  String id;
  String name;
  String hostingName;
  String hostingLogin;
  String hostingPass;
  String rdpIp;
  String rdpLogin;
  String rdpPass;

  factory Hosting.empty() {
    return Hosting(
      id: '',
      name: '',
      hostingName: '',
      hostingLogin: '',
      hostingPass: '',
      rdpIp: '',
      rdpLogin: '',
      rdpPass: '',
    );
  }

  Hosting({
    required this.id,
    required this.name,
    required this.hostingName,
    required this.hostingLogin,
    required this.hostingPass,
    required this.rdpIp,
    required this.rdpLogin,
    required this.rdpPass,
});

  Map<String, String> toJson() {
    return {
      'name': this.name,
      'hostingName': this.hostingName,
      'hostingLogin': this.hostingLogin,
      'hostingPass': this.hostingPass,
      'rdpIp': this.rdpIp,
      'rdpLogin': this.rdpLogin,
      'rdpPass': this.rdpPass,
    };
  }

  factory Hosting.fromJson(Map<String, dynamic> fromJson, {String? docID}) {
    return Hosting(
      id: docID != null ? docID : fromJson['id'],
      name: fromJson['name'],
      hostingName: fromJson['hostingName'],
      hostingLogin: fromJson['hostingLogin'],
      hostingPass: fromJson['hostingPass'],
      rdpIp: fromJson['rdpIp'],
      rdpLogin: fromJson['rdpLogin'],
      rdpPass: fromJson['rdpPass'],
    );
  }

}