import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart' show ChangeNotifier;

class Encryption with ChangeNotifier {
  final _secureData;

  Encryption(this._secureData);

  Map<String, String> get secureData => _secureData;

  String encrypt({String text}) {
    final key = Key.fromUtf8(_secureData['encryptKey']);
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key));
    final encrypted = encrypter.encrypt(text, iv: iv);

    return encrypted.base64;
  }

  String decrypt({String encoded}) {
    final key = Key.fromUtf8(_secureData['encryptKey']);
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key));
    final decrypted = encrypter.decrypt(Encrypted.fromBase64(encoded), iv: iv);

    return decrypted;
  }
}
