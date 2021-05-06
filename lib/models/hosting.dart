

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

  Hosting({
    this.id,
    this.name,
    this.hostingName,
    this.hostingLogin,
    this.hostingPass,
    this.rdpIp,
    this.rdpLogin,
    this.rdpPass,
});

  static Map<String, String> toJson(Hosting hosting) {
    return {
      'name': hosting.name,
      'hostingName': hosting.hostingName,
      'hostingLogin': hosting.hostingLogin,
      'hostingPass': hosting.hostingPass,
      'rdpIp': hosting.rdpIp,
      'rdpLogin': hosting.rdpLogin,
      'rdpPass': hosting.rdpPass,
    };
  }

  factory Hosting.fromJson(Map<String, dynamic> fromJson) {
    return Hosting(
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