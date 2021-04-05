//import 'dart:io';
//
////import 'package:safe_config/safe_config.dart';
//
//import 'package:flutter/material.dart';
//
//class AppConfig extends Configuration with ChangeNotifier {
//
//  AppConfig(String fileName) : super.fromFile(File(fileName));
//
//  @optionalConfiguration
//  String firebaseLogin;
//  @optionalConfiguration
//  String firebasePass;
//  @optionalConfiguration
//  String firebaseWebKey;
//
//  String get firebaseLogin {
//    return _firebaseLogin;
//  }
//
//  String get firebasePass {
//    return _firebasePass;
//  }
//
//  String get firebaseWebKey {
//    return _firebaseWebKey;
//  }
//}