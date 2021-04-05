

import 'package:flutter/cupertino.dart';

class Hosting {
  String id;
  final String name;
  final String hostingName;
  final String hostingLogin;
  final String hostingPass;
  final String rdpIp;
  final String rdpLogin;
  final String rdpPass;

  Hosting({
    this.id,
    @required this.name,
    @required this.hostingName,
    @required this.hostingLogin,
    @required this.hostingPass,
    @required this.rdpIp,
    @required this.rdpLogin,
    @required this.rdpPass,
});

}